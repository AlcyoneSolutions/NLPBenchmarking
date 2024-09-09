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


# In case we want to add repositorys
RUN service ssh restart

RUN mkdir /opt/nlpbench
WORKDIR /opt/nlpbench

COPY ./linux_requirements.txt /opt/nlpbench/requirements.txt
RUN pip install -r requirements.txt

RUN pip install jupyter
RUN useradd -m -s /bin/bash itl-operator
RUN chown -R itl-operator:itl-operator /opt/nlpbench


USER itl-operator
WORKDIR /opt/nlpbench
EXPOSE 8888

# Might as well setup a jupyter notebook server
# RUN pip install jupyter && \
#     jupyter notebook --generate-config 

ENTRYPOINT ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
