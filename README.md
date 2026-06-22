# Fluency Sprint on GitHub Pages

This folder is ready to upload to a GitHub repository and publish with GitHub Pages.

## Files

- `index.html` is the app.
- `.nojekyll` tells GitHub Pages to publish the folder exactly as-is.

## Simple GitHub Setup

1. Create a new GitHub repository.
2. Upload the contents of this folder, not the folder itself.
3. In the repository, open `Settings`.
4. Go to `Pages`.
5. Under `Build and deployment`, choose `Deploy from a branch`.
6. Choose the `main` branch and the `/root` folder.
7. Save.
8. GitHub will give you a public URL after it finishes publishing.

## Important Data Note

This GitHub Pages version now points at a Supabase project for shared teacher/class/student/session storage.

Before using real classroom data:

- Run `supabase-schema.sql` in the Supabase SQL Editor.
- Keep the Supabase service role key private.
- Use only the publishable/anon key in `index.html`.
- Test with two teacher accounts to confirm one teacher cannot see another teacher's classes.

The app still includes Preview Mode, which uses temporary demo data and does not touch Supabase.
