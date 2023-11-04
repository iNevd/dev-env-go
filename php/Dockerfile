FROM golang:1.19 as builder

ENV SCRIPT_LIB=/src/vscode-dev-containers/script-library/

RUN mkdir -p "${SCRIPT_LIB}" && cd "${SCRIPT_LIB}" && wget https://raw.githubusercontent.com/microsoft/vscode-dev-containers/main/script-library/common-debian.sh

#You’ve got both stretch-updates and stretch/updates, but the latter doesn’t exist any more (at least on the mirror you’re using). You should remove the references to stretch/updates, or — if you’re expecting the stretch/updates lines to provide security updates — replace them with
#deb http://security.debian.org/ stretch/updates main contrib non-free
#In late April 2023, the Stretch repositories were removed from the main mirrors, so you’ll need to switch to archive.debian.org; see apt-get update failed to fetch debian amd64 packages while building dockerfile from maven:3.5.2-jdk-8 and Security repo for Debian stretch not working anymore for details.
#https://blog.csdn.net/weixin_45892725/article/details/131364739
# RUN echo "\
# deb http://mirrors.aliyun.com/debian-archive/debian/ stretch main non-free contrib\n\
# # deb-src http://mirrors.aliyun.com/debian-archive/debian/ stretch main non-free contrib\n\
# # deb http://mirrors.aliyun.com/debian-archive/debian-security stretch/updates main\n\
# # deb-src http://mirrors.aliyun.com/debian-archive/debian-security stretch/updates main\n\
# # deb http://mirrors.aliyun.com/debian-archive/debian/ stretch-updates main non-free contrib\n\
# # deb-src http://mirrors.aliyun.com/debian-archive/debian/ stretch-updates main non-free contrib\n\
# " > /etc/apt/sources.list
RUN echo "\
deb http://mirrors.aliyun.com/debian-archive/debian/ stretch main non-free contrib\n\
" > /etc/apt/sources.list


FROM php:7.0.33

COPY --from=builder /etc/apt/sources.list /etc/apt/sources.list
# buildkit
COPY --from=builder /src/vscode-dev-containers/script-library/common-debian.sh /tmp/library-scripts/
RUN INSTALL_ZSH=true UPGRADE_PACKAGES=true USERNAME=vscode USER_UID=1000 USER_GID=1000 \
/bin/bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \
&& apt-get clean -y && rm -rf /var/lib/apt/lists/*

# RUN ln -s /home/vscode /com.docker.devenvironments.code

USER vscode
WORKDIR /com.docker.devenvironments.code
