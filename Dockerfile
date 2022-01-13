# The suggested name for this image is: bioconductor/bioconductor_docker:devel
FROM rocker/rstudio:devel

##### IMPORTANT ########
## The PATCH version number should be incremented each time
## there is a change in the Dockerfile.
ARG BIOCONDUCTOR_VERSION=3.15 \
    BIOCONDUCTOR_PATCH=11 \
    BIOCONDUCTOR_DOCKER_VERSION=${BIOCONDUCTOR_VERSION}.${BIOCONDUCTOR_PATCH}

LABEL name="bioconductor/bioconductor_docker" \
      version=$BIOCONDUCTOR_DOCKER_VERSION \
      url="https://github.com/Bioconductor/bioconductor_docker" \
      vendor="Bioconductor Project" \
      maintainer="maintainer@bioconductor.org" \
      description="Bioconductor docker image with system dependencies to install all packages." \
      license="Artistic-2.0"

ADD scripts /tmp/scripts

ENV DEBIAN_FRONTEND=noninteractive \
    LIBSBML_CFLAGS="-I/usr/include" \
    LIBSBML_LIBS="-lsbml" \
    BIOCONDUCTOR_DOCKER_VERSION=$BIOCONDUCTOR_DOCKER_VERSION \
    BIOCONDUCTOR_VERSION=$BIOCONDUCTOR_VERSION

RUN sh /tmp/scripts/bioconductor_install.sh

# Init command for s6-overlay
CMD ["/init"]
