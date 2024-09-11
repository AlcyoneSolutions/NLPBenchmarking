# Docker file for running some of the NLP benchmarks

FROM  pytorch/pytorch:2.4.0-cuda12.1-cudnn9-runtime
LABEL maintainers="dev@halcyon.com"


RUN apt update && apt install -y --no-install-recommends \
        neovim \
        curl \
        git \
        rsync \
        openssh-server \
        gcc &&\
    apt clean &&\
    rm -rf /var/lib/apt/lists/*



COPY ./linux_requirements.txt /opt/nlpbench/requirements.txt
RUN pip install -r /opt/nlpbench/requirements.txt

RUN pip install jupyter
RUN useradd -m -s /bin/bash itl-operator
RUN chown -R itl-operator:itl-operator /opt/nlpbench

# In case we want to add repositorys
# RUN service ssh restart
# Now we want to run sshd in a differnt port (42022)
RUN sed -i 's/^#Port 22/Port 42022/g' /etc/ssh/sshd_config
# Now copy the key ./collective_key.pub to the authorized_keys file
RUN mkdir -p /home/itl-operator/.ssh
COPY ./collective_key.pub /home/itl-operator/.ssh/authorized_keys
RUN chown -R itl-operator:itl-operator /home/itl-operator/.ssh
RUN chmod 600 /home/itl-operator/.ssh/authorized_keys
RUN chmod 700 /home/itl-operator/.ssh
WORKDIR /etc/sshd
RUN ssh-keygen -A

RUN echo '#!/bin/bash\n\
\n\
# Start the SSH server\n\
service ssh start\n\
\n\
# Start Jupyter Notebook\n\
jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root' > /start.sh && \
    chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
