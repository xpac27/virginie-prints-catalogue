# Project context

This repository is a simple Jekyll static site that lists art prints from a CSV file.

## Data and assets

- Product source data lives in `_data/listing.csv`.
- A preprocess step generates `_data/listing_normalized.csv` with carry-forward values for empty cells (except `Star`) and an `Image` column.
- Products are generated into `_products/<slug>/` with `index.md` and `image.jpg` for each row.
- A derivative step generates `image-square-320.jpg`, `image-square-580.jpg`, and `image-square-900.jpg` per product.
- Use `bundle exec rake refresh` to rebuild `_products` from the CSV sources.
- New images are sourced from `assets/img/` using the `Image` index during refresh.
- Each product `index.md` uses a `versions` list to capture techniques with per-size prices.

## Output

- The site is a single page (`index.html`) with a product grid using the default layout.
- Rendering uses the `products` collection (`site.products`).
- Styling is in `assets/css/site.css`.
- Client-side sorting is available for name and price (low/high), plus a size filter dropdown; controls are hidden in print.
