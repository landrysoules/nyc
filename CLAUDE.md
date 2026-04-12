# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**nyc** ("Now Your Customer") is a KYC (Know Your Customer) backoffice application built with Spring Boot 4.0.5, JTE templating, HTMX, and PostgreSQL. It manages customer data (natural persons, legal entities, contracts), validates KYC documents, and enforces two-factor authentication (TOTP).

## Mandatory Workflow

Before any development, always present a structured plan in your response with:
- Numbered steps
- Impacted files
- A complexity estimate

Wait for my confirmation before starting.

## Code conventions

- All code commentsand documentation should be written in english.
## Commands

### Prerequisites
Start the PostgreSQL database (required before running the app):
```bash
docker-compose up -d
```

### Build & Run
```bash
./mvnw spring-boot:run        # Run with dev hot-reload
./mvnw clean package          # Build JAR
./mvnw clean package -DskipTests
```

### Testing
```bash
./mvnw test                                          # All tests
./mvnw test -Dtest=KycBackofficeApplicationTests     # Single test class
./mvnw test -Dtest=KycBackofficeApplicationTests#contextLoads  # Single method
```

## Architecture

### Layer Structure
```
controller/   → HTTP handlers, return JTE fragments or redirects
service/      → Business logic, orchestrates repositories
repository/   → Spring Data JPA interfaces
model/        → JPA entities (AppUser, NaturalPerson, LegalEntity, Contract, KycDocument, Address)
strategy/     → KYC validation strategies (Strategy Pattern)
config/       → SecurityConfig (Spring Security), TotpConfig (2FA)
security/     → CustomUserDetails, CustomUserDetailsService
loader/       → DataLoader (initial seed data)
```

### Templating: JTE
Templates live in `src/main/jte/`. The app uses a fragment-based approach compatible with HTMX — controllers return partial HTML fragments for dynamic updates. `layout.jte` is the base layout. Detail views, forms, and tab content are in `fragments/`.

JTE is in `developmentMode=true` (see `application.properties`), so templates reload without restart.

### Authentication Flow
1. User submits credentials → `AuthController` validates password via `CustomUserDetailsService`
2. If valid, a TOTP code is required → OTP verified via `TotpConfig` before session is established
3. Spring Security does **not** use standard form login — the flow is fully custom via `AuthController`

CSRF is disabled (intentional for HTMX POC, noted in `SecurityConfig`).

### KYC Validation (Strategy Pattern)
`KycValidatorFactory` selects the appropriate `KycValidationStrategy` at runtime:
- `DefaultKycValidator` — standard document validation
- `StrictBankKycValidator` — stricter rules for bank-specific cases

### Database
PostgreSQL on `localhost:5432/kyc_db` (user: `kycuser`, password: `kycpassword`). Hibernate manages schema with `ddl-auto: update`.

### Frontend
Static JS lives in `src/main/resources/static/js/`. Files are per-entity (`naturalPersonForm.js`, `contractForm.js`, etc.) and coordinate HTMX interactions. No build step — plain JS served directly.
