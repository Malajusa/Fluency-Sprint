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

This GitHub Pages version is a static app. It can run the practice tool and preview dashboard, but saved data currently lives in each browser's local storage.

That means the teacher dashboard will not yet collect results from different student devices. To make real shared classroom tracking work, connect the app to a backend such as:

- Google Sheets + Apps Script
- Firebase
- Supabase

For now, this is the right version for public preview, design testing, and planning the next build.
