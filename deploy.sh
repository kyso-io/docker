$(aws ecr get-login --no-include-email --region us-east-1)
docker push 858604803370.dkr.ecr.us-east-1.amazonaws.com/kyso/jupyterlab:latest
