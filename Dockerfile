FROM --platform=linux/amd64 debian:bullseye-slim
ARG CALIBRE_RELEASE="6.22.0"

RUN apt-get update && \
  apt-get install --no-install-recommends -y ca-certificates curl xz-utils && \
  curl -o /tmp/calibre-tarball.txz -L "https://download.calibre-ebook.com/${CALIBRE_RELEASE}/calibre-${CALIBRE_RELEASE}-x86_64.txz" && \
  mkdir -p /opt/calibre && \
  tar xpf /tmp/calibre-tarball.txz -C /opt/calibre

FROM --platform=linux/amd64 debian:bullseye-slim

RUN apt-get update && \
  apt-get install --no-install-recommends -y \
    ca-certificates \
    hicolor-icon-theme \
    iproute2 \
    libegl1 \
    libfontconfig \
    libglx0 \
    libnss3 \
    libopengl0 \
    libxcomposite1 \
    libxkbcommon0 \
    libxkbfile1 \
    libxrandr2 \
    libxrandr2 \
    libxtst6 \
    xdg-utils && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

COPY --from=0 /opt/calibre /opt/calibre
RUN /opt/calibre/calibre_postinstall && mkdir /ebooks

COPY start-calibre-server.sh .

EXPOSE 8080
CMD [ "/start-calibre-server.sh" ]
