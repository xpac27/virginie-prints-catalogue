require "rake"

desc "Normalize listing.csv into listing_normalized.csv"
task :preprocess do
  sh "ruby scripts/preprocess_listing.rb"
end

desc "Preprocess data then run Jekyll serve"
task :serve do
  sh "ruby scripts/preprocess_listing.rb"
  sh "bundle exec jekyll serve"
end

desc "Preprocess data then run Jekyll build"
task :build do
  sh "ruby scripts/preprocess_listing.rb"
  sh "bundle exec jekyll build"
end
