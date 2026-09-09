# excalidraw-modern

Builds the **official current Excalidraw client** (pinned v0.18.1) with
self-hosted backend URLs baked in at build time (unlike the 2021 fork, the
official client reads `VITE_APP_*` vars at build, not runtime).

Pairs with the patched `excalidraw-storage` backend + `excalidraw-room` relay
on the same host. Scenes and share-links round-trip through the local backend;
live collaboration goes through the local room relay.

Known limitation vs the old fork: embedded **images** inside share-links/collab
rooms use Firebase in the official client and are not supported here; scenes
and shapes are fully local.