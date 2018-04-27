#!/bin/bash
set -e

if [ "$1" = 'jupyterhub' ]; then
    exec jupyterhub -f=.jupyter/jupyterhub_config.py "$@"
fi

exec "$@"
