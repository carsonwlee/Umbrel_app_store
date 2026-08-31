# Patched BigCapital webapp image (PR 1310)

Official `bigcapitalhq/webapp` is an nginx static bundle. Copying `.tsx` into
that image does nothing. Umbrel compose cannot use `build:`, so this directory
rebuilds webapp from `bigcapitalhq/bigcapital` tag `v0.25.35` plus upstream
[PR 1310](https://github.com/bigcapitalhq/bigcapital/pull/1310)
(`cc3fb611a91843d5a78257ec6151b3c2837ad3a2`).

## Image

```
ghcr.io/carsonwlee/bigcapital-webapp:0.25.35-apikey
```

Built by `.github/workflows/build-bigcapital-webapp.yml` (`linux/amd64` and
`linux/arm64` when QEMU succeeds). The workflow checks out upstream at
`v0.25.35`, applies the five source files from PR 1310 (e2e spec skipped), and
pushes with `GITHUB_TOKEN`.

## After the first publish

New GHCR packages default to **private**. Umbrel must be able to pull without
auth. Once the workflow has pushed, Carson should open:

https://github.com/users/carsonwlee/packages/container/package/bigcapital-webapp

Package settings → Change visibility → **Public**. That is a one-time step.

## Local rebuild (optional)

```bash
git clone --depth 1 --branch v0.25.35 https://github.com/bigcapitalhq/bigcapital.git
./apply-pr-1310.sh bigcapital
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -f Dockerfile \
  -t ghcr.io/carsonwlee/bigcapital-webapp:0.25.35-apikey \
  --push \
  bigcapital
```

Server, MariaDB, Redis, and the rest stay on official images.
