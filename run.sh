docker run --rm -it \
  -e CHOWN_HOME=yes \
  -e JUPYTER_ENABLE_LAB=yes \
  -e NB_GID=500 \
  -e NB_UID=500 \
  -e GRANT_SUDO=yes \
  --user root \
  -v "$(pwd):/home/jovyan" \
  -p 8888:8888 \
  858604803370.dkr.ecr.us-east-1.amazonaws.com/kyso/jupyterlab:latest
