FROM jupyter/tensorflow-notebook
RUN pip install --upgrade pip
RUN pip install jupyterlab==0.35.2
COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt
RUN jupyter labextension uninstall @jupyter-widgets/jupyterlab-manager
RUN jupyter labextension uninstall @jupyterlab/hub-extension
RUN jupyter labextension uninstall jupyter-threejs
RUN jupyter labextension uninstall jupyterlab-datawidgets
RUN jupyter labextension uninstall jupyterlab_bokeh
RUN jupyter labextension install @kyso/jupyterlab@1.3.1 --no-build
RUN jupyter labextension install @jupyterlab/plotly-extension --no-build
RUN jupyter labextension update jupyterlab_bokeh --no-build
RUN jupyter labextension update @jupyter-widgets/jupyterlab-manager --no-build
RUN jupyter lab build
