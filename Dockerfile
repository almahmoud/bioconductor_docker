##### IMPORTANT ########
## The PATCH version number should be incremented each time
## there is a change in the Dockerfile.
FROM rocker/r-ver:devel

ENV S6_VERSION=v2.1.0.2
ENV RSTUDIO_VERSION=2021.09.2+382
ENV DEFAULT_USER=rstudio
ENV PATH=/usr/lib/rstudio-server/bin:$PATH
ENV DEBIAN_FRONTEND=noninteractive \
    LIBSBML_CFLAGS="-I/usr/include" \
    LIBSBML_LIBS="-lsbml" \
    BIOCONDUCTOR_DOCKER_VERSION=$BIOCONDUCTOR_DOCKER_VERSION \
    BIOCONDUCTOR_VERSION=$BIOCONDUCTOR_VERSION

LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://github.com/rocker-org/rocker-versioned2" \
      org.opencontainers.image.vendor="Rocker Project" \
      org.opencontainers.image.authors="Carl Boettiger <cboettig@ropensci.org>"

LABEL name="bioconductor/bioconductor_docker" \
      version=$BIOCONDUCTOR_DOCKER_VERSION \
      url="https://github.com/Bioconductor/bioconductor_docker" \
      vendor="Bioconductor Project" \
      maintainer="maintainer@bioconductor.org" \
      description="Bioconductor docker image with system dependencies to install all packages." \
      license="Artistic-2.0"


ADD scripts /bioconductor/scripts

RUN /rocker_scripts/install_rstudio.sh
RUN /rocker_scripts/install_pandoc.sh

RUN /bioconductor/scripts/bioconductor_install.sh

EXPOSE 8787

CMD ["/init"]
