# Kyso Jupyterlab docker image

We're just gonna use the base jupyter images now

## Run

```bash
docker run --rm -it -v "$(pwd):/home/jovyan" -p 8888:8888 kyso/jupyterlab
```

If you want to be able to sudo within the image (for installing libraries etc) use:

```bash
docker run --rm -it --user root -v "$(pwd):/home/jovyan" -p 8888:8888 kyso/jupyterlab
```

If you get any permission denied errors for writing files within the image run with the
added environment variable ENV CHOWN_HOME=yes

```bash
docker run --rm -it --user root -v "$(pwd):/home/jovyan" -p 8888:8888 -e CHOWN_HOME=yes kyso/jupyterlab
```


## Shortcut

To be able to use this image often without needing to type all that,
add this line to your ~/.bash_profile

```
alias kyso="docker run --rm -it --user root -v "$(pwd):/home/jovyan" -p 8888:8888 kyso/jupyterlab"
```

## To extend this image

Create a Dockerfile

```
FROM kyso/jupyterlab

# your commands here

RUN pip install somelibrary
```

Then to build and run your extended image use:

```
docker build . -t mynewname
```

Then run it with

```
docker run --rm -it --user root -v "$(pwd):/home/jovyan" -p 8888:8888 mynewname
```
