FROM --platform=linux/amd64 nvidia/cuda:12.9.1-cudnn-devel-ubuntu24.04

ENV TZ=US \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git gcc g++ nano parallel curl dvipng wget \
    python3-dev python-is-python3 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV CONTAINER_USER=user
RUN useradd -m -s /bin/bash ${CONTAINER_USER} && \
    echo "${CONTAINER_USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ${CONTAINER_USER}
WORKDIR /home/${CONTAINER_USER}

RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/home/${CONTAINER_USER}/.local/bin:${PATH}"

RUN curl -fsSL https://claude.ai/install.sh | bash

COPY --chown=${CONTAINER_USER}:${CONTAINER_USER} ./uv.lock ./uv.lock
COPY --chown=${CONTAINER_USER}:${CONTAINER_USER} ./pyproject.toml ./pyproject.toml

RUN uv venv .venv && uv sync --no-install-project

ENV VIRTUAL_ENV="/home/${CONTAINER_USER}/.venv"
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"

WORKDIR /workspace

CMD ["/bin/bash"]