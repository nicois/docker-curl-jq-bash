FROM docker:latest

RUN \
	apk -Uuv add make gcc groff less bash \
		musl-dev libffi-dev openssl-dev \
		python3-dev py-pip jq curl && \
	pip install awscli docker-compose && \
	rm /var/cache/apk/*
