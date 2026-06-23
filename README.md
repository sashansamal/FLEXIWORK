# FlexiWork

A temporary-workforce management platform for Sri Lanka — "PickMe for daily labour". It connects
companies (hotels, factories, restaurants, event organisers) with verified blue-collar workers for
next-day temporary jobs, with QR-based attendance, a 10% commission model, PDF receipts, and
WhatsApp/email notifications.

Built for the **Development of Enterprise Applications** module.

---

## Tech stack

| Layer | Technology |
|---|---|
| Backend | Spring Boot 3.3 (Java 21), layered Controller → Service → Repository → Entity |
| Database | MySQL 8 + Spring Data JPA |
| Security | Spring Security — **dual** filter chains (stateless JWT for the API, session+cookie+CSRF for the admin) |
| Frontend (workers/companies) | React 18 + Vite, plain CSS, mobile-first |
| Admin panel | Thymeleaf (server-rendered, CSRF, PUT/DELETE method override) |
| Maps | react-leaflet + OpenStreetMap (no API key); Google Maps deep links for navigation |
| QR | zxing (generation) + html5-qrcode (scanning) |
| PDF | openhtmltopdf |
| Notifications | Meta WhatsApp Cloud API (WebClient) + Gmail SMTP (email OTP) |
| API docs | springdoc-openapi (Swagger UI) |

---

## Architecture

```
React (Vite, :5173)  ──proxy /api──►  Spring Boot (:8080)
  • workers, companies, guard kiosk        ├─ /api/**   JWT chain (stateless)
  • JWT in localStorage                     └─ /admin/** session chain (CSRF)
                                                 │
Thymeleaf admin (server-rendered) ───────────────┘
                                          Service layer
                                          Repository (Spring Data JPA + Specifications)
                                          MySQL 8
```

Eight JPA entities (all auditable): `User`, `CompanyProfile`, `WorkerProfile`, `JobPost`,
`Application`, `Attendance`, `Payment`, `OtpToken`.

---

## Prerequisites

- **JDK 21** (Temurin recommended)
- **Maven 3.9+**
- **MySQL 8** running locally
- **Node.js 18+** (for the React frontend)

---

## Setup & run

### 1. Database
MySQL must be running. The app auto-creates the `flexiwork` schema on first run
(`createDatabaseIfNotExist=true`). Set your MySQL root password in
`src/main/resources/application.yml` (default assumes `root` / `root`):

```yaml
spring:
  datasource:
    username: root
    password: root
```

### 2. Backend
```bash
# from the project root
mvn spring-boot:run
```
The API starts on **http://localhost:8080**. On first run a `CommandLineRunner` seeds demo
accounts and jobs (skipped if any users already exist).

- Swagger UI: **http://localhost:8080/swagger-ui.html** (click **Authorize**, paste a JWT from `/api/auth/login`)
- Admin panel: **http://localhost:8080/login**

### 3. Frontend
```bash
cd frontend
npm install
npm run dev
```
The React app starts on **http://localhost:5173** and proxies `/api` to the backend.

### 4. Tests
```bash
mvn test
```

---

## Demo accounts

| Role | Email | Password | Notes |
|---|---|---|---|
| Admin | `admin@flexiwork.lk` | `Admin@123` | Thymeleaf admin panel (`/login`) |
| Company owner | `hr@serendibresorts.lk` | `Company@123` | VERIFIED — "Serendib Resorts", Galle |
| Company guard | `guard@serendibresorts.lk` | `Guard@123` | Kiosk scanner only |
| Company poster | `poster@serendibresorts.lk` | `Poster@123` | Post/manage jobs only |
| Company owner | `ops@lankaharvest.lk` | `Company@123` | VERIFIED — "Lanka Harvest Logistics", Kurunegala |
| Company owner | `bookings@cinnamongrove.lk` | `Company@123` | VERIFIED — "Cinnamon Grove Events", Kandy |
| Worker | `nimal.silva@gmail.com` | `Worker@123` | VERIFIED, Galle |
| Worker | `ishara.fernando@gmail.com` | `Worker@123` | VERIFIED, Kurunegala |
| Worker | `ravindu.bandara@gmail.com` | `Worker@123` | VERIFIED, Kandy |
| Worker | `dilini.perera@gmail.com` | `Worker@123` | VERIFIED, Colombo |

> **Notifications are stubbed by default** (`flexiwork.whatsapp.enabled=false`, blank SMTP).
> WhatsApp messages and email OTP codes are **logged to the server console** instead of sent —
> watch the log to grab OTP codes during the demo. The payment gateway is simulated. To enable
> real delivery, set the WhatsApp token / phone-number-id and Gmail app password in
> `application.yml`.

---

## Configuration (`application.yml`)

