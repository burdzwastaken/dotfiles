# Monitoring

## Scrutiny Drive SMART Monitoring

Scrutiny monitors drive SMART health for Dirtycow, the host that owns the HDDs and ZFS storage pool.

## Scrutiny implementation

| Component | Host | Details |
| :--- | :--- | :--- |
| Scrutiny web UI | Dirtycow | `services.scrutiny` web enabled, listening on `0.0.0.0:8080` |
| Scrutiny collector | Dirtycow | Collector enabled with a daily schedule |
| Disk access | Dirtycow | Collector runs with supplementary `disk` group access |
| Firewall | Dirtycow | `openFirewall = true` for Scrutiny |
| Reverse proxy | Spectre | Traefik routes `scrutiny.burdznest.com` to `http://10.0.0.70:8080` |
| Access policy | Spectre | Traefik uses the `security-headers`, `internal-only`, and `authelia` middlewares |
| Local hostname | Kernelpanic | `extraHosts` maps `scrutiny.burdznest.com` to `10.0.0.71` |

## Scrutiny deployment

Deploy Dirtycow first so the Scrutiny web and collector services exist, then deploy Spectre so Traefik can route to it.

```bash
sudo nixos-rebuild switch --flake .#dirtycow
sudo nixos-rebuild switch --flake .#spectre
```

## Scrutiny verification

On Dirtycow, check the web service and collector timer:

```bash
systemctl status scrutiny scrutiny-collector.timer scrutiny-collector.service --no-pager
```

Run the collector once immediately instead of waiting for the daily timer:

```bash
sudo systemctl start scrutiny-collector.service
```

Check collector logs if drives do not appear in the UI:

```bash
journalctl -u scrutiny-collector -b -n 80 --no-pager
```

From a LAN machine, verify Dirtycow's Scrutiny web UI responds directly:

```bash
curl -I http://10.0.0.70:8080
```

Then open the proxied LAN-only route in a browser. Scrutiny is protected by Authelia, so authenticate when redirected:

```text
https://scrutiny.burdznest.com
```

## Authelia Authentication Gateway

Authelia provides the Traefik forward-auth gateway for protected internal routes. It currently protects only Scrutiny.

## Authelia implementation

| Component | Host | Details |
| :--- | :--- | :--- |
| Authelia | Spectre | Runs as `authelia-main` on `127.0.0.1:9091` |
| Login URL | Spectre | `https://auth.burdznest.com` |
| Reverse proxy | Spectre | Traefik routes `auth.burdznest.com` to `http://127.0.0.1:9091` |
| Access policy | Spectre | Authelia's own route uses the `internal-only` middleware |
| Forward auth | Spectre | Traefik middleware named `authelia` points at Authelia's auth endpoint |
| Protected route | Spectre | Only `scrutiny.burdznest.com` uses `security-headers`, `internal-only`, and `authelia` |
| External state | Spectre | Uses `/var/lib/authelia-main/secrets/jwt-secret`, `/var/lib/authelia-main/secrets/storage-encryption-key`, and `/var/lib/authelia-main/users_database.yml` |
| Startup gate | Spectre | Service uses `ConditionPathExists` for the required secret and user database files |

## Authelia first-run setup

Create the external state directories and secrets on Spectre:

```bash
sudo install -d -m 0750 -o root -g root /var/lib/authelia-main/secrets
sudo openssl rand -hex 64 | sudo tee /var/lib/authelia-main/secrets/jwt-secret >/dev/null
sudo openssl rand -hex 64 | sudo tee /var/lib/authelia-main/secrets/storage-encryption-key >/dev/null
```

Authelia's files must be owned by the `authelia-main` service user. If the user does not exist yet, deploy Spectre once after the files are created so NixOS creates the system user, then fix ownership and deploy again:

```bash
sudo nixos-rebuild switch --flake .#spectre
```

Generate a password hash for the `burdz` admin user:

```bash
authelia crypto hash generate argon2
```

Copy the entire value printed after `Digest:`. Do not copy the word `Digest:` itself. The value should start with `$argon2id...`.

Create `/var/lib/authelia-main/users_database.yml` using the generated hash:

```bash
sudo tee /var/lib/authelia-main/users_database.yml >/dev/null <<'EOF'
users:
  burdz:
    displayname: burdz
    password: '$argon2id$v=19$m=...'
    email: burdz@example.com
    groups:
      - admins
EOF
```

