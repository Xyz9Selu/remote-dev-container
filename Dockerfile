FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# default args
ARG USERNAME=john
ARG PASSWORD=123456
ARG UID=1000
ARG GID=1000

ENV USERNAME=${USERNAME}
ENV PASSWORD=${PASSWORD}
ENV UID=${UID}
ENV GID=${GID}

# install sudo, gosu
RUN apt-get update && apt-get install -y \
    sudo curl git build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev wget ca-certificates \
    libcurl4-openssl-dev libedit-dev libsqlite3-dev llvm libncursesw5-dev \
    libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev openssh-server \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/sshd && \
  mkdir -p /run /sshd && \
  chown root:root /run/sshd && \
  chmod 755 /run/sshd

# create user and group
RUN groupadd -g ${GID} ${USERNAME} \
  && useradd -m -u ${UID} -g ${GID} -s /bin/bash ${USERNAME} \
  && usermod -aG sudo ${USERNAME} \
  && echo "${USERNAME}:${PASSWORD}" | chpasswd \
  && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ${USERNAME}
WORKDIR /home/${USERNAME}

ENV PYENV_ROOT="/home/${USERNAME}/.pyenv"
ENV PATH="${PYENV_ROOT}/bin:${PATH}"

RUN curl https://pyenv.run | bash
RUN echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc && \
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc && \
    echo 'eval "$(pyenv init --path)"' >> ~/.bashrc

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
RUN echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc && \
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.bashrc

CMD ["sudo", "/usr/sbin/sshd", "-D"]
