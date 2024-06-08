#!/bin/bash

cd "$(dirname $0)"
pwd

sh grab_logo.sh
sh setup.sh
sh package.sh

