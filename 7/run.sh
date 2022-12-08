#!/bin/bash
script_directory=$(dirname "$0")
docker build -t 7-perl $script_directory
docker run 7-perl
