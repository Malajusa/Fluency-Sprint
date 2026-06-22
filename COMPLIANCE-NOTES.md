# Fluency Sprint Compliance Notes

These notes are for checking Fluency Sprint against the WA Department of Education Students Online in Public Schools Policy and Procedures. They are a practical product checklist, not legal approval.

Official references:
- Students Online in Public Schools Policy: https://www.education.wa.edu.au/web/policies/-/students-online-in-public-schools-policy
- Students Online in Public Schools Procedures: https://www.education.wa.edu.au/web/policies/-/students-online-in-public-schools-procedures

## What The App Stores

Teacher data:
- Teacher email and authentication details through Supabase Auth
- Teacher display name
- Class names and class codes

Student data:
- First name and last name entered by the teacher
- Generated student alias, such as "M Smith"
- Hashed student PIN, never displayed after saving
- Practice/sprint results, accuracy, streaks, mistakes, operation, level, and timestamps

Not stored:
- Student email addresses
- Student photos
- Student uploads
- Student chat/messages
- Home addresses, phone numbers, parent details, or other sensitive information

## Current Safeguards

- Students log in with class code, alias, and PIN, not email.
- Student PINs are hashed in the database and hidden after saving.
- QR login cards include class code and alias only. They do not include the PIN.
- Teacher dashboard data is protected by Supabase row-level security.
- Teachers can only view their own classes, students, results, and audit log rows.
- Removing a student anonymises the student name and alias, removes active login access, and keeps only anonymised score history.
- Removing a class anonymises student names and aliases attached to that class.
- The app has no ads, social features, public student profile pages, image uploads, or external student publishing features.

## School Approval Checklist

Before using this with real students, the school should:

1. Confirm the app is for a genuine teaching and learning need.
2. Check whether Supabase, GitHub Pages, and any hosted script/CDN services are approved third-party services for the school.
3. If required, complete the Department third-party service risk assessment or approval process.
4. Use the school notification/consent process for any student personal information stored in the app.
5. Confirm students have an Acceptable Use Agreement and have been taught safe online practices.
6. Supervise use during class.
7. Enter only school-approved student identifiers.
8. Keep printed QR login cards private and hand them directly to students.
9. Avoid posting class codes, QR cards, or student aliases publicly.
10. Remove/anonymise student data when it is no longer needed.

## Supabase Setup Checklist

- Keep Row Level Security enabled on all tables.
- Do not put the Supabase service role key in GitHub, the app, or any browser code.
- Use only the public publishable key in the static site.
- Keep teacher email confirmation enabled.
- Set the Supabase Auth site URL to the live GitHub Pages URL.
- Restrict redirect URLs to known app URLs.
- Use strong teacher passwords and MFA if available.
- Keep "Automatically expose new tables" disabled where possible, so new database tables are not accidentally made available through the API.

## Residual Risks

- The app uses third-party services, so school approval may still be required.
- Student first and last names are personal information. If the school prefers less identifiable data, use first name plus last initial, initials only, or school-approved aliases instead.
- CSV exports and printed QR cards become teacher-managed records and should be stored securely.
- Open-source code is acceptable only if no private keys or private student data are published. The public app code can show how the app works, but it must not contain secrets.

## Recommended Data Minimisation Option

For the strongest privacy posture, configure classroom practice to use:
- Student first name plus last initial, or
- Teacher-created aliases, or
- School-approved student identifiers

This reduces the amount of personal information stored while still allowing teachers to track progress.
