FROM ubuntu:xenial
RUN apt-get update -y
RUN apt-get install -y curl

# Cf. https://github.com/nodejs/docker-node/blob/28425ed95cebaea2ff589c1516d79c60181983b2/7.4/Dockerfile
ENV NODE_VERSION 7.4.0
RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz"
RUN tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1
RUN ln -s /usr/local/bin/node /usr/local/bin/nodejs

#RUN apt-get install -y npm
RUN npm config set color false
RUN npm install -g cordova
RUN npm install -g cordova-hot-code-push-cli read-package-json xml2js
RUN apt-get install -y openjdk-8-jdk aspcud git unzip rsync
RUN curl -L https://github.com/ocaml/opam/releases/download/1.2.2/opam-1.2.2-x86_64-Linux --output /usr/local/bin/opam
RUN chmod a+x /usr/local/bin/opam
# OCaml dependencies taken from:
# https://hub.docker.com/r/dannywillems/docker-ocsigen-start/~/dockerfile/
RUN apt-get install -y dialog postgresql ruby-sass build-essential

RUN opam init --comp=4.03.0

ENTRYPOINT [ "opam", "config", "exec", "--" ]

RUN opam config exec -- opam install depext
RUN opam config exec -- opam-depext conf-libpcre.1
RUN opam config exec -- opam-depext conf-openssl.1
RUN opam config exec -- opam-depext conf-zlib.1
RUN opam config exec -- opam-depext dbm.1.0
RUN opam config exec -- opam-depext imagemagick.0.34-1
RUN opam config exec -- opam-depext conf-gmp.1
ENV OPAMJOBS 1
RUN opam config exec -- opam install --yes ocsigen-start

RUN curl -LO https://dl.google.com/android/repository/tools_r25.2.3-linux.zip
RUN unzip tools_r25.2.3-linux.zip
ENV PATH "${PWD}/tools/bin:${PWD}/platform-tools:${PATH}"

# sdkmanager chokes on certificates that contain non-ascii charcters in their filenames:
# even with `--no_https`
RUN rm /etc/ssl/certs/*.pem
RUN rm /usr/share/ca-certificates/mozilla/*
RUN "sdkmanager" --no_https "platform-tools"
RUN "sdkmanager" --no_https "tools"
RUN "sdkmanager" --no_https 'build-tools;25.0.2'
RUN "sdkmanager" --no_https 'platforms;android-23'

# Emulator-ready:
RUN apt-get install -y qemu-kvm
RUN sdkmanager 'system-images;android-23;default;x86_64'
