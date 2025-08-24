# Flutter + Self‑Hosted (Docker) Postgres Starter (Open‑Source Only)

A modular Flutter app (iOS/Android/Web) with **email/password auth**, a **public home feed** of “John Doe” cards (from Postgres), and a **gated Profile page**.  
Backend is **100% open‑source**, self‑hosted locally via Docker (Postgres + PostgREST + GoTrue + Storage + Realtime). No cloud services.

## Monorepo Layout
```
.
├── docker/                      # Open-source backend (self-hosted)
│   ├── docker-compose.yml
│   └── .env.example
├── db/
│   └── init.sql                 # Schema + RLS + seed data
└── flutter_app/
    ├── pubspec.yaml
    └── lib/…                    # Modular Flutter app
```

## Prerequisites
- Docker + Docker Compose
- Flutter SDK (3.4+) and platform toolchains for iOS/Android/Web

---

## 1) Start Backend (Local, Open-Source)
```bash
cd docker
cp .env.example .env     # update secrets if needed
docker compose up -d
```
This starts:
- **Postgres** (port 5432)
- **PostgREST** (REST for Postgres, http://localhost:54321)
- **GoTrue** (email/password auth, http://localhost:9999)
- **Storage API** (file storage, http://localhost:5000)
- **Realtime** (ws streaming, http://localhost:4000)

DB is initialized from `../db/init.sql` (people/feed + profiles + RLS + seed “John Doe” rows).

> **Note:** This template avoids connecting Flutter directly to Postgres (unsafe on clients). PostgREST + GoTrue expose safe endpoints and JWT‑based auth—everything is open‑source and self‑hosted.

---

## 2) Run Flutter App
```bash
cd ../flutter_app
flutter pub get
dart run flutter_native_splash:create
```

### Web (Chrome)
```bash
flutter run -d chrome   --dart-define=SUPABASE_URL=http://localhost:54321   --dart-define=SUPABASE_ANON_KEY=local-anon
```

### Android (emulator maps host as 10.0.2.2)
```bash
flutter run -d android   --dart-define=SUPABASE_URL=http://10.0.2.2:54321   --dart-define=SUPABASE_ANON_KEY=local-anon
```

### iOS
Make sure your iOS device/simulator can reach your machine’s IP. Replace `localhost` with your host IP if needed and allow arbitrary loads in dev (ATS) or use proper TLS in prod.

---

## Features
- **Splash screen** via `flutter_native_splash`
- **Public Home**: fetches `people` anonymously (RLS allows anon SELECT)
- **Auth**: email/password sign up & sign in
- **Profile**: gated route (`/profile`) requires a session; users can view/update their profile row
- **Modular structure**: `core/`, `services/`, `models/`, `features/…`
- **Images**: demo images come from `picsum.photos`. You can store real images via the Storage service and save the URL in `people.image_url`.

---

## Configuration
- Update `docker/.env` (copied from `.env.example`) with a strong `JWT_SECRET` and database password for real use.
- Pass backend URL/keys with `--dart-define` (`SUPABASE_URL`, `SUPABASE_ANON_KEY`). For dev they’re set to local defaults.
- If you serve the web app on a different port/host, change `GOTRUE_SITE_URL` in `docker-compose.yml` to match.

---

## Storage (Optional)
To upload an avatar and get a public URL:
1. Create a bucket (via Storage API or psql).
2. Upload file and mark it public (or sign URLs).
3. Save the resulting public URL into `profiles.avatar_url`.

---

## Production Notes
- Put services behind a reverse proxy (Caddy/Nginx), enable TLS.
- Consider a single gateway for PostgREST and GoTrue.
- Switch off `GOTRUE_MAILER_AUTOCONFIRM` and configure email if you want email confirmation flows.
- Tighten RLS as needed; the template is permissive for dev.

---

## Troubleshooting
- **CORS/Redirect issues on Web**: ensure `GOTRUE_SITE_URL` matches your served origin exactly.
- **Android can’t reach backend**: use `http://10.0.2.2:54321` (emulator) or your machine IP on real devices.
- **iOS ATS blocks HTTP**: use HTTPS or relax ATS for dev.

---

## License
MIT — do whatever you like, no cloud required.
