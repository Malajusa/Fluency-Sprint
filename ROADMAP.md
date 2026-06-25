# Fluency Sprint Roadmap

Fluency Sprint is intended to become a primary-school maths fluency platform, not just a timed arithmetic game.

The existing GitHub project remains the source of truth. Development should preserve existing working functionality: teacher login, teacher-created classes, student aliases/PINs, Supabase-backed student/class/session data, student practice, 100-second sprint, results, mistake review, preview mode, and GitHub Pages deployment.

## Product aim

Fluency Sprint should help primary students build fluency, confidence, and independence in mathematics through:

- targeted skill pathways;
- explicit strategy support;
- short fluency practice;
- 100-second sprint challenges;
- teacher-visible participation and growth data;
- iPad-friendly classroom use.

The student experience should remain simple, visual, touch-friendly, and focused. The teacher experience should show useful learning information without becoming cluttered.

## Design principles

- Prioritise iPad usability for student-facing pages.
- Use large touch targets, readable numbers, generous spacing, and minimal distractions.
- Keep practice and sprint screens uncluttered.
- Avoid unnecessary scrolling during active practice/sprint.
- Maintain desktop functionality for teacher use.
- Do not collect student emails.
- Students use class code + alias + PIN.
- Teachers use secure email login.
- Keep student data minimal and privacy-conscious.

## Near-term priorities

1. Stabilise and test the current live build.
2. Keep the iPad-first layout work moving, especially student practice/sprint, student join, level selection, and multiplication table selection.
3. Convert the growing list of levels into a structured skill metadata model.
4. Expand the teacher dashboard to use skill metadata for filters, year-level guidance, and future curriculum views.
5. Build the instructional Practice mode so it becomes a skill guide and scaffolded practice page, not just untimed random facts.

## Practice mode direction

The Practice button should open a skill-specific learning/practice page. Each page should explain the skill in student-friendly language, show strategies, model worked examples, provide guided practice, then move students toward independent recall and sprinting.

Suggested page structure:

1. What this skill means
2. Strategy or trick
3. Worked examples
4. Guided practice
5. Independent practice
6. Start sprint / continue practice

## Multiplication and division direction

Multiplication and division should allow exact table selection.

- Students can select tables 2-12.
- Students can choose one or multiple tables.
- Multiplication should optionally include reverse division facts.
- Division should support selected-table division facts directly.
- This should feel like the main multiplication/division workflow, not a hidden level.

## Expanded skill pathways

Planned pathways include:

- friends of 10, 100, 1000, 150, and 1500;
- metric unit conversion across milli, centi, base units, and kilo for metres, litres, and grams;
- early counting foundations such as stable order, one-to-one correspondence, cardinality, subitising, counting on/back, comparing quantities, before/after numbers, missing sequences, and part-part-whole;
- balancing equations;
- order of operations;
- fraction/decimal/percentage conversion;
- fractions of quantities;
- percentages of quantities and discounts;
- adding/subtracting fractions with like denominators;
- adding/subtracting fractions with related denominators.

## WA Curriculum alignment

Use the Western Australian Curriculum as a guide for attributing skills to year levels. This is for teacher view, not student view.

Teacher-facing metadata may include:

- suggested year level;
- strand/sub-strand;
- related skill progression;
- foundational / at-level / extension status.

Students should see simple skill names and pathways, not curriculum-document language.

## Teacher dashboard direction

The dashboard should help teachers understand:

- who is participating;
- who practised recently;
- which skills students are working on;
- accuracy and growth over time;
- operation-level strengths and gaps;
- common errors;
- suggested focus areas.

Future filters should include class, student, operation, skill, year level, curriculum area, and tag/pathway.

## Mistake analysis and observation bank

The first observation bank now derives teacher-facing notes from saved sessions, recent mistakes, readiness focus, operation gaps, practice-to-sprint transfer, participation gaps, and pace patterns.

Future versions should deepen this into more precise repeated-error analysis from student response patterns.

Examples:

- Student often reverses subtraction facts.
- Student knows 5s but struggles with 6s and 7s.
- Student makes errors when bridging through 10.
- Student confuses multiplication and division inverse facts.
- Student is accurate but slow.
- Student improves in practice but not under sprint conditions.
- Student struggles with related denominator fractions.

These should be framed as instructional observations, not labels or diagnoses.

## Diagnostic direction

Add a four-operations fluency diagnostic before challenge selection when ready. It should sample key skills, identify likely strengths and gaps, suggest next practice areas, and give the teacher a concise summary.

## Avatar, rewards, and guide NPC direction

The current reward avatars are a placeholder foundation. The intended student reward system is a customisable cartoon human avatar that students can use to represent themselves without uploading photos or personal images.

Future avatar customisation should include:

- skin colour;
- facial features;
- hair style and colour;
- outfits and accessories;
- celebratory poses.

Students should unlock further customisation options through sprint rewards, proficiency milestones, and trophy achievements. Trophy certificates should be printable by teachers and should feature the student's avatar striking an earned celebration pose.

The app should also include a helpful guide NPC. This character should:

- suggest what a student should focus on next;
- explain tips and tricks for improving fluency;
- point students back to the right practice guide or sprint step;
- use encouraging, concise language;
- avoid labels, diagnoses, or comments that could make students feel ranked.

The NPC should support the learning pathway and teacher guidance. It should not replace teacher judgement.

The first implementation slice can be a text-first guide coach panel that uses saved session evidence and sprint-climb readiness. Later releases can attach that advice to the custom cartoon character and certificate system.

## Data model direction

As the app expands, skills should be represented through structured metadata rather than only hard-coded display strings.

Possible metadata fields:

- skill id;
- display name;
- operation/category;
- year level guidance;
- curriculum link or strand;
- prerequisite skills;
- strategy notes;
- example questions;
- generator rules;
- tags;
- student visibility;
- diagnostic visibility;
- teacher dashboard filter visibility.

Do not force all metadata at once, but avoid decisions that make future expansion difficult.

## Privacy expectations

- Teacher email login is acceptable.
- Do not require student email.
- Students use alias + PIN.
- Avoid unnecessary student identifiers.
- No student DOB, addresses, parent details, photos, behaviour notes, or sensitive information.
- Teacher emails should remain with the authentication provider where possible.
- App tables should use teacher_id rather than duplicating teacher email.
- Use Supabase Row Level Security or equivalent protections for all class/student/session data.
- One teacher must not be able to access another teacher's class data.
- Students must not be able to access other students' results.

## Implementation constraints

- Do not remove existing working features.
- Do not break Supabase-backed class/student/session storage.
- Do not break GitHub Pages deployment.
- Keep the app usable as a single-page app.
- Maintain student login through class code + alias + PIN.
- Maintain teacher dashboard access behind teacher login.
- Prioritise iPad usability.
- Make changes incrementally where possible.
- Run syntax checks after edits.
- Test the main flows where possible: teacher login, class/student management, student join, practice, sprint, results, and dashboard.
