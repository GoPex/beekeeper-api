# Uses GoPex ubuntu_ruby stock image
FROM gopex/ubuntu_ruby:2.3.0
MAINTAINER Albin Gilles "gilles.albin@gmail.com"
ENV REFRESHED_AT 2016-02-08

# Create a working directory for our gem
RUN mkdir /beekeeper-api
WORKDIR /beekeeper-api

# Copy all files into the container
COPY . .
