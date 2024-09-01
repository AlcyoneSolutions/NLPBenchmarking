# Docker file for running some of the NLP benchmarks

FROM  pytorch/pytorch:2.4.0-cuda12.1-cudnn9-runtime
LABEL maintainers="dev@halcyon.com"


RUN apt update && apt install -y --no-install-recommends \
        neovim \
        curl \
        git \
        gcc &&\
    apt clean &&\
    rm -rf /var/lib/apt/lists/*


# In case we want to add repositorys

RUN mkdir /opt/nlpbench
WORKDIR /opt/nlpbench

COPY ./linux_requirements.txt /opt/nlpbench/requirements.txt
RUN pip install -r requirements.txt

CMD ["/usr/sbin/sshd", "-D"]

