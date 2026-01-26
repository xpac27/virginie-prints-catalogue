#!/usr/bin/env ruby

require "csv"
require "fileutils"

def escape_yaml(value)
  value.to_s.gsub("\"", "\\\"")
end

source_path = File.join(__dir__, "..", "_data", "listing_normalized.csv")
products_root = File.join(__dir__, "..", "_products")
images_root = File.join(__dir__, "..", "assets", "img")

unless File.exist?(source_path)
  warn "Missing #{source_path}"
  exit 1
end

rows = CSV.read(source_path, headers: true)

name_counts = Hash.new(0)
rows.each do |row|
  name = row["Name"].to_s.strip
  next if name.empty?

  name_counts[name] += 1
end

FileUtils.mkdir_p(products_root)

used_slugs = {}
image_locations = {}

rows.each do |row|
  name = row["Name"].to_s.strip
  next if name.empty?

  size = row["Size"].to_s.strip
  title = name
  if name_counts[name] > 1 && !size.empty?
    title = "#{name} - #{size}"
  end

  slug = title.downcase.gsub(/[^a-z0-9]+/, "-").gsub(/\A-+|-+\z/, "")
  base_slug = slug
  counter = 2
  while used_slugs[slug]
    slug = "#{base_slug}-#{counter}"
    counter += 1
  end
  used_slugs[slug] = true

  folder = File.join(products_root, slug)
  FileUtils.mkdir_p(folder)

  image_index = row["Image"].to_s.strip
  image_dest = File.join(folder, "image.jpg")
  image_path = "/_products/#{slug}/image.jpg"

  if !image_index.empty?
    if File.exist?(image_dest)
      image_locations[image_index] ||= image_dest
    elsif image_locations[image_index]
      system("cp", image_locations[image_index], image_dest)
    else
      source_image = File.join(images_root, "#{image_index}.jpg")
      if File.exist?(source_image)
        system("git", "mv", source_image, image_dest)
        image_locations[image_index] = image_dest
      else
        warn "Missing image: #{source_image}"
      end
    end
  end

  price = row["Price"].to_s.strip
  techniques = row["Techniques"].to_s.strip
  star = row["Star"].to_s.strip
  featured = !star.empty?

  front_matter = []
  front_matter << "---"
  front_matter << "title: \"#{escape_yaml(title)}\""
  front_matter << "size: \"#{escape_yaml(size)}\"" unless size.empty?
  front_matter << "techniques: \"#{escape_yaml(techniques)}\"" unless techniques.empty?
  front_matter << "price: \"#{escape_yaml(price)}\"" unless price.empty?
  front_matter << "featured: #{featured}"
  front_matter << "image_index: \"#{escape_yaml(image_index)}\"" unless image_index.empty?
  front_matter << "image_path: \"#{escape_yaml(image_path)}\""
  front_matter << "---"

  File.write(File.join(folder, "index.md"), front_matter.join("\n") + "\n")
end