| Key | Purpose |
|---|---|
| `flexiwork.jwt.secret` / `.expiration-ms` | JWT signing + TTL |
| `flexiwork.uploads.dir` | Disk location for uploaded files & QR images |
| `flexiwork.payment.commission-rate` | Platform commission (default `0.10`) |
| `flexiwork.whatsapp.*` | Meta WhatsApp Cloud API token / phone-number-id / enabled flag |
| `flexiwork.otp.*` | OTP length, TTL, max attempts, resend cooldown |
| `spring.mail.*` | Gmail SMTP credentials for email OTP |

The **prod profile** (`application-prod.yml`, run with `--spring.profiles.active=prod`) hardens
session cookies to `HttpOnly + Secure + SameSite=strict`.

---

## Requirements mapping

| # | Requirement | Where |
|---|---|---|
| 1 | Sign up / in / out | `AuthController`, `RegistrationController`, React `Login`/`*Register` |
| 2 | Session+cookie login **with** JWT | Dual chains in `SecurityConfig` (JWT `/api/**`, session `/admin/**`) |
| 3 | Role-based authz + protected routes | `@PreAuthorize` (5 roles) + React `ProtectedRoute` |
| 4 | ≥2 entities with relationships | 8 entities in `entity/` |
| 5 | Full CRUD on a main entity | `JobController` / `JobService` (JobPost) |
| 6 | Pagination + filtering | `GET /api/jobs` via `JobPostSpecifications` + `Pageable` |
| 7 | Bean Validation + friendly UI messages | DTO constraints + `GlobalExceptionHandler` field map + React inline errors |
| 8 | Centralised error handling, proper codes | `GlobalExceptionHandler` (`@RestControllerAdvice`) |
| 9 | HttpOnly/Secure/SameSite cookies in prod | `application-prod.yml` |
| 10 | CSRF on form posts | Admin chain (`CookieCsrfTokenRepository`) + Thymeleaf forms |
| 11 | JPA + seed data | Entities + `DataSeeder` |
| 12 | Layered architecture | `controller` → `service` → `repository` → `entity` |
| 13 | API documentation | springdoc / `OpenApiConfig` (`/swagger-ui.html`) |
| 14 | ≥2 "beyond CRUD" (6 built) | Specifications filtering; file uploads w/ server-side validation; email+WhatsApp OTP/notifications; external APIs (WhatsApp Cloud, OSM, Google Maps, payment gateway); PDF export; JPA audit trail |
| 15 | PUT/DELETE method override | Admin Thymeleaf forms (`_method` + `HiddenHttpMethodFilter`) |
| 16 | Graceful 400/401/403/404 | `GlobalExceptionHandler` + `RestAuthEntryPoint` |
| 17 | Tests | `PaymentServiceTest`, `JobControllerTest`, `JobPostRepositoryTest` |
| 18 | README | this file |

---

## Key flows

- **Worker registration** — 3 steps (details → KYC files → WhatsApp OTP). Account is PENDING until
  an admin verifies the NIC photos.
- **Company registration** — details + BR certificate/logo/premises upload + Leaflet location pin.
  PENDING until an admin verifies the BR certificate.
- **Apply → accept → QR** — worker applies; company accepts → a unique QR token + image is issued
  and sent over WhatsApp; the job auto-fills and remaining applicants are auto-rejected.
- **Attendance** — guard scans the QR at the gate; validated against company + today's date +
  duplicate check.
- **Completion & commission** — company marks the job completed; commission (10%) is billed on the
  **verified attendances only**; pay via the simulated gateway; download a PDF receipt/invoice.

---

## Screenshots

_Add screenshots here:_
- [ ] Public job feed (filters + chips)
- [ ] Worker 3-step registration
- [ ] Company post-job map pin
- [ ] Guard kiosk scanner
- [ ] Payments + PDF receipt
- [ ] Thymeleaf admin verification pages
- [ ] Swagger UI

---

## Project structure

```
DEA-01/
├─ src/main/java/com/flexiwork/
│  ├─ config/        security (dual chains), JWT, OpenAPI, auditing, caching, seed
│  ├─ entity/        8 entities + enums
│  ├─ repository/    Spring Data JPA + JobPostSpecifications
│  ├─ dto/           request/response records
│  ├─ service/       business logic (+ payment/ gateway, notifications)
│  ├─ controller/    REST endpoints
│  ├─ admin/         Thymeleaf admin controller
│  ├─ security/      JWT filter, principal, entry point
│  └─ exception/     global handler + custom exceptions
├─ src/main/resources/
│  ├─ application.yml, application-prod.yml
│  ├─ templates/admin/   Thymeleaf pages
│  └─ static/css/        admin styles
├─ src/test/java/…    unit, MockMvc, @DataJpaTest
└─ frontend/          React + Vite app
```
