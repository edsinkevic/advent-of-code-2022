#!/bin/bash
script_directory=$(dirname "$0")
docker build -t 4-st $script_directory
docker run 4-st
