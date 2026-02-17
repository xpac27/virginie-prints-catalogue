# Virginie Prints Catalogue (Content Repository)

This repository contains catalogue source data only:
- product metadata
- product images

It does not contain website code or build logic.

## Structure

Each product must be stored in its own folder under `_products/`:

```text
_products/<product-slug>/
  index.md
  image.jpg
  optional-extra-image-1.jpg
  optional-extra-image-2.png
  ...
```

## Add a Product

1. Create a new folder in `_products/` using a short slug (lowercase and hyphens recommended).
2. Add `index.md` with front matter metadata.
3. Add the main image as `image.jpg` (required).
4. Commit and push.

## Product Metadata (`index.md`)

Use this format:

```yaml
---
title: "Black Cat"
featured: true
versions:
  - technique: "Screen printing"
    sizes:
      - size: "30x40"
        price: 500
  - technique: "Linocut"
    sizes:
      - size: "A5"
        price: 250
---
```

Rules:
- `title`: product name shown on the website.
- `featured`: optional; if present, must be `true` or `false`.
- `versions`: list of techniques (can be empty).
- each technique has `sizes` (can be empty).
- each size entry needs `size` and `price`.
- each `price` must be greater than `0`.

## Images

- `image.jpg` is required and is the main product preview image.
- Any additional product photos are allowed and can use any filename and extension (`jpg`, `jpeg`, `png`, `webp`).
- Do not use `image.jpg` for additional photos, because that filename is reserved for the main preview image.
- Additional images appear in the website modal gallery.

## Common Edits

- Update price: edit `index.md` in the corresponding product folder.
- Add a new size: add an entry under the correct `versions -> sizes`.
- Add a new technique: add a new item under `versions`.
- Replace main image: overwrite `image.jpg`.
- Add more modal images: add extra image files in the same folder.
