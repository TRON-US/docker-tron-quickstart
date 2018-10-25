# Bash utilities

__The following tools are useful during debugging and development__

`sh/build.sh` builds the local image `tron-quickstart`.

`sh/run.sh` runs `tron-quickstart` generating a `tron` container on ports 8090, 8091 and 8092.

`sh/srun.sh` runs `tron-quickstart` using local folders for data persistence, generating a `tron` container.

`sh/bash.sh` connects to the `tron` container opening a bash prompt.

`sh/brun.sh` is a shortcut for `sh/build.sh && sh/run.sh`.

`sh/accounts.sh` shows the accounts available in the `tron` container.

`sh/generate.sh` generates the accounts available in the `tron` container, if for some reason the process fails. If the initial process was successful, as it should, it just reloads the data from a local cache.

`sh/tag.sh` tags a new `tron-quickstart` image in preparation of a push to the Docker Hub.

`sh/verify.sh` verifies the full node, solidity node and eventServer are listening.

`sh/prun.sh` runs latest version of `trontools/quickstart` on ports 9090, 9091 and 9092 (to avoid conflicts with the work-in-progress `tron-quickstart` which runs on ports 8090, 8091 and 8092).
