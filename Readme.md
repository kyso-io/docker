
# Kyso Jupyterlab docker image

## Install

First install docker on your machine, then run:

```
docker pull kyso/jupyterlab
```

## Usage

To run it in your current working folder, use:

```
docker run --rm -it -v "$(pwd):/home/ds/mnt" -p 8888:8888 kyso/jupyterlab
```

### Using a custom jupyter_config file

In your current directory, just make a folder called .jupyter and create a file
jupyter_config.py inside it. Jupyter and Jupyterlab inside the docker image
will use it by default.

## Todo

When we have a good working build, transfer the default jupyter config files
into the image itself, we don't want to always need to specify a config file
for default params.
