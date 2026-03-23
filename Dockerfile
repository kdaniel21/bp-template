FROM --platform=linux/amd64 nvidia/cuda:12.9.1-cudnn-devel-ubuntu24.04 AS base

ENV TZ=US \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y git gcc g++ nano parallel curl dvipng wget python3-dev && apt-get clean

ENV CONTAINER_USER=uvser
RUN useradd -m -s /bin/bash ${CONTAINER_USER} && \
    echo "${CONTAINER_USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ${CONTAINER_USER}
WORKDIR /workspace

RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/home/${CONTAINER_USER}/.local/bin:${PATH}"

RUN curl -fsSL https://claude.ai/install.sh | bash

ENV VIRTUAL_ENV="/workspace/.venv"
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"
RUN echo 'source /workspace/.venv/bin/activate' >> /home/${CONTAINER_USER}/.bashrc

FROM base AS devcontainer
# In the devcontainer, the source files are automatically mounted.

CMD ["/bin/bash"]

FROM base AS cluster

COPY --chown=${CONTAINER_USER}:${CONTAINER_USER} ./uv.lock ./uv.lock
COPY --chown=${CONTAINER_USER}:${CONTAINER_USER} ./pyproject.toml ./pyproject.toml

RUN uv venv --seed .venv && \
  uv sync

COPY --chown=${CONTAINER_USER}:${CONTAINER_USER} . .

CMD ["/bin/bash"]