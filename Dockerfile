FROM ruby:2.6.5-alpine

VOLUME ["/data"]

RUN gem install bundler 
RUN apk add build-base ffmpeg git

COPY . .
RUN bundle install 

RUN bundle exe rake build
RUN gem install eufycam-$(bundle exec rake version:current).gem

WORKDIR /data

ENTRYPOINT ["eufycam"]

