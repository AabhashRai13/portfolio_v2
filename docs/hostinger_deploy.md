# Hostinger Routing And Blog Media

## Routing

The website uses path-based routing on Flutter web, so refresh and deep links
such as `/blog` and `/blog/my-first-blog-post` require Apache rewrite rules.

The source of truth for that is:

- `web/.htaccess`

CI copies that file into `build/web/.htaccess` before deployment, so every
deploy keeps routing working.

## Blog images

Blog cover images should be uploaded manually to Hostinger in:

- `public_html/blog-media/`

Use the resulting public URLs in Firestore, for example:

- `https://aabhashrai.com/blog-media/flutter-recommended-architecture-cover.jpg`

## Why this folder is safe

The deploy workflow uses `lftp mirror -R --delete`, which would normally remove
remote files that are not present in `build/web`.

To protect manually uploaded blog images, CI excludes:

- `blog-media`
- `blog-media/**`

That means:

- `.htaccess` is repo-managed and always deployed
- `blog-media/` is Hostinger-managed and preserved across deploys

## Upload checklist

1. Open Hostinger File Manager
2. Go to `public_html/blog-media/`
3. Upload your blog image
4. Copy the public URL
5. Put that URL into Firestore `coverImageUrl`
