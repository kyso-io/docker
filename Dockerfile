FROM jupyter/tensorflow-notebook
RUN pip install --upgrade pip
RUN pip install jupyterlab==0.35.4
RUN pip install nbresuse
RUN jupyter serverextension enable --py nbresuse
COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt
RUN jupyter labextension uninstall @jupyter-widgets/jupyterlab-manager
RUN jupyter labextension uninstall @jupyterlab/hub-extension
RUN jupyter labextension uninstall jupyter-threejs
RUN jupyter labextension uninstall jupyterlab-datawidgets
RUN jupyter labextension uninstall jupyterlab_bokeh

RUN jupyter labextension install @jupyterlab/plotly-extension --no-build
RUN jupyter labextension install @jupyterlab/statusbar --no-build
RUN jupyter labextension update jupyterlab_bokeh --no-build
RUN jupyter labextension update @jupyter-widgets/jupyterlab-manager --no-build
RUN jupyter labextension install @kyso/jupyterlab@1.8.3 --no-build
RUN pip install kyso_jupyterlab
RUN jupyter serverextension enable --sys-prefix kyso_jupyterlab
RUN jupyter lab build
RUN cd /opt/conda/share/jupyter/lab/staging/ && \
  node yarn.js && \
  node yarn.js clean && \
  node yarn.js build:prod && \
  cd /home/jovyan
RUN conda install pymeep -y
USER root
RUN apt-get update
RUN apt-get install -y python3-dev zlib1g-dev libjpeg-dev cmake swig python-pyglet python3-opengl libboost-all-dev libsdl2-dev \
    libosmesa6-dev patchelf ffmpeg xvfb
USER $NB_UID
RUN pip install gym
RUN pip install gym[atari]
RUN pip install gym[box2d]
RUN pip install gym[classic_control]
RUN pip install pyscreenshot Pillow pyvirtualdisplay
