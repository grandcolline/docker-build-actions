FROM docker:19.03.5

ARG pip_installer="https://bootstrap.pypa.io/get-pip.py"
ARG awscli_version="1.16.280"

RUN apk update \
  && apk upgrade \
  && apk add --no-cache git python curl

RUN curl ${pip_installer} | python && \
    pip install awscli==${awscli_version}

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

