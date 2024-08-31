# Docker file for running some of the NLP benchmarks
FROM  pytorch/pytorch:2.4.0-cuda12.1-cudnn9-runtime

ENTRYPOINT ["/bin/bash"]

RUN apt update && apt install -y --no-install-recommends \
        neovim \
        pipx && \
    apt clean \
    && rm -rf /var/lib/apt/lists/*

# Fix above:
RUN pipx install poetry==1.8.3 && pipx ensurepath

COPY ./pyproject.toml .
COPY ./poetry.lock .

CMD [ "bash pyproject.toml" ]


