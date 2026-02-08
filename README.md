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
- `scripts/generate_product_images.rb` to generate square responsive derivatives (`320`, `580`, `900`) for each product image.

When adding new products, place their images in `assets/img/` with the numeric index from the CSV before running `bundle exec rake refresh`.

Each product file uses a `versions` list in its front matter:

```yaml
versions:
  - technique: "Screen printing"
    sizes:
      - size: "30x40"
        price: 500
  - technique: "Linocut"
    sizes:
      - size: "A5"
        price: 250
```
