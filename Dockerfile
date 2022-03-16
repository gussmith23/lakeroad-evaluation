FROM ubuntu:22.04

RUN apt-get update \
    && apt-get install -y \
      yosys

WORKDIR /root
ADD . .

WORKDIR /root
CMD ["sh", "./run.sh"]
