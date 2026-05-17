# Productivity Services

Spectre runs the productivity services behind Traefik internal-only routes. These services are reachable from the LAN or VPN through local DNS/host mappings, including Kernelpanic's `extraHosts` entries pointing the service names to Spectre at `10.0.0.71`.

Forgejo is intentionally left for later.

## Services

| Service | Purpose | URL | Backend |
| :--- | :--- | :--- | :--- |
| Paperless-ngx | Document management and OCR | `https://paperless.burdznest.com` | `127.0.0.1:28981` |
| Karakeep | Bookmarks and read-later archive | `https://bookmarks.burdznest.com` | `127.0.0.1:3000` |
| Homepage | Homelab landing page and service links | `https://home.burdznest.com` | `127.0.0.1:3010` |
| CyberChef | Data transforms and encoding/decoding utilities | `https://cyberchef.burdznest.com` | `127.0.0.1:8088` |
| IT-Tools | Developer and admin utility toolbox | `https://it-tools.burdznest.com` | `127.0.0.1:8089` |
| Shlink server | Short-link redirects/API | `https://s.burdznest.com` | `127.0.0.1:8082` |
| Shlink web client | Shlink management UI | `https://links.burdznest.com` | `127.0.0.1:8083` |

All productivity routes currently use Traefik's `security-headers` and `internal-only` middlewares. CyberChef, IT-Tools, and Shlink's web client also use the `authelia` middleware, so they require an Authelia login from the LAN/VPN. Shlink's redirect/API route stays internal-only and is not behind Authelia so short slug redirects and API behavior remain normal; make `s.burdznest.com` public only if short links should work outside the LAN/VPN.

## Implementation

| Component | Details |
| :--- | :--- |
| Paperless-ngx | `services.paperless` enabled on `127.0.0.1:28981` |
| Paperless admin password | `/var/lib/paperless/admin-password` via `services.paperless.passwordFile` |
| Paperless settings | `PAPERLESS_URL=https://paperless.burdznest.com`, `PAPERLESS_CSRF_TRUSTED_ORIGINS=https://paperless.burdznest.com`, `PAPERLESS_TIME_ZONE=Asia/Singapore`, `PAPERLESS_OCR_LANGUAGE=eng` |
| Karakeep | `services.karakeep` enabled on port `3000` |
| Karakeep supporting services | Meilisearch and browser support enabled |
| Karakeep settings | `NEXTAUTH_URL=https://bookmarks.burdznest.com`, `DISABLE_SIGNUPS=true`, `DISABLE_NEW_RELEASE_CHECK=true` |
| Homepage | `services.homepage-dashboard` enabled on `127.0.0.1:3010` |
| Homepage route | `home.burdznest.com` proxies to `http://127.0.0.1:3010` with `security-headers` and `internal-only` |
| Homepage settings | `allowedHosts = "home.burdznest.com"` is required so reverse-proxied requests do not return `403` |
| Homepage widgets | Links-only for now; no API-key widgets or secrets are configured yet |
| CyberChef route | `cyberchef.burdznest.com` proxies to `http://127.0.0.1:8088` with `security-headers`, `internal-only`, and `authelia` |
| IT-Tools route | `it-tools.burdznest.com` proxies to `http://127.0.0.1:8089` with `security-headers`, `internal-only`, and `authelia` |
| Shlink | `shlinkio/shlink:stable` container through Podman |
| Shlink bind | Container port `8080` published as `127.0.0.1:8082` |
| Shlink data | `/var/lib/shlink/data` mounted to `/etc/shlink/data`, owned by container UID/GID `1001:1001` |
| Shlink secrets | `/var/lib/shlink/secrets.env` |
| Shlink settings | `DEFAULT_DOMAIN=s.burdznest.com`, `IS_HTTPS_ENABLED=true`, `DEFAULT_SHORT_CODES_LENGTH=5`, `WEB_WORKER_NUM=2`, `TASK_WORKER_NUM=2`, `DB_DRIVER=sqlite` |
| Shlink startup gate | `podman-shlink` waits for `/var/lib/shlink/secrets.env` |
| Shlink web client | `shlinkio/shlink-web-client:latest` container through Podman |
| Shlink web client bind | Container port `8080` published as `127.0.0.1:8083` |
| Shlink web client route | `links.burdznest.com` proxies to `http://127.0.0.1:8083` with `security-headers`, `internal-only`, and `authelia` |

