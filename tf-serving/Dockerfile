# docker run -p 8002:8501 --name x_test --mount type=bind,source=/home/yicheng/x_test,target=/models/x_test
# -e MODEL_NAME=x_test -t tensorflow/serving

FROM tensorflow/serving:1.15.0
WORKDIR /models

# RUN apt-get update && apt-get install -y --no-install-recommends curl

COPY x_test /models/x_test
ENTRYPOINT /usr/bin/tensorflow_model_server --model_name=x_test --model_base_path=/models/x_test --rest_api_port=8505
