# Kyso Jupyterlab docker image

We're just gonna use the base jupyter images now

## Build

```bash
docker build . -t kyso/jupyterlab
```

## Run

```bash
docker run --rm -it -e CHOWN_HOME=yes -e JUPYTER_ENABLE_LAB=yes -e NB_GID=500 -e NB_UID=500 -e GRANT_SUDO=yes --user root -v "$(pwd):/home/jovyan" -p 8888:8888 kyso/jupyterlab
```
