FROM jupyter/tensorflow-notebook

ADD requirements.txt /tmp/requirements.txt
RUN conda install --yes --file /tmp/requirements.txt

RUN jupyter labextension install jupyterlab_bokeh
RUN jupyter labextension install @jupyterlab/plotly-extension
