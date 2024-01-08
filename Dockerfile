FROM alpine:3.14


RUN sed -i '/community/s/^#//' /etc/apk/repositories
RUN apk add --no-cache mopidy=3.4.2-r0 python3=3.11.6-r1 py3-pip=23.3.2-r0

COPY requirements.txt /tmp/requirements.txt

RUN pip3 install --upgrade pip \
  && pip3 install -r /tmp/requirements.txt --upgrade

# Default configuration
ADD mopidy.conf /var/lib/mopidy/.config/mopidy/mopidy.conf

RUN chown mopidy:audio -R /var/lib/mopidy/.config

# Run as mopidy user
USER mopidy

VOLUME /var/lib/mopidy/local
VOLUME /var/lib/mopidy/media

EXPOSE 6600
EXPOSE 6680

CMD ["/usr/bin/mopidy"]
