# Project context

This repository is a simple Jekyll static site that lists art prints from a CSV file.

## Data and assets

- Product data lives in `_data/listing.csv` and is rendered via Liquid as `site.data.listing`.
- A preprocess step generates `_data/listing_normalized.csv` with carry-forward values for empty cells (except `Star`) and an `Image` column.
- Images live in `assets/img/` and are named by image index (1.jpg, 2.jpg, etc.).

## Output

- The site is a single page (`index.html`) with a product grid using the default layout.
- Rendering prefers `site.data.listing_normalized` and falls back to `site.data.listing`.
- Styling is in `assets/css/site.css`.
- Client-side sorting is available for price, size, and name via a dropdown hidden in print.
