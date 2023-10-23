FROM nvcr.io/nvidia/pytorch:21.05-py3

ENV HOME=/

RUN apt-get update -y

RUN pip install --upgrade pip==23.2.1 setuptools==67.6.0 wheel==0.40.0
WORKDIR ${HOME}
RUN git clone https://github.com/dlengerer/CenterPointCustomData.git
WORKDIR ${HOME}/CenterPoint
RUN pip install -r requirements.txt
ENV PYTHONPATH "$PYTHONPATH:/workspace/CenterPoint"
ENV PATH "$PATH:/usr/local/cuda-11.3/bin"
ENV CUDA_PATH "/usr/local/cuda-11.3"
ENV CUDA_HOME "/usr/local/cuda-11.3"
ENV LD_LIBRARY_PATH "$LD_LIBRARY_PATH:/usr/local/cuda-11.3/lib64"

RUN chmod +x ./setup.sh
RUN ./setup.sh

# Set timezone:
RUN ln -snf /usr/share/zoneinfo/$CONTAINER_TIMEZONE /etc/localtime && echo $CONTAINER_TIMEZONE > /etc/timezone

RUN apt-get update && apt-get install ffmpeg libsm6 libxext6  -y
RUN apt-get install libboost-all-dev -y
RUN pip install cumm-cu113
RUN pip install spconv-cu113

RUN pip install tensorflow==2.5.0
RUN pip install waymo-open-dataset-tf-2-5-0==1.4.1 --user
RUN pip install numpy==1.22.0

WORKDIR ${HOME}/workspace
RUN git clone https://github.com/waymo-research/waymo-open-dataset.git waymo-od
WORKDIR ${HOME}/workspace/waymo-od
RUN git checkout bae19fa

RUN apt-get install --assume-yes pkg-config zip g++ zlib1g-dev unzip python3 python3-pip
ENV BAZEL_VERSION=3.1.0
RUN wget https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh
RUN bash bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh
RUN apt-get install build-essential

RUN ./configure.sh
RUN bazel test waymo_open_dataset/metrics:all --test_verbose_timeout_warnings

RUN bazel clean
RUN bazel build waymo_open_dataset/metrics/tools/compute_detection_metrics_main
RUN cp bazel-bin/waymo_open_dataset/metrics/tools/compute_detection_metrics_main /CenterPoint/compute_detection_metrics_main

RUN pip install opencv-python==4.5.5.64

WORKDIR $HOME/CenterPoint


