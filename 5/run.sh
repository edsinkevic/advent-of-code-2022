#!/bin/bash
script_directory=$(dirname "$0")
docker build -t 5-c $script_directory
docker run 5-c
