FROM arm32v7/python:3.6-slim

ARG NUMPY_VERSION=1.16.1

COPY ./qemu-arm-static /usr/bin/
COPY ./library-dependencies.txt /tmp/

RUN buildDeps='build-essential gcc gfortran python3-dev libopenblas-dev liblapack-dev' \
        && apt-get update \
        && apt-get install -y --no-install-recommends $buildDeps  \
        && cat library-dependencies.txt | egrep -v "^\s*(#|$)" | xargs apt-get install -y \
        && CFLAGS="-g0 -Wl,--strip-all -I/usr/include:/usr/local/include -L/usr/lib:/usr/local/lib" \
        && pip3 install --no-cache-dir \
        --compile \
        --global-option=build_ext \
        --global-option="-j 4" \
        numpy==${NUMPY_VERSION} \
        && apt-get purge -y --auto-remove $buildDeps \
        && rm -rf /var/lib/apt/lists/* \
        && rm -r /tmp/library-dependencies.txt
