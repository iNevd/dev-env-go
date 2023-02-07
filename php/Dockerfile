FROM golang:1.19 as builder

ENV SCRIPT_LIB=/src/vscode-dev-containers/script-library/

RUN mkdir -p "${SCRIPT_LIB}" && cd "${SCRIPT_LIB}" && wget https://raw.githubusercontent.com/microsoft/vscode-dev-containers/main/script-library/common-debian.sh

RUN echo "\
deb http://mirrors.aliyun.com/debian/ stretch main non-free contrib\n\
deb-src http://mirrors.aliyun.com/debian/ stretch main non-free contrib\n\
deb http://mirrors.aliyun.com/debian-security stretch/updates main\n\
deb-src http://mirrors.aliyun.com/debian-security stretch/updates main\n\
deb http://mirrors.aliyun.com/debian/ stretch-updates main non-free contrib\n\
deb-src http://mirrors.aliyun.com/debian/ stretch-updates main non-free contrib\n\
" > /etc/apt/sources.list


FROM php:7.0.33

COPY --from=builder /etc/apt/sources.list /etc/apt/sources.list
# buildkit
COPY --from=builder /src/vscode-dev-containers/script-library/common-debian.sh /tmp/library-scripts/
RUN INSTALL_ZSH=true UPGRADE_PACKAGES=true USERNAME=vscode USER_UID=1000 USER_GID=1000 \
/bin/bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \
&& apt-get clean -y && rm -rf /var/lib/apt/lists/*

RUN ln -s /home/vscode /com.docker.devenvironments.code

USER vscode
WORKDIR /home/vscode
