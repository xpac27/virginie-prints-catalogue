# Virginie Prints Listing

Static Jekyll site that renders the product catalogue from `_data/listing.csv` and images from `assets/img/`.
The CSV is preprocessed to fill carry-forward values and add an `Image` column before Jekyll runs.

## Quick start

```bash
bundle install
bundle exec rake serve
```

Then open `http://localhost:4000`.

The preprocess step runs `scripts/preprocess_listing.rb` and writes `_data/listing_normalized.csv`.
