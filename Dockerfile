FROM alpine:latest

RUN apk update \
    && apk upgrade \
    && apk add --no-cache \
            mopidy \
            py-pip \
            python3-dev

COPY requirements.txt requirements.txt

# run with --break-system-packages as there is no use in creating a venv in a container
RUN pip3 install -r requirements.txt --break-system-packages \
    && rm -rf ~/.cache/pip

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
