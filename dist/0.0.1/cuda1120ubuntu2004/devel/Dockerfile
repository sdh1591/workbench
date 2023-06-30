FROM nvidia/cuda:11.2.0-devel-ubuntu20.04
# cudnn
COPY ./resources/cudnn-linux-x86_64-8.6.0.163_cuda11-archive.tar.xz /usr/local/cudnn-linux-x86_64-8.6.0.163_cuda11-archive.tar.xz
RUN echo "INFO: installing [cudnn] ..." \
    && cd /usr/local/ && tar -xvf cudnn-linux-x86_64-8.6.0.163_cuda11-archive.tar.xz \
    && rm cudnn-linux-x86_64-8.6.0.163_cuda11-archive.tar.xz \
    && ln -s cudnn-linux-x86_64-8.6.0.163_cuda11-archive cudnn \
    && cp cudnn/include/cudnn*.h cuda/include/ \
    && echo "INFO: [cudnn] installed!"
# env
RUN echo "INFO: exporting [cuda & cudnn] ..." \
    && echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/cudnn/lib' >> ~/.buildenv \
    && echo "INFO: [cuda & cudnn] exported!"



# 1. install dependencies
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Seoul
# @TODO add locale

# 1.1. install dev-tools
RUN echo "INFO: installing [dev-tools] ..." \
    && apt-get update \
    && apt-get -y install git \
    && apt-get -y install make build-essential \
    && apt-get -y install wget curl \
    && apt-get -y install sqlite3 libsqlite3-dev \
    && apt-get -y install libssl-dev \
    && apt-get -y install zlib1g-dev libbz2-dev libncursesw5-dev libffi-dev libreadline-dev \
    && echo "INFO: [dev-tools] installed!"

# 1.2. install ssh & sshfs
RUN echo "INFO: installing [ssh & sshfs] ..." \
    && apt-get -y install openssh-server net-tools \
    && echo "INFO: [ssh] installed!" \
    && apt-get -y install fuse sshfs \
    && echo "INFO: [sshfs] installed!" \
    && mkdir /var/run/sshd \
    && sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#Port 22/Port 22/' /etc/ssh/sshd_config \
    && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
    && /usr/bin/ssh-keygen -A \
    && echo "INFO: [ssh] configured!"

# 1.3. install vim & screen & expect
RUN echo "INFO: installing [vim & screen & expect] ..." \
    && apt-get -y install vim screen expect \
    && echo "INFO: [vim & screen & expect] installed!"


# 2. install runtimes
ENV PYTHON_VERSION=3.8.11
ENV NODE_VERSION=10.15.3

# 2.1. install pyenv & python 3.8 & pipenv
RUN echo "INFO: installing [pyenv & python 3.8 & pipenv] ..." \
    && curl https://pyenv.run | bash \
    && echo 'export PYTHON_VERSION=$PYTHON_VERSION' >> ~/.buildenv \
    && echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.buildenv \
    && echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.buildenv \
    && echo 'eval "$(pyenv init -)"' >> ~/.buildenv \
    && echo "INFO: [pyenv: $(pyenv --version)] installed!" \
    && . ~/.buildenv \
    && pyenv install ${PYTHON_VERSION} \
    && pyenv global ${PYTHON_VERSION} \
    && echo "INFO: [python: $(pip --version)] installed!" \
    && pip install pipenv \
    && echo "INFO: [pipenv: $(pipenv --version)] installed!"

# 2.2. install nvm & nodejs 10.x
RUN echo "INFO: installing [nvm & nodejs 10.x] ..." \
    && cd ~ && wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | sh \
    && echo 'export NODE_VERSION=$NODE_VERSION' >> ~/.buildenv \
    && echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.buildenv \
    && echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.buildenv \
    && echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> ~/.buildenv \
    && echo "INFO: [nvm: $(nvm --version)] installed!" \
    && . ~/.buildenv \
    && nvm install ${NODE_VERSION} \
    && echo "INFO: [node: $(node --version)] installed!"


# 3. install services

# 3.1. install code-server
RUN echo "INFO: installing [code-server] ..." \
    && curl -fsSL https://code-server.dev/install.sh | sh \
    # && cat ~/.config/code-server/config.yaml \ # @TODO err: No such file or directory
    && echo "INFO: [code-server] installed!"

# 3.2. install jupyter-lab
RUN echo "INFO: installing [jupyter-lab] ..." \
    && . ~/.buildenv \
    && pip install jupyterlab \
    && pip install voila \
    && echo "INFO: [jupyter-lab] installed!"

