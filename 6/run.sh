#!/bin/bash
script_directory=$(dirname "$0")
docker build -t 6-php $script_directory
docker run 6-php
