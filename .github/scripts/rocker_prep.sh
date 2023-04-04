#!/bin/bash
git clone --depth 1 https://github.com/rocker-org/rocker-versioned2
sed -i 's#rocker/r-ver:${{ steps.defs.outputs.rver }}#${{ steps.defs.outputs.rockerintermediateprefix }}-r-ver:${{ steps.defs.outputs.rver }}-${{ matrix.arch }}#g' rocker-versioned2/dockerfiles/rstudio_${{ steps.defs.outputs.rver }}.Dockerfile
sed -i 's#rocker/rstudio:${{ steps.defs.outputs.rver }}#${{ steps.defs.outputs.rockerintermediateprefix }}-rstudio:${{ steps.defs.outputs.rver }}-${{ matrix.arch }}#g' rocker-versioned2/dockerfiles/tidyverse_${{ steps.defs.outputs.rver }}.Dockerfile
sed -i 's#install_quarto.sh#install_quarto.sh || true#g' rocker-versioned2/dockerfiles/rstudio_${{ steps.defs.outputs.rver }}.Dockerfile

BIOC_MINOR=$(echo "${{ steps.defs.outputs.biocver }}" | awk -F'.' '{print $NF}')
echo "Bioconductor Version: ${{ steps.defs.outputs.biocver }}"
if [ "${{ steps.defs.outputs.rver }}" = "devel" ];
then
  if [ $((BIOC_MINOR%2)) -eq 0 ];
  then
      echo "Using latest release R since Bioc devel version is even";
      sed -i 's#R_VERSION=${{ steps.defs.outputs.rver }}#R_VERSION=latest#g' rocker-versioned2/dockerfiles/r-ver_${{ steps.defs.outputs.rver }}.Dockerfile
  else
      echo "Using latest pre-release R since Bioc devel version is even";
      sed -i 's#R_VERSION=${{ steps.defs.outputs.rver }}#R_VERSION=patched#g' rocker-versioned2/dockerfiles/r-ver_${{ steps.defs.outputs.rver }}.Dockerfile
  fi
fi
