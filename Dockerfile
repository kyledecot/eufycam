FROM ruby:2.6.5-alpine AS build

VOLUME ["/data"]

RUN gem install bundler 

RUN apk add --update-cache \
    git \
		ffmpeg \
		which \
    build-base \
  && rm -rf /var/cache/apk/*

COPY . .
RUN bundle install --

RUN bundle exe rake build && \
	 gem install eufycam-$(bundle exec rake version:current).gem

RUN which ffmpeg
RUN which eufycam
RUN which ruby

WORKDIR /data

ENTRYPOINT ["eufycam"]

