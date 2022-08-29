FROM fuzzers/afl:2.52

RUN apt-get update
RUN apt install -y build-essential  wget git clang cmake  automake autotools-dev  libtool zlib1g zlib1g-dev libexif-dev \
libgtest-dev googletest pkg-config
RUN git clone https://github.com/brofield/simpleini.git
WORKDIR /simpleini
#RUN CC=afl-gcc CXX=afl-g++ make
RUN mkdir /iniCorpus
RUN cp ./tests/*.ini /iniCorpus
RUN wget http://sample-file.bazadanni.com/download/applications/ini/sample.ini
RUN wget https://raw.githubusercontent.com/grafana/grafana/main/conf/sample.ini
RUN cp *.ini /iniCorpus
COPY fuzzers/fuzz.cpp .
RUN afl-g++ fuzz.cpp -o /fuzz


ENTRYPOINT ["afl-fuzz", "-i", "/iniCorpus", "-o", "/simpleiniOut"]
CMD ["/fuzz", "@@"]
