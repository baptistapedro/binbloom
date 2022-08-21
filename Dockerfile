FROM fuzzers/afl:2.52

RUN apt-get update
RUN apt install -y build-essential wget git clang cmake  automake autotools-dev  libtool zlib1g zlib1g-dev libexif-dev libjpeg-dev gettext
RUN  git clone https://github.com/quarkslab/binbloom.git
WORKDIR /binbloom
RUN autoreconf -i
RUN ./configure CC=afl-clang CXX=afl-clang++
RUN make
RUN make install
RUN mkdir /binbloomCorpus
RUN wget https://filesamples.com/samples/font/bin/fontawesome-webfont.bin
RUN wget https://filesamples.com/samples/font/bin/Lato-Regular.bin
RUN wget https://filesamples.com/samples/font/bin/NotoSansShavian-Regular.bin
RUN mv *.bin /binbloomCorpus


ENTRYPOINT  ["afl-fuzz", "-m", "2048", "-t", "2000+", "-i", "/binbloomCorpus", "-o", "/binbloomOut"]
CMD ["/binbloom/src/binbloom", "@@"]
