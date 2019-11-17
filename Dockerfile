FROM archlinux/base:latest

RUN pacman -Sy && pacman -S --noconfirm awesome tigervnc xorg
RUN pacman -Sy && pacman -S --noconfirm vim wget bc xterm sudo
RUN pacman -Sy && pacman -S --noconfirm otf-fira-code ttf-dejavu

ENV DUMB_INIT_VERSION "1.2.2"

RUN wget -O /usr/local/bin/dumb-init \
"https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}"\
"/dumb-init_${DUMB_INIT_VERSION}_amd64"

RUN useradd -m -G wheel --create-home \
-p "$(openssl passwd -1 changeme)" docker

COPY ./vnc-config/ /vnc_defaults/
COPY ./start.sh /entrypoint

RUN chmod +x /entrypoint
RUN chmod +x /usr/local/bin/dumb-init
RUN chown -R docker /home/docker


COPY ./sudoers-config /etc/sudoers.d/

ENV DISPLAY :1
ENV EDITOR vim

USER docker

VOLUME /home/docker/.vnc

EXPOSE 5901
EXPOSE 5801

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]

CMD ["/entrypoint"]
