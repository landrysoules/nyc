# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**nyc** ("Now Your Customer") is a KYC (Know Your Customer) backoffice application built with Spring Boot, JTE templating, HTMX, Alpine.js, and PostgreSQL. It manages customer data (natural persons, legal entities, contracts), validates KYC documents, and enforces two-factor authentication (TOTP).

## Mandatory Workflow

Before any development, always present a structured plan in your response with:
- Numbered steps
- Impacted files
- A complexity estimate

Wait for confirmation before starting.

## Code Conventions

- All code comments and documentation must be written in English.

## Commands

### Prerequisites
```bash
docker-compose up -d   # Start PostgreSQL (required before running the app)
```

### Build & Run
```bash
./mvnw spring-boot:run                  # Run with dev hot-reload
./mvnw clean package                    # Build JAR
./mvnw clean package -DskipTests
```

### Testing
```bash
./mvnw test
./mvnw test -Dtest=KycBackofficeApplicationTests
./mvnw test -Dtest=KycBackofficeApplicationTests#contextLoads
```

## Architecture

### Layer Structure
```
controller/   → HTTP handlers, return JTE template names (full pages or fragments)
service/      → Business logic, orchestrates repositories
repository/   → Spring Data JPA interfaces
model/        → JPA entities: AppUser, NaturalPerson, LegalEntity, Contract, KycDocument, Address
strategy/     → KYC document validation (Strategy Pattern)
config/       → SecurityConfig, TotpConfig
security/     → CustomUserDetails, CustomUserDetailsService
loader/       → DataLoader: seeds admin user + sample data on first boot
```

### Request/Response Flow

Controllers return JTE template names. For HTMX requests, they return fragment paths (e.g. `"fragments/details/natural_person_details_form"`). For full-page navigations, they return top-level templates (`"dashboard"`, `"login"`).

The `DashboardController` handles three entity types (NaturalPerson, LegalEntity, Contract) with a consistent pattern per entity:
- `GET /dashboard/tab/{entity}` → list fragment
- `GET /dashboard/details/{entity}/{id}` → detail shell (read-only + form wrapper)
- `POST /dashboard/validate/{entity}` → live validation fragment (HTMX, no save)
- `POST /dashboard/details/{entity}` → save, returns tab list on success or re-renders form with errors

On save errors, `HX-Retarget` and `HX-Reswap` headers redirect the HTMX swap to the correct container without a full page reload.

Toast notifications use `HxTrigger.toast()` which sets an `HX-Trigger` header — the frontend listens for the `showtoast` event.

### Templating: JTE

Templates in `src/main/jte/`. Structure:
- `layout.jte` — base shell (includes Tailwind CDN, Alpine.js, HTMX)
- `dashboard.jte` — main app page with tab navigation
- `fragments/tabs/` — entity list tables loaded via HTMX tab clicks
- `fragments/details/` — detail shell (`*_details.jte`) wrapping the editable form (`*_details_form.jte`)
- `components/country_dropdown.jte` — reusable Alpine.js country picker component

**JTE boolean attributes** must use smart attribute syntax: `checked="${booleanExpr}"`, `disabled="${booleanExpr}"`. Never use `${condition ? "checked" : ""}` inline — JTE's HTML-aware mode rejects expressions as attribute names.

`developmentMode=true` in `application.properties` — templates reload without restart.

### Live Validation Pattern

Each entity form has a hidden `<div>` with:
```html
hx-post="/dashboard/validate/{entity}"
hx-trigger="keyup delay:500ms from:input, change from:select, customValidation from:body"
hx-sync="this:drop"
hx-swap="morph"
```
`hx-sync="this:drop"` prevents request abort errors in the console (if in-flight, new triggers are dropped; the 500ms debounce handles UX). Never revert to `this:replace`.

### Authentication

Custom two-step flow in `AuthController` — Spring Security standard form login is disabled:
1. POST `/auth/login` → validates credentials, stores username in session as `PRE_AUTH_USER`, returns OTP fragment
2. POST `/auth/verify-otp` → verifies TOTP code, creates `SecurityContext`, redirects to dashboard via `HX-Redirect`

TOTP can be disabled for development via `app.totp.enabled=false` in `application.properties` (any OTP code is accepted when false).

CSRF is disabled (intentional for HTMX POC).

Unauthenticated HTMX requests receive `HX-Redirect: /auth/login` with HTTP 200 (instead of a redirect) so HTMX handles the navigation.

### UI
Use Penguin UI components. Before importing any component in the project, adapt it to work flawlessly with JTE.

### Frontend

`src/main/resources/static/js/`:
- `app.js` — registers Alpine.js components, entry point
- `components/` — one Alpine.js component per entity/feature

No build step. `countryDropdown.js` dispatches a `customValidation` event on the `body` after country selection, which the HTMX validation listener picks up via `customValidation from:body`.

### Seed Data

`DataLoader` runs on startup and creates:
- User `admin` / `password` with a generated TOTP secret (QR code logged to console on first run)
- Sample NaturalPersons, LegalEntities, and Contracts if tables are empty
