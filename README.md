# notebase-keycloak

Keycloak for NoteBase, plus the `notebase` login theme (Georgian by default).

```
themes/notebase/login/
  theme.properties          parent theme, locales, CSS class mapping
  template.ftl              page layout shared by every login page
  login.ftl                 sign in
  register.ftl              registration
  login-reset-password.ftl  forgot password
  messages/                 Georgian (ka) and English texts
  resources/css/notebase.css
  resources/img/            logo, favicon
```

Other Keycloak pages (update password, verify email, OTP, errors) use Keycloak's
base templates inside the same layout and styles.

## Run locally

Requires Docker Desktop.

```bash
docker compose -f docker-compose.dev.yml up
```

| What | URL | Login |
|---|---|---|
| Login page | http://localhost:8080/realms/notebase-dev/account | `student` / `student` |
| Admin console | http://localhost:8080/admin | `admin` / `admin` |
| Emails (password reset) | http://localhost:8025 | |

The dev realm (`dev/notebase-dev-realm.json`) already uses the `notebase` theme
in Georgian, with registration, "remember me" and password reset turned on.
Theme caching is off in dev mode: edit a file under `themes/` and refresh the
browser. Changes to `theme.properties` or `messages/` need a container restart.

Stop with `Ctrl+C`, or `docker compose -f docker-compose.dev.yml down` (this
also wipes the dev database, so the realm gets re-imported next time).

## Turn it on in production

After the theme is merged to `main` and deployed:

1. Admin console → realm → **Realm settings → Themes** → Login theme: `notebase`.
2. **Realm settings → Localization**: turn on Internationalization, set
   Supported locales to `ka` (add `en` to show a language switch), Default locale `ka`.
   Without this step Keycloak shows the pages in English.
3. **Realm settings → Login**: turn on User registration, Forgot password and
   Remember me as needed. Forgot password also needs SMTP under **Realm settings → Email**.
