#!/bin/bash
git clone --depth 1 https://github.com/rocker-org/rocker-versioned2
sed -i 's#rocker/cuda:${{ steps.defs.outputs.rver }}#${{ steps.defs.outputs.rockerintermediateprefix }}-cuda:${{ steps.defs.outputs.rver }}-${{ matrix.arch }}#g' rocker-versioned2/dockerfiles/ml_${{ steps.defs.outputs.rver }}.Dockerfile
sed -i 's#rocker/ml:${{ steps.defs.outputs.rver }}#${{ steps.defs.outputs.rockerintermediateprefix }}-ml:${{ steps.defs.outputs.rver }}-${{ matrix.arch }}#g' rocker-versioned2/dockerfiles/ml-verse_${{ steps.defs.outputs.rver }}.Dockerfile

BIOC_MINOR=$(echo "${{ steps.defs.outputs.biocver }}" | awk -F'.' '{print $NF}')
echo "Bioconductor Version: ${{ steps.defs.outputs.biocver }}"
if [ "${{ steps.defs.outputs.rver }}" = "devel" ];
then
  if [ $((BIOC_MINOR%2)) -eq 0 ];
  then
      echo "Using latest release R since Bioc devel version is even";
      sed -i 's#R_VERSION=${{ steps.defs.outputs.rver }}#R_VERSION=latest#g' rocker-versioned2/dockerfiles/cuda_${{ steps.defs.outputs.rver }}.Dockerfile
  else
      echo "Using latest pre-release R since Bioc devel version is even";
      sed -i 's#R_VERSION=${{ steps.defs.outputs.rver }}#R_VERSION=patched#g' rocker-versioned2/dockerfiles/cuda_${{ steps.defs.outputs.rver }}.Dockerfile
  fi
fi
