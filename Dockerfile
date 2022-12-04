FROM fuzzers/afl:2.52 as builder

RUN apt-get update
RUN apt install -y build-essential  wget git clang cmake  automake autotools-dev  libtool zlib1g zlib1g-dev libexif-dev \
libgtest-dev googletest pkg-config
ADD . /simpleini
WORKDIR /simpleini
ADD fuzzers/fuzz_ini.cpp .
RUN afl-g++ fuzz_ini.cpp -o fuzz_ini

FROM fuzzers/afl:2.52
COPY --from=builder /simpleini/fuzz_ini /
COPY --from=builder /simpleini/tests/*.ini /testsuite/

ENTRYPOINT ["afl-fuzz", "-i", "/testsuite", "-o", "/simpleiniOut"]
CMD ["/fuzz_ini", "@@"]
