#pytorch # ok
#torchvision # ok
#keras # ok
#keras-preprocessing # ok
#jupyter notebook # ok
#matplotlib # ok
#tqdm # ok
#scikit-learn # ok
#scikit-image # ok
#fastai
#opencv # ok
#pyenv

# https://github.com/deezer/spleeter/blob/master/docker/cuda-10-1.dockerfile

#docker build -t pollenm/deeplearning_object_detection .
FROM pollenm/deeplearning_cuda_10_1 as step_cuda

LABEL maintainer "NVIDIA CORPORATION <cudatools@nvidia.com>"


FROM step_cuda as step_tensorflow
# tensorflow-gpu
RUN apt-get update && apt-get install -y \
    python3-dev python3-pip
RUN pip3 install --user --upgrade tensorflow-gpu



FROM step_tensorflow  as steep_python
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y \
	python3-opencv ca-certificates python3-dev git wget sudo  \
	cmake ninja-build && \
  rm -rf /var/lib/apt/lists/*
RUN ln -sv /usr/bin/python3 /usr/bin/python
##
ENV PATH="/home/appuser/.local/bin:${PATH}"
RUN wget https://bootstrap.pypa.io/get-pip.py && \
	python3 get-pip.py && \
	rm get-pip.py

FROM steep_python as steep_pytorch
RUN pip install tensorboard
RUN pip install torch==1.6 torchvision==0.7 -f https://download.pytorch.org/whl/cu101/torch_stable.html
RUN pip install tqdm

RUN pip install 'git+https://github.com/facebookresearch/fvcore'

FROM steep_pytorch as steep_keras
RUN pip3 install keras keras-preprocessing

FROM steep_keras as steep_jupyter_notebook
RUN pip install jupyterlab

FROM steep_jupyter_notebook as steep_matplotlib
RUN python -m pip install -U pip
RUN python -m pip install -U matplotlib

FROM steep_matplotlib as steep_scikit
RUN pip install -U scikit-learn
RUN pip install -U scikit-image

FROM steep_scikit as steep_fastai
RUN pip install -U fastai

FROM steep_fastai as steep_pyenv
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get install -y curl


RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv
RUN echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
RUN echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
RUN echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bash_profile

RUN pip install pipenv

# Install cudatoolskit
RUN apt-get -y install nvidia-cuda-toolkit
