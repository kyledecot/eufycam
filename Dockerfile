FROM ruby:2.6.5-alpine

RUN apk add ffmpeg

COPY  . .

