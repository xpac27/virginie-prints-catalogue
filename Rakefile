require "rake"

desc "Normalize listing.csv into listing_normalized.csv"
task :preprocess do
  sh "ruby scripts/preprocess_listing.rb"
end

desc "Import products from listing_normalized.csv into _products"
task :products do
  sh "ruby scripts/import_products.rb"
end

desc "Generate responsive square image derivatives for products"
task :images do
  sh "ruby scripts/generate_product_images.rb"
end

desc "Refresh products from listing.csv"
task :refresh do
  sh "ruby scripts/preprocess_listing.rb"
  sh "ruby scripts/import_products.rb"
  sh "ruby scripts/generate_product_images.rb"
end

desc "Preprocess data then run Jekyll serve"
task :serve do
  sh "bundle exec jekyll serve"
end

desc "Preprocess data then run Jekyll build"
task :build do
  sh "bundle exec jekyll build"
end
