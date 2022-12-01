#!/bin/bash
script_directory=$(dirname "$0")
docker build -t 1-prolog $script_directory
docker run 1-prolog