## Persistence and backups

Active service state stays local on Spectre. Dirtycow is the backup target, not the active app-data location.

Do not move live SQLite, PostgreSQL, or application state directories directly under `/mnt/backups` or another NFS mount. NFS is appropriate for backups and media storage, but it is risky for live database/state workloads because latency, locking behavior, and atomic filesystem operations can differ from local disk expectations.

Current active state paths:

| Service | Active state on Spectre | Backup coverage |
| :--- | :--- | :--- |
| Paperless-ngx | `/var/lib/paperless` | Backed up by restic; also exported to `/mnt/backups/paperless/export` |
| Karakeep | `/var/lib/karakeep` | Backed up by restic |
| Meilisearch for Karakeep | `/var/lib/meilisearch` | Backed up by restic |
| Shlink | `/var/lib/shlink` | Backed up by restic |

`/mnt/backups` is the NFS mount from Dirtycow's `/tank/backups/spectre`. Spectre's restic backup named `spectre-dirtycow` writes to:

```text
/mnt/backups/restic/spectre
```

The restic password file is stored locally on Spectre at:

```text
/var/lib/restic/spectre-dirtycow.password
```

Restic currently includes these paths:

```text
/home/burdz
/var/lib/authelia-main
/var/lib/beszel-hub
/var/lib/bitwarden_rs
/var/lib/jellyfin
/var/lib/karakeep
/var/lib/meilisearch
/var/lib/nixarr
/var/lib/paperless
/var/lib/postgresql
/var/lib/private/ntfy-sh
/var/lib/private/uptime-kuma
/var/lib/shlink
/var/lib/traefik
```

Restic excludes:

```text
/home/burdz/.cache
/var/lib/nixarr/qbittorrent
```

Paperless also runs its exporter on schedule at `02:30`, producing a human-friendly export in addition to the restic backup:

```text
/mnt/backups/paperless/export
```

## Pre-deploy secrets and files

Create the required secret files on Spectre before rebuilding. Do not commit these files or their contents to Git.

Homepage does not require any secret files for the current links-only dashboard. Future optional widget API keys can be added later with secrets management.

### Paperless admin password

Create `/var/lib/paperless/admin-password` with mode `0600` and ownership `paperless:paperless`:

```bash
sudo install -D -m 0600 -o paperless -g paperless /dev/stdin /var/lib/paperless/admin-password
```

Type or paste the desired Paperless admin password, then press `Ctrl-D` to finish writing the file.

### Shlink secrets

Create `/var/lib/shlink/secrets.env` with mode `0600` and ownership `root:root`:

```bash
sudo install -D -m 0600 -o root -g root /dev/stdin /var/lib/shlink/secrets.env <<'EOF'
INITIAL_API_KEY=<long random key>
# GEOLITE_LICENSE_KEY=<optional MaxMind GeoLite license key>
EOF
```

Use a long random value for `INITIAL_API_KEY`. Do not use a real token in documentation or commits. `GEOLITE_LICENSE_KEY` is optional and can stay commented out unless GeoLite integration is needed.

### Restic repository password

Create `/var/lib/restic/spectre-dirtycow.password` with mode `0600` and ownership `root:root`:

```bash
sudo install -D -m 0600 -o root -g root /dev/stdin /var/lib/restic/spectre-dirtycow.password
```

Type or paste a strong restic repository password, then press `Ctrl-D` to finish writing the file. Do not commit or document the real password.

## Deployment

Deploy Spectre after the secret files exist:

```bash
sudo nixos-rebuild switch --flake .#spectre
```

## Verification

Check service health on Spectre. Exact unit names can vary; these are the expected examples for the current config:

```bash
systemctl status paperless-web karakeep-web podman-shlink --no-pager
systemctl status homepage-dashboard --no-pager
```

If a Paperless unit name differs, list the generated units:

```bash
systemctl list-units 'paperless*'
```

Verify each local backend responds before testing the Traefik routes:

```bash
curl -I http://127.0.0.1:28981
curl -I http://127.0.0.1:3000
curl -I http://127.0.0.1:3010
curl -I http://127.0.0.1:8088
curl -I http://127.0.0.1:8089
curl -I http://127.0.0.1:8082
curl -I http://127.0.0.1:8083
```

