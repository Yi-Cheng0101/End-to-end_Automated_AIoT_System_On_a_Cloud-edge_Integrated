#!/bin/bash

version=$(ls -1 $HOME/DL-Pipeline-Tutorial/saved_model/input_models | wc -l)
(( version = version -1 ))
rm ./output_v$version*
rm -f $HOME/DL-Pipeline-Tutorial/top_model_weights_$version.h5
rm -rf $HOME/DL-Pipeline-Tutorial/saved_model/x_test/$version
