# Docker file for running some of the NLP benchmarks

FROM  pytorch/pytorch:2.4.0-cuda12.1-cudnn9-runtime
LABEL maintainers="dev@halcyon.com"


RUN apt update && apt install -y --no-install-recommends \
        neovim \
        curl \
        git \
        gcc &&\
    apt clean &&\
    curl https://pyenv.run | bash &&\
    rm -rf /var/lib/apt/lists/*

ENV PATH="/root/.pyenv/bin:$PATH"
RUN eval "$(pyenv init -)" &&\
  eval "$(pyenv virtualenv-init -)" 

RUN apt update && apt install -y --no-install-recommends \
  software-properties-common \
  pipx &&\
  pipx ensurepath &&\
  pipx install poetry==1.8.3

RUN add-apt-repository  universe

RUN apt install -y --no-install-recommends \
  make

RUN echo -e "\e[1;33m We are about to compile python 3.10. This will take a while.\e[0m" 
RUN pyenv install 3.10.12 &&\
  pyenv global 3.10.12 
CMD [ "/bin/bash" ]

# ENV PATH="/root/.pyenv/bin:$PATH"
# RUN eval "$(pyenv init -)" &&\
#   eval "$(pyenv virtualenv-init -)" 
# # PRINT:" This will take a while." (With escap sequences for colors)
# RUN echo -e "\e[1;33mThis will take a while.\e[0m" 
# RUN pyenv install 3.10.12 &&\
#   pyenv global 3.10.12 &&\
#   pip install poetry==1.8.3 &&\
#   pip install --upgrade pip &&\
#   pip install --upgrade setuptools
#
#
# CMD [ "/bin/bash" ]
#
