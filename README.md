# Holy Shorts

Simple public PDF library for weekly one-page Jewish religious content.

Stage 1 includes:

- Next.js App Router + TypeScript + Tailwind CSS
- Public routes and admin route scaffolding
- Minimal white design foundation
- ESLint + Prettier configuration

Stage 2 includes:

- Supabase SQL migrations for schema + RLS policies
- Seed category hierarchy for core parasha and holiday categories

## Local Setup

1. Install dependencies:

```bash
npm install
```

2. Create an environment file:

```bash
cp .env.example .env.local
```

3. Start the app:

```bash
npm run dev
```

4. Open [http://localhost:3000](http://localhost:3000).

## Environment Variables

Create `.env.local` with placeholders:

```bash
NEXT_PUBLIC_SUPABASE_URL=your_supabase_project_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_supabase_service_role_key
```

Never commit real secrets.

`SUPABASE_SERVICE_ROLE_KEY` must only be used in trusted server-side code (server actions, route handlers, background jobs, or Supabase Edge Functions). Never expose it in browser code.

## Supabase Migrations

Migrations are in `supabase/migrations`.

Common local workflow:

```bash
supabase db reset
supabase db push
```

## Routes (Stage 1)

Public:

- `/`
- `/p/[slug]`
- `/category/[slug]`

Admin:

- `/admin/login`
- `/admin`
- `/admin/items`
- `/admin/categories`

`/admin` is intentionally not linked from the public UI.

## Quality Commands

```bash
npm run lint
npm run format:check
npm run build
```

## Git/GitHub Workflow

1. `git checkout main`
2. `git pull origin main`
3. `git checkout -b stage/<number>-<name>`
4. Implement changes and validate locally.
5. `git add .`
6. `git commit -m "Clear, meaningful message"`
7. `git push -u origin stage/<number>-<name>`
8. Open a PR to `main`.

## Deployment

This app is Vercel-compatible and can be deployed directly from GitHub.