Use the username `burdz` when logging in, not the email address. Single quotes around the digest are preferred because the hash contains `$` characters.

After the `authelia-main` user exists, set ownership and permissions on the external files:

```bash
sudo chown -R authelia-main:authelia-main /var/lib/authelia-main
sudo chmod 0700 /var/lib/authelia-main
sudo chmod 0700 /var/lib/authelia-main/secrets
sudo chmod 0600 /var/lib/authelia-main/secrets/jwt-secret
sudo chmod 0600 /var/lib/authelia-main/secrets/storage-encryption-key
sudo chmod 0600 /var/lib/authelia-main/users_database.yml
```

Rebuild Spectre after the secrets and user database are in place:

```bash
sudo nixos-rebuild switch --flake .#spectre
```

## Authelia password change

To change the `burdz` Authelia password later, generate a new Argon2 hash on Spectre:

```bash
authelia crypto hash generate argon2
```

Copy the full value after `Digest:` without copying `Digest:`. Replace the `password:` value for `users.burdz` in `/var/lib/authelia-main/users_database.yml` with the new digest, preferably wrapped in single quotes:

```yaml
users:
  burdz:
    displayname: burdz
    password: '$argon2id$v=19$m=...'
    email: burdz@example.com
    groups:
      - admins
```

Fix ownership and permissions after editing, then restart Authelia:

```bash
sudo chown authelia-main:authelia-main /var/lib/authelia-main/users_database.yml
sudo chmod 0600 /var/lib/authelia-main/users_database.yml
sudo systemctl restart authelia-main
```

Log in with username `burdz`, not the email address.

## Authelia verification

On Spectre, check the service and logs:

```bash
systemctl status authelia-main --no-pager
journalctl -u authelia-main -b -n 80 --no-pager
```

From a LAN machine, open Authelia directly first, then open Scrutiny and confirm it redirects through Authelia:

```text
https://auth.burdznest.com
https://scrutiny.burdznest.com
```

## Authelia ban recovery

Repeated failed logins can temporarily ban the user or source IP until the ban expires. Waiting for the expiry is fine and requires no action.

If access is needed immediately, revoke the ban on Spectre. Use the storage encryption key from `/var/lib/authelia-main/secrets/storage-encryption-key` and the SQLite database at `/var/lib/authelia-main/db.sqlite3`:

```bash
STORAGE_ENCRYPTION_KEY=$(sudo cat /var/lib/authelia-main/secrets/storage-encryption-key)

sudo AUTHELIA_STORAGE_ENCRYPTION_KEY="$STORAGE_ENCRYPTION_KEY" \
  authelia storage bans user revoke burdz \
  --config /etc/authelia-main/configuration.yml \
  --sqlite.path /var/lib/authelia-main/db.sqlite3
```

To revoke an IP ban, replace `<ip-address>` with the banned client IP:

```bash
STORAGE_ENCRYPTION_KEY=$(sudo cat /var/lib/authelia-main/secrets/storage-encryption-key)

sudo AUTHELIA_STORAGE_ENCRYPTION_KEY="$STORAGE_ENCRYPTION_KEY" \
  authelia storage bans ip revoke <ip-address> \
  --config /etc/authelia-main/configuration.yml \
  --sqlite.path /var/lib/authelia-main/db.sqlite3
```

No `authelia-main` restart is needed after revoking a ban.

## Beszel Host Monitoring

Beszel monitors host health for the homelab from a hub running on Spectre. Spectre, Dirtycow, and Kernelpanic run Beszel agents, but each agent is gated until its hub-provided key and token are installed.

## Implementation

