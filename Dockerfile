FROM jupyter/tensorflow-notebook

RUN pip install --user --upgrade pipenv
ADD requirements.txt /tmp/requirements.txt

RUN pipenv install -r /tmp/requirements.txt 

RUN jupyter labextension install jupyterlab_bokeh
RUN jupyter labextension install @jupyterlab/plotly-extension
