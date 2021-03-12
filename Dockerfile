FROM alpine:3.13.2

ARG version
ENV VERSION=${version} \
  \
  DEV_PKGS="cmake gcc git g++ make nasm perl" \
  PREFIX=/tmp/output

RUN apk add --no-cache ${DEV_PKGS} &&\
  # aom
  git clone https://aomedia.googlesource.com/aom /tmp/aom -b v${VERSION} --depth 1 &&\
  rm -rf /tmp/aom/CMakeCache.txt /tmp/aom/CMakeFiles &&\
  mkdir -p /tmp/aom/aom_build &&\
  cd /tmp/aom/aom_build &&\
  cmake -DCMAKE_INSTALL_PREFIX=${PREFIX} -DBUILD_SHARED_LIBS=1 -DENABLE_TESTS=0 /tmp/aom &&\
  make -j$(nproc) install &&\
  rm -rf /tmp/aom &&\
  apk del ${DEV_PKGS} &&\
  cp -r ${PREFIX} /output/