Then open the internal-only routes from the LAN or VPN:

```text
https://paperless.burdznest.com
https://bookmarks.burdznest.com
https://home.burdznest.com
https://cyberchef.burdznest.com
https://it-tools.burdznest.com
https://s.burdznest.com
https://links.burdznest.com
```

CyberChef and IT-Tools are internal-only utility routes and require Authelia login before access.

For Shlink, `https://s.burdznest.com` is the redirect/API endpoint and `https://links.burdznest.com` is the management UI. The UI route uses `security-headers`, `internal-only`, and `authelia`. The redirect/API route stays internal-only but is not behind Authelia so normal short-link redirects do not require a browser login; API writes still require the Shlink API key. A `404` at `https://s.burdznest.com/` is expected and healthy because the Shlink server has no homepage; short slugs such as `https://s.burdznest.com/<slug>` perform redirects. A `502` means Traefik cannot reach the backend.

Verify the Dirtycow backup mount and run the Spectre restic backup once:

```bash
findmnt /mnt/backups
sudo systemctl start restic-backups-spectre-dirtycow.service
systemctl status restic-backups-spectre-dirtycow.service --no-pager
```

List restic snapshots in the Dirtycow-backed repository:

```bash
sudo RESTIC_PASSWORD_FILE=/var/lib/restic/spectre-dirtycow.password \
  restic -r /mnt/backups/restic/spectre snapshots
```

Run a restore smoke test for Shlink into `/tmp/restic-restore-test`, then remove the test restore:

```bash
sudo rm -rf /tmp/restic-restore-test
sudo RESTIC_PASSWORD_FILE=/var/lib/restic/spectre-dirtycow.password \
  restic -r /mnt/backups/restic/spectre restore latest \
  --target /tmp/restic-restore-test \
  --include /var/lib/shlink
sudo find /tmp/restic-restore-test -maxdepth 4 -type d | head
sudo rm -rf /tmp/restic-restore-test
```

## First-run setup

### Paperless-ngx

1. Open `https://paperless.burdznest.com` from the LAN or VPN.
2. Log in with the configured admin credentials. The admin password comes from `/var/lib/paperless/admin-password`.
3. Confirm OCR works with English documents and that the displayed timezone matches `Asia/Singapore`.
4. Confirm `/var/lib/paperless` is covered by restic and that the Paperless exporter writes the human-friendly export to `/mnt/backups/paperless/export`.

### Karakeep

1. Open `https://bookmarks.burdznest.com` from the LAN or VPN.
2. Create the first account during initial setup.
3. Confirm signups are disabled after the first account is created.
4. Test bookmark capture and browser integration from the LAN/VPN.
5. Confirm `/var/lib/karakeep` and `/var/lib/meilisearch` are covered by restic after the workflow is confirmed.

### Homepage

1. Deploy Spectre after the Homepage config is present:
   ```bash
   sudo nixos-rebuild switch --flake .#spectre
   ```
2. Confirm `homepage-dashboard` is running and the local backend responds:
   ```bash
   systemctl status homepage-dashboard --no-pager
   curl -I http://127.0.0.1:3010
   ```
3. Open `https://home.burdznest.com` from the LAN or VPN. Kernelpanic maps this hostname to Spectre at `10.0.0.71`.
4. Keep the dashboard links-only until widget API keys are added through secrets management.

### Shlink

1. Confirm `/var/lib/shlink/secrets.env` exists before deployment; `podman-shlink` is gated on this file.
2. Open `https://links.burdznest.com` from the LAN or VPN.
3. Add the Shlink server URL `https://s.burdznest.com`.
4. Paste the API key from `/var/lib/shlink/secrets.env`. Do not commit or document the real key.
5. Create a test short URL in the UI.
6. Verify `https://s.burdznest.com/<slug>` redirects to the expected destination.
7. Confirm `/var/lib/shlink` is covered by restic and that a restore smoke test works.
8. Keep the UI route behind Authelia. Keep the redirect/API route internal-only and without Authelia unless short links should resolve outside the LAN/VPN; if it becomes public later, API writes still require the Shlink API key.
