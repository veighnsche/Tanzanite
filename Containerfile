# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /

# Base Image - configurable via build arg
# Supported bases:
#   - cosmic: quay.io/fedora-ostree-desktops/cosmic-atomic:43
#   - aurora: ghcr.io/ublue-os/aurora:stable
#   - bluefin: ghcr.io/ublue-os/bluefin:stable
#   - bazzite: ghcr.io/ublue-os/bazzite:stable
ARG BASE_IMAGE="ghcr.io/ublue-os/aurora:stable"
FROM ${BASE_IMAGE}

# Re-declare after FROM to make available in build stage
ARG BASE_NAME="aurora"
ENV BASE_NAME=${BASE_NAME}

### MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    BASE_NAME=${BASE_NAME} /ctx/build.sh
    
### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
