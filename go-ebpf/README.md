# Setup

## Tools

- make
- Docker

## Bootstrap

```bash
git clone https://github.com/cilium/ebpf.git
mkdir -p ebpf/examples/xdp-fw
cp xdp-fw/main.go ebpf/examples/xdp-fw/
cp xdp-fw/xdp-fw.c ebpf/examples/xdp-fw/
cd ebpf
make -C .
```

## Notes:

- Makefile has some issues with Mac. `git diff` below (uid/gid might be different per setup)

```diff
diff --git a/Makefile b/Makefile
index dbcdbafe..b068aedf 100644
--- a/Makefile
+++ b/Makefile
@@ -11,7 +11,7 @@ CI_KERNEL_URL ?= https://github.com/cilium/ci-kernels/raw/master/
 # Obtain an absolute path to the directory of the Makefile.
 # Assume the Makefile is in the root of the repository.
 REPODIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
-UIDGID := $(shell stat -c '%u:%g' ${REPODIR})
+UIDGID := 501:501

 # Prefer podman if installed, otherwise use docker.
 # Note: Setting the var at runtime will always override.
@@ -55,7 +55,7 @@ container-all:
 		--env CFLAGS="-fdebug-prefix-map=/ebpf=." \
 		--env HOME="/tmp" \
 		"${IMAGE}:${VERSION}" \
-		$(MAKE) all
+		make all

 # (debug) Drop the user into a shell inside the container as root.
 container-shell:
```

## Loading image to minikube

```bash
docker build . -t go-ebpf
minikube image load go-ebpf
```
