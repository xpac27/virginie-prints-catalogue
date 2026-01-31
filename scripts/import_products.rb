#!/usr/bin/env ruby

require "csv"
require "fileutils"

source_path = File.join(__dir__, "..", "_data", "listing_normalized.csv")
products_root = File.join(__dir__, "..", "_products")
images_root = File.join(__dir__, "..", "assets", "img")

unless File.exist?(source_path)
  warn "Missing #{source_path}"
  exit 1
end

def slugify(value)
  value.to_s.downcase.gsub(/[^a-z0-9]+/, "-").gsub(/\A-+|-+\z/, "")
end

def display_name(value)
  value.to_s.sub(/\ACat\s*-\s*/i, "").strip
end

rows = CSV.read(source_path, headers: true)

name_counts = Hash.new(0)
rows.each do |row|
  name = row["Name"].to_s.strip
  next if name.empty?

  name_counts[name] += 1
end

products = {}
rows.each do |row|
  raw_name = row["Name"].to_s.strip
  next if raw_name.empty?

  product = products[raw_name] ||= {
    raw_name: raw_name,
    title: display_name(raw_name),
    featured: false,
    image_index: nil,
    versions: [],
    version_map: {}
  }

  product[:featured] ||= !row["Star"].to_s.strip.empty?
  image_index = row["Image"].to_s.strip
  product[:image_index] ||= image_index unless image_index.empty?

  technique = row["Techniques"].to_s.strip
  size = row["Size"].to_s.strip
  price = row["Price"].to_s.strip
  next if technique.empty?

  version_entry = product[:version_map][technique]
  unless version_entry
    version_entry = { "technique" => technique, "sizes" => [] }
    product[:versions] << version_entry
    product[:version_map][technique] = version_entry
  end

  version_entry["sizes"] << { "size" => size, "price" => price }
end

existing_folders = Dir.exist?(products_root) ? Dir.children(products_root) : []
FileUtils.mkdir_p(products_root)

used_slugs = {}
new_slugs = []
image_sources = {}
image_locations = {}

rows.each do |row|
  raw_name = row["Name"].to_s.strip
  next if raw_name.empty?

  image_index = row["Image"].to_s.strip
  next if image_index.empty?
  next if image_sources[image_index]

  size = row["Size"].to_s.strip
  old_title = if name_counts[raw_name] > 1 && !size.empty?
                "#{raw_name} - #{size}"
              else
                raw_name
              end

  old_slug = slugify(old_title)
  old_path = File.join(products_root, old_slug, "image.jpg")
  asset_path = File.join(images_root, "#{image_index}.jpg")

  if File.exist?(old_path)
    image_sources[image_index] = old_path
  elsif File.exist?(asset_path)
    image_sources[image_index] = asset_path
  end
end

products.each_value do |product|
  title = product[:title]
  slug = slugify(title)
  base_slug = slug
  counter = 2
  while used_slugs[slug]
    slug = "#{base_slug}-#{counter}"
    counter += 1
  end
  used_slugs[slug] = true
  new_slugs << slug

  folder = File.join(products_root, slug)
  FileUtils.mkdir_p(folder)

  image_index = product[:image_index].to_s.strip
  unless image_index.empty?
    image_dest = File.join(folder, "image.jpg")

    if File.exist?(image_dest)
      image_locations[image_index] ||= image_dest
    elsif image_locations[image_index]
      system("cp", image_locations[image_index], image_dest)
    else
      source_image = image_sources[image_index]
      if source_image && source_image != image_dest && File.exist?(source_image)
        system("git", "mv", source_image, image_dest)
        image_locations[image_index] = image_dest
      elsif source_image == image_dest
        image_locations[image_index] = image_dest
      else
        warn "Missing image for #{product[:title]} (#{image_index})"
      end
    end
  end

  front_matter = []
  front_matter << "---"
  front_matter << "title: \"#{title.gsub("\"", "\\\"")}\""
  front_matter << "featured: #{product[:featured]}"
  front_matter << "versions:"

  product[:versions].each do |version|
    front_matter << "  - technique: \"#{version["technique"].gsub("\"", "\\\"")}\""
    front_matter << "    sizes:"
    version["sizes"].each do |entry|
      size = entry["size"].to_s
      price = entry["price"].to_s.gsub(",", ".")
      front_matter << "      - size: \"#{size.gsub("\"", "\\\"")}\""
      front_matter << "        price: #{price}"
    end
  end

  front_matter << "---"
  File.write(File.join(folder, "index.md"), front_matter.join("\n") + "\n")
end

stale = existing_folders - new_slugs
stale.each do |folder|
  FileUtils.rm_rf(File.join(products_root, folder))
end
