#!/usr/bin/env ruby

require "csv"

source_path = File.join(__dir__, "..", "_data", "listing.csv")
output_path = File.join(__dir__, "..", "_data", "listing_normalized.csv")

headers = CSV.read(source_path, headers: true).headers
headers = (headers || []) + ["Image"]

last_values = {}
image_index = 0

CSV.open(output_path, "w", write_headers: true, headers: headers) do |out|
  CSV.foreach(source_path, headers: true) do |row|
    name_value = row["Name"]
    if name_value && !name_value.strip.empty?
      image_index += 1
    end

    row.headers.each do |header|
      next if header == "Star"

      value = row[header]
      if value.nil? || value.strip.empty?
        row[header] = last_values[header]
      else
        last_values[header] = value
      end
    end

    if row["Techniques"]
      techniques_value = row["Techniques"].strip
      row["Techniques"] = case techniques_value
                          when "L"
                            "Linocut"
                          when "S"
                            "Screen printing"
                          else
                            techniques_value
                          end
    end

    row["Image"] = image_index
    out << headers.map { |header| row[header] }
  end
end
