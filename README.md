# Trafford Property Management Website

A static website for Trafford Property Management and Trafford Stays. The files
are structured so they can be uploaded directly to GoDaddy hosting, while Git
tracks the source changes between uploads.

## Static Website Files

- `index.html`: main Trafford Property Management homepage
- `stays/index.html`: Trafford Stays landing page
- `properties/index.html`: property listing page
- `properties/stratford-townhouse/index.html`: example property detail page
- `app/globals.css`: shared brand palette, typography, layout, and responsive styling
- `public/`: logo, favicon, and shared image assets

## Review Package

The review/upload zip is generated output and is ignored by Git:

```bash
zip -r Trafford-Property-Management-website-review.zip index.html app/globals.css public stays properties
```

Do not commit the zip. Commit the source files listed above instead.

## Recommended Git Workflow

Check the current changes:

```bash
git status
git diff
```

Commit a finished change:

```bash
git add index.html app/globals.css public stays properties README.md .gitignore .gitattributes
git commit -m "Describe the website change"
```

Tag the exact version uploaded to GoDaddy:

```bash
git tag godaddy-upload-YYYY-MM-DD
```

Use a branch for larger experiments:

```bash
git switch -c codex/booking-calendar
```

## Contact Details

- Information requests: `info@traffordpropertymanagement.co.uk`
- General enquiries: `enquiries@traffordpropertymanagement.co.uk`
- Phone: `+44 01789 863933`
