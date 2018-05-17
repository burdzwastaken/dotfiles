FROM debian:stretch

LABEL Maintainer="Matt Burdan <burdz@burdz.net>"

ADD ./hack/prepare.sh .
RUN ./prepare.sh
RUN rm -rf ./prepare.sh

RUN adduser burdz
RUN chown -R burdz /home/burdz
RUN chown -R burdz /usr/local
USER burdz

RUN mkdir /home/burdz/dotfiles
ADD . /home/burdz/dotfiles/
RUN sudo chown burdz:burdz -R /home/burdz/dotfiles/
WORKDIR /home/burdz/dotfiles

# no passwd in container                                   
RUN echo "burdz ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/burdz  

# hack for cloning
RUN mkdir ~/.ssh && ssh-keyscan -H github.com >> ~/.ssh/known_hosts
RUN ssh-keygen -t rsa -b 4096 -C "burdz@burdz.net" -f $HOME/.ssh/key_name.pem

ENV IN_DOCKER=true
RUN ./hack/bootstrap.sh
RUN echo "./hack/bootstrap.sh still works! (phew), ready for soup!"