| Component | Host | Details |
| :--- | :--- | :--- |
| Beszel hub | Spectre | Runs on `127.0.0.1:8090` |
| Reverse proxy | Spectre | Traefik routes `monitor.burdznest.com` to `http://127.0.0.1:8090` |
| Access policy | Spectre | Traefik uses the `internal-only` middleware |
| Local hostname | Kernelpanic | `extraHosts` maps `monitor.burdznest.com` to `10.0.0.71` |
| Beszel agent | Spectre | `services.beszel.agent` enabled for the local host; `openFirewall = false` |
| Beszel agent | Dirtycow | `services.beszel.agent` enabled; `openFirewall = true` for TCP `45876` |
| Beszel agent | Kernelpanic | `services.beszel.agent` enabled; `openFirewall = true` for TCP `45876` |
| Container stats | Spectre | Opts in with `burdz.containers.dockerSocket.enable = true`; the local Beszel agent is explicitly pointed at Podman's native socket with `DOCKER_HOST=unix:///run/podman/podman.sock` and has supplementary `podman` group access |
| Agent startup gate | Spectre, Dirtycow, and Kernelpanic | Agent units use `ConditionPathExists=/var/lib/beszel-agent/env` so they do not fail before credentials exist |

### Beszel container monitoring

The shared containers module keeps Podman's Docker-compatible socket opt-in per host through `burdz.containers.dockerSocket.enable`. Spectre is the current opt-in host, and the local Beszel agent is explicitly configured to use Podman's native socket at `/run/podman/podman.sock` for Docker-compatible discovery and Shlink container stats while the containers themselves continue to run through Podman.

Docker/Podman socket access is root-equivalent: a process that can control the socket can effectively control containers and often the host. Keep it disabled on other hosts unless they explicitly need it.

## Agent credentials

Each Beszel agent needs an environment file generated from the hub's **Add System** flow:

```bash
KEY=<hub public key>
TOKEN=<hub universal token>
```

Create the file on each monitored host at:

```text
/var/lib/beszel-agent/env
```

The file must be owned by `root:root` and readable only by root:

```bash
sudo install -d -m 0755 -o root -g root /var/lib/beszel-agent
sudo install -m 0600 -o root -g root /dev/stdin /var/lib/beszel-agent/env <<'EOF'
KEY=<hub public key>
TOKEN=<hub universal token>
EOF
```

## Deployment

1. **Deploy Spectre** so the Beszel hub and Traefik route are available:

   ```bash
   sudo nixos-rebuild switch --flake .#spectre
   ```

2. **Open the internal-only monitoring URL** from the LAN:

   ```text
   https://monitor.burdznest.com
   ```

3. **Create the first Beszel admin user** in the web UI.

4. **Use Add System** in Beszel to get the hub public key and universal token.

5. **Create `/var/lib/beszel-agent/env` on each monitored host** with mode `0600` and owner `root:root` using the `KEY=` and `TOKEN=` values from Beszel.

6. **Deploy or restart the agents** after the environment file exists:

   ```bash
   # Dirtycow: deploy the remote agent and firewall rule.
   sudo nixos-rebuild switch --flake .#dirtycow

   # Kernelpanic: deploy the workstation agent and firewall rule.
   sudo nixos-rebuild switch --flake .#kernelpanic

   # Spectre: redeploy or restart the local agent after adding the env file.
   sudo nixos-rebuild switch --flake .#spectre
   sudo systemctl restart beszel-agent
   ```

## Verification

On Spectre, check the hub and local agent:

```bash
systemctl status beszel-hub beszel-agent --no-pager
```

On Spectre, verify the Podman Docker-compatible socket and Beszel agent logs when checking container stats:

```bash
systemctl status podman.socket --no-pager
test -S /run/podman/podman.sock
id beszel-agent
journalctl -u beszel-agent -b -n 80 --no-pager
```

On Dirtycow, check the remote agent:

```bash
systemctl status beszel-agent --no-pager
```

On Kernelpanic, check the workstation agent:

```bash
systemctl status beszel-agent --no-pager
```

From the Beszel UI at `https://monitor.burdznest.com`, confirm Spectre, Dirtycow, and Kernelpanic appear online after their agent environment files are installed and their agents are restarted. Add Kernelpanic as `10.0.0.61:45876`, or use its current LAN IP with port `45876` if it has changed. For Spectre, also check that Beszel shows container stats from the Podman-backed socket.

## Uptime Kuma Service Monitoring

Uptime Kuma monitors service availability for the homelab from Spectre. It is intended for endpoint and application checks that complement Scrutiny drive health monitoring and Beszel host metrics.

## Uptime Kuma implementation

