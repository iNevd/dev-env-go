FROM golang:1.18 as builder

ENV SCRIPT_LIB=/src/vscode-dev-containers/script-library/

RUN mkdir -p "${SCRIPT_LIB}" && cd "${SCRIPT_LIB}" && wget https://raw.githubusercontent.com/microsoft/vscode-dev-containers/main/script-library/common-debian.sh

# RUN echo "\
# deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main non-free contrib\n\
# deb-src http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main non-free contrib\n\
# deb http://mirrors.tuna.tsinghua.edu.cn/debian-security/ bullseye-security main\n\
# deb-src http://mirrors.tuna.tsinghua.edu.cn/debian-security/ bullseye-security main\n\
# deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main non-free contrib\n\
# deb-src http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main non-free contrib\n\
# deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main non-free contrib\n\
# deb-src http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main non-free contrib\n\
# " > /etc/apt/sources.list

# # Install Go tools that are isImportant && !replacedByGopls based on
# # https://github.com/golang/vscode-go/blob/v0.31.1/src/goToolsInformation.ts
ENV GO_TOOLS="\
    golang.org/x/tools/gopls@latest \
    # honnef.co/go/tools/cmd/staticcheck@latest \
    golang.org/x/lint/golint@latest \
    github.com/mgechev/revive@latest \
    github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest \
    github.com/ramya-rao-a/go-outline@latest \
    github.com/go-delve/delve/cmd/dlv@latest"
    # github.com/golangci/golangci-lint/cmd/golangci-lint@latest"
ENV GOPATH=/tmp/gotools
ENV GOPROXY=https://goproxy.cn
RUN mkdir -p /tmp/gotools \
&& echo "${GO_TOOLS}" | xargs -n 1 go install -v

FROM golang:1.18

# gotools
COPY --from=builder /tmp/gotools/bin/* ${GOPATH}/bin/

# COPY --from=builder /etc/apt/sources.list /etc/apt/sources.list
# buildkit
COPY --from=builder /src/vscode-dev-containers/script-library/common-debian.sh /tmp/library-scripts/

RUN INSTALL_ZSH=true UPGRADE_PACKAGES=true USERNAME=vscode USER_UID=1000 USER_GID=1000 \
/bin/bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \
&& apt-get -y install graphviz  \
&& apt-get clean -y && rm -rf /var/lib/apt/lists/*

# RUN ln -s /home/vscode /com.docker.devenvironments.code

# RUN groupadd docker && usermod -aG docker vscode

USER vscode

ENTRYPOINT ["sleep", "infinity"]
USER vscode
WORKDIR /home/vscode
