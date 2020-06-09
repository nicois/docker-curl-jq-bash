FROM docker:latest
RUN \
	apk -Uuv add make gcc groff less bash \
		musl-dev libffi-dev openssl-dev \
		python3-dev py-pip jq curl && \
	pip install awscli docker-compose && \
	rm /var/cache/apk/*
COPY --from=build /ecr-login /usr/bin/docker-credential-ecr-login
RUN mkdir /root/.docker