| Component | Host | Details |
| :--- | :--- | :--- |
| Uptime Kuma | Spectre | `services.uptime-kuma` enabled with `appriseSupport` enabled |
| Bind address | Spectre | Defaults to `HOST=127.0.0.1` and `PORT=3001` |
| Data directory | Spectre | Defaults to `DATA_DIR=/var/lib/uptime-kuma` |
| Reverse proxy | Spectre | Traefik routes `status.burdznest.com` to `http://127.0.0.1:3001` |
| Access policy | Spectre | Traefik uses the `internal-only` middleware |
| Local hostname | Kernelpanic | `extraHosts` maps `status.burdznest.com` to `10.0.0.71` |

## Uptime Kuma deployment

Deploy Spectre so the Uptime Kuma service and Traefik route are available:

```bash
sudo nixos-rebuild switch --flake .#spectre
```

## Uptime Kuma verification

On Spectre, check the service:

```bash
systemctl status uptime-kuma --no-pager
```

Verify the local Uptime Kuma web UI responds before testing the proxied route:

```bash
curl -I http://127.0.0.1:3001
```

Then open the internal-only status URL from the LAN:

```text
https://status.burdznest.com
```

On first run, create the initial Uptime Kuma admin user in the web UI.

## ntfy Notifications

ntfy provides lightweight push notifications for homelab alerts from Spectre. It is currently exposed only through the internal Traefik route, so notifications are intended to work from the LAN or VPN.

## ntfy implementation

| Component | Host | Details |
| :--- | :--- | :--- |
| ntfy server | Spectre | `services.ntfy-sh` enabled |
| Base URL | Spectre | `https://ntfy.burdznest.com` |
| Bind address | Spectre | `listen-http = 127.0.0.1:2586` |
| Proxy awareness | Spectre | `behind-proxy = true` |
| Auth policy | Spectre | `auth-default-access = deny-all`, `enable-login = true`, `enable-signup = false` |
| Reverse proxy | Spectre | Traefik routes `ntfy.burdznest.com` to `http://127.0.0.1:2586` |
| Access policy | Spectre | Traefik uses the `security-headers` and `internal-only` middlewares |
| Local hostname | Kernelpanic | `extraHosts` maps `ntfy.burdznest.com` to `10.0.0.71` |

## ntfy deployment

Deploy Spectre so the ntfy service and Traefik route are available:

```bash
sudo nixos-rebuild switch --flake .#spectre
```

## ntfy verification

On Spectre, check the service:

```bash
systemctl status ntfy-sh --no-pager
```

Verify the local ntfy web UI responds before testing the proxied route:

```bash
curl -I http://127.0.0.1:2586
```

Then open the internal-only ntfy URL from the LAN or VPN:

```text
https://ntfy.burdznest.com
```

## ntfy one-time setup

The ntfy service must run at least once before these user commands if the auth database does not exist yet.

Create the admin user, a write-only notifier user for service alerts, and a notifier token:

```bash
sudo ntfy user add --role=admin burdz
sudo ntfy user add notifier
sudo ntfy access notifier homelab-alerts write-only
sudo ntfy token add notifier
```

Use the generated notifier token for Uptime Kuma notifications to the `homelab-alerts` topic.

Because the route uses `internal-only`, phone notifications work while the phone is on the LAN or VPN. Public and iOS push behavior can be revisited later by removing `internal-only` and setting `upstream-base-url`.

## Suggested Uptime Kuma monitors

Add HTTP(S) monitors for the internal service routes after the first-run admin account is created:

| Service | URL |
| :--- | :--- |
| Jellyfin | `https://jellyfin.burdznest.com` |
| Immich / Photos | `https://photos.burdznest.com` |
| Vaultwarden / Vault | `https://vault.burdznest.com` |
| Syncthing / Sync | `https://sync.burdznest.com` |
| Scrutiny | `https://scrutiny.burdznest.com` |
| Beszel / Monitor | `https://monitor.burdznest.com` |
| Seerr / Requests | `https://request.burdznest.com` |
| Radarr | `https://radarr.burdznest.com` |
| Sonarr | `https://sonarr.burdznest.com` |
| Prowlarr | `https://prowlarr.burdznest.com` |
| Bazarr | `https://bazarr.burdznest.com` |
| qBittorrent / Torrent | `https://torrent.burdznest.com` |

Add alerting through `ntfy` after the checks are stable and false positives have been tuned. Uptime Kuma can use the write-only notifier token for the `homelab-alerts` topic.
