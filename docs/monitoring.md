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
| Access policy | Spectre | Traefik uses the `internal-only` middleware |
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

Then open the proxied LAN-only route in a browser:

```text
https://scrutiny.burdznest.com
```

## Beszel Host Monitoring

Beszel monitors host health for the homelab from a hub running on Spectre. Spectre and Dirtycow both run Beszel agents, but each agent is gated until its hub-provided key and token are installed.

## Implementation

| Component | Host | Details |
| :--- | :--- | :--- |
| Beszel hub | Spectre | Runs on `127.0.0.1:8090` |
| Reverse proxy | Spectre | Traefik routes `monitor.burdznest.com` to `http://127.0.0.1:8090` |
| Access policy | Spectre | Traefik uses the `internal-only` middleware |
| Local hostname | Kernelpanic | `extraHosts` maps `monitor.burdznest.com` to `10.0.0.71` |
| Beszel agent | Spectre | `services.beszel.agent` enabled for the local host; `openFirewall = false` |
| Beszel agent | Dirtycow | `services.beszel.agent` enabled; `openFirewall = true` for TCP `45876` |
| Agent startup gate | Spectre and Dirtycow | Agent units use `ConditionPathExists=/var/lib/beszel-agent/env` so they do not fail before credentials exist |

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

   # Spectre: redeploy or restart the local agent after adding the env file.
   sudo nixos-rebuild switch --flake .#spectre
   sudo systemctl restart beszel-agent
   ```

## Verification

On Spectre, check the hub and local agent:

```bash
systemctl status beszel-hub beszel-agent --no-pager
```

On Dirtycow, check the remote agent:

```bash
systemctl status beszel-agent --no-pager
```

From the Beszel UI at `https://monitor.burdznest.com`, confirm Spectre and Dirtycow both appear online after their agent environment files are installed and their agents are restarted.

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

Add alerting later through `ntfy` after the checks are stable and false positives have been tuned.
