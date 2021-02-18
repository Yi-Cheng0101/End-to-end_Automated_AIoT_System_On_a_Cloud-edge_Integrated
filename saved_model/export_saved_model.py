import tensorflow as tf
import sys

# input_mdoel_path = '~/saved_model/input_models/top_model_weights.h5'
# export_model_path = '~/saved_model/x_test/1'
input_mdoel_path = sys.argv[1]
export_model_path = sys.argv[2]

print("\n\n---------------------------------------------------")
print("The input model path is:", input_mdoel_path)
print("The output model path is:", export_model_path)
print("--------------------------------------------------\n\n")

# The export path contains the name and the version of the model
tf.keras.backend.set_learning_phase(0)  # Ignore dropout at inference
model = tf.keras.models.load_model(input_mdoel_path)

# Fetch the Keras session and save the model
# The signature definition is defined by the input and output tensors
# And stored with the default serving key
for t in model.outputs:
    print('====================')
    print(t.name)

with tf.keras.backend.get_session() as sess:
    tf.saved_model.simple_save(
        sess,
        export_model_path,
        inputs={'image': model.input},
        outputs={t.name: t for t in model.outputs})

