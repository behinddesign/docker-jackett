FROM gliderlabs/alpine:3.3

MAINTAINER guillaumeGL <guillaume.lebeau@outlook.com>

ENV VERSION 0.7.181

# Update the package list
RUN apk update

# Install all needed packages. Tar+Bzip2 to uncompress Jackett archive and libcurl+Mono as dependencies to Jackett
RUN apk add curl tar bzip2
RUN apk add mono --update-cache --repository http://alpine.gliderlabs.com/alpine/edge/testing/ --allow-untrusted

RUN curl -L http://github.com/Jackett/Jackett/releases/download/v${VERSION}/Jackett.Binaries.Mono.tar.gz -o /tmp/jackett.tar.gz
RUN mkdir -p /tmp/jackett
RUN tar -zxvf /tmp/jackett.tar.gz -C /tmp/jackett
RUN mkdir -p /data/app
RUN mv /tmp/jackett/Jackett /data/app
RUN chown -R nobody:users /data/app
RUN mkdir -p /data/config
RUN chown -R nobody:users /data/config
RUN ln -s /data/config /usr/share/Jackett

EXPOSE 9117
VOLUME /data/config
VOLUME /data/app

ADD start.sh /
RUN chmod +x /start.sh

WORKDIR /data/app/Jackett

ENTRYPOINT ["mono", "JackettConsole.exe"]
