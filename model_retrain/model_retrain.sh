#!/bin/sh



version=$(ls -1 $HOME/DL-Pipeline-Tutorial/saved_model/input_models | wc -l) # The model gonna be trained is the verison $version
# echo Model version is: $version
python3 retrain.py data model | tee output_v$version
sleep 5
accuracy=$(cat output_v$version | tail -n 3 | head -n 1 | awk '{print $11}')
# echo Accuracy is: $accuracy
mv output_v$version output_v$version\_$accuracy

saved_model_input="$HOME/DL-Pipeline-Tutorial/saved_model/input_models/top_model_weights_$version.h5"
saved_model_output="$HOME/DL-Pipeline-Tutorial/saved_model/x_test/$version"
cp $HOME/DL-Pipeline-Tutorial/model_retrain/model/top_model_weights.h5 $saved_model_input

#exoprt savedmodel from .h5 file
python3 $HOME/DL-Pipeline-Tutorial/saved_model/export_saved_model.py $saved_model_input $saved_model_output

sleep 10
echo "Done!!! This is model version $version"

