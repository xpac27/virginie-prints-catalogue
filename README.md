# Virginie Prints Listing

Static Jekyll site that renders products from the `_products/` collection.
Products are generated from `_data/listing_normalized.csv` (derived from `_data/listing.csv`) and include their image and metadata in each product folder.

## Quick start

```bash
bundle install
bundle exec rake serve
```

Then open `http://localhost:4000`.

To regenerate products after editing the CSV:

```bash
bundle exec rake refresh
```

This runs:

- `scripts/preprocess_listing.rb` to create `_data/listing_normalized.csv`.
- `scripts/import_products.rb` to generate `_products/<slug>/index.md` and place images into each product folder.

When adding new products, place their images in `assets/img/` with the numeric index from the CSV before running `bundle exec rake refresh`.
