# hadolint ignore=DL3026
FROM debian:buster

LABEL Maintainer="Matt Burdan <burdz@burdz.net>"

COPY ./hack/prepare.sh .
RUN ./prepare.sh
RUN rm -rf ./prepare.sh

# no passwd in container
RUN echo "burdz ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/burdz

RUN adduser burdz
RUN chown -R burdz /home/burdz
RUN chown -R burdz /usr/local

RUN mkdir /home/burdz/dotfiles
COPY . /home/burdz/dotfiles/
RUN chown burdz:burdz -R /home/burdz/dotfiles/
USER burdz
WORKDIR /home/burdz/dotfiles

# hack for cloning
RUN mkdir ~/.ssh && ssh-keyscan -H github.com >> ~/.ssh/known_hosts
RUN ssh-keygen -t rsa -b 4096 -C "burdz@burdz.net" -f "$HOME"/.ssh/key_name.pem

ENV IN_DOCKER=true
RUN ./hack/bootstrap.sh
RUN echo "./hack/bootstrap.sh still works! (phew), ready for soup!"
