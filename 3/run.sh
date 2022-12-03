#!/bin/bash
script_directory=$(dirname "$0")
docker build -t 3-fortran $script_directory
docker run 3-fortran
