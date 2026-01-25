# Project context

This repository is a simple Jekyll static site that lists art prints from a CSV file.

## Data and assets

- Product data lives in `_data/listing.csv` and is rendered via Liquid as `site.data.listing`.
- Images live in `assets/img/` and are named by row index (1.jpg, 2.jpg, etc.).

## Output

- The site is a single page (`index.html`) with a product grid using the default layout.
- Styling is in `assets/css/site.css`.
