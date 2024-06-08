#!/bin/bash

cd "$(dirname $0)"

sh grab_logo.sh
sh setup.sh
sh package.sh