# 3.3. install extra(scaffolding, ...) tools; amplify cli, react cli, flask cli
RUN echo "INFO: installing [@aws-amplify/cli & create-react-app] ..." \
    && . ~/.buildenv \
    && npm install -g @aws-amplify/cli \
    && echo "INFO: [@aws-amplify/cli] installed!" \
    && npm install -g create-react-app \
    && echo "INFO: [create-react-app] installed!"


# 4. append env to .bashrc
RUN echo "INFO: append .buildenv to .bashrc" \
    && cat ~/.buildenv >> ~/.bashrc \
    && echo "INFO: .bashrc updated!"


# 5. create entrypoint.sh
ENV PASSWORD moagen5525

# 5.1. create run_jupyterlab.sh
RUN echo "INFO: creating [run_jupyterlab.sh] ..." \
    && cd ~ && echo '#!/usr/bin/env bash' > /run_jupyterlab.sh \
    && echo 'source ~/.bashrc' >> /run_jupyterlab.sh \
    && echo 'echo run_jupyterlab.sh: changing password...' >> /run_jupyterlab.sh \
    && echo "export PASSWORD=${PASSWORD}" >> /run_jupyterlab.sh \
    # - expect jupyter-lab password
    && echo 'expect -c "' >> /run_jupyterlab.sh \
    && echo 'spawn jupyter-lab password' >> /run_jupyterlab.sh \
    && echo 'expect \"Enter password:\"' >> /run_jupyterlab.sh \
    && echo 'send ''\"'"$PASSWORD"'\\n\"' >> /run_jupyterlab.sh \
    && echo 'expect \"Verify password:\"' >> /run_jupyterlab.sh \
    && echo 'send ''\"'"$PASSWORD"'\\n\"' >> /run_jupyterlab.sh \
    && echo 'expect \"\[JupyterPasswordApp\]\"' >> /run_jupyterlab.sh \
    && echo 'exit' >> /run_jupyterlab.sh \
    && echo '"' >> /run_jupyterlab.sh \
    # -/
    && echo 'echo run_jupyterlab.sh: PASSWORD=$PASSWORD' >> /run_vscode.sh \
    && echo 'echo executing [jupyter-lab] ...' >> /run_jupyterlab.sh \
    && echo 'cd / && jupyter-lab --ip 0.0.0.0 --port 8888 --allow-root --no-browser' >> /run_jupyterlab.sh \
    && echo 'echo [jupyter-lab] terminated!' >> /run_jupyterlab.sh \
    && chmod 755 /run_jupyterlab.sh \
    && echo 'INFO: [run_jupyterlab.sh] created!'

# 5.2. create run_vscode.sh
RUN echo "INFO: creating [run_vscode.sh] ..." \
    && cd ~ && echo '#!/usr/bin/env bash' > /run_vscode.sh \
    && echo 'source ~/.bashrc' >> /run_vscode.sh \
    && echo "export PASSWORD=${PASSWORD}" >> /run_vscode.sh \
    && echo 'echo run_vscode.sh: PASSWORD=$PASSWORD' >> /run_vscode.sh \
    && echo 'echo executing [code-server] ...' >> /run_vscode.sh \
    && echo 'code-server --bind-addr 0.0.0.0:8080 --auth password' >> /run_vscode.sh \
    && echo 'echo [code-server] terminated!' >> /run_vscode.sh \
    && chmod 755 /run_vscode.sh \
    && echo 'INFO: [run_vscode.sh] created!'

# 5.3. create entrypoint.sh
RUN echo "INFO: creating [entrypoint.sh] ..." \
    && cd ~ && echo '#!/bin/sh' > /entrypoint.sh \
    && echo '/usr/sbin/sshd' >> /entrypoint.sh \
    && echo 'screen -S jupyter-lab -dm /bin/bash -c' "'"'. ~/.buildenv && /run_jupyterlab.sh'"'" >> /entrypoint.sh \
    && echo '/bin/bash -c' "'"'. ~/.buildenv && /run_vscode.sh'"'" >> /entrypoint.sh \
    && echo 'exec "$@"' >> /entrypoint.sh \
    && chmod 755 /entrypoint.sh \
    && echo 'INFO: [entrypoint.sh] created!'


# 6. init 
# 6.1. users
RUN echo 'root:moagen5525' | chpasswd
# 6.2. mount
# @TODO sshfs
# 6.3. shell
# SHELL ["/bin/bash", "-c"] # @TODO
WORKDIR /root
# 6.4. ports
# - reserved ports
EXPOSE 8080/tcp 8888/tcp
# - available ports
EXPOSE 22/tcp 80/tcp 443/tcp 3000/tcp 5000/tcp 
# 6.5. entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
# 6.6. default command
CMD ["/bin/bash"]
