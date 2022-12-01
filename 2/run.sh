#!/bin/bash
script_directory=$(dirname "$0")
docker build -t 2-asm $script_directory
docker run 2-asm
