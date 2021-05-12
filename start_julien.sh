#!/bin/bash

#docker run \
  #-e JENKINS_URL=https://jenkins.pollen-metrology.com/ \
  #-e JENKINS_SECRET=54ca4eb8ab22483fcf6a2dc8525d4dff54640eec5b6f68c61575e65b70a164cd \
  #-e JENKINS_AGENT_WORKDIR=/home/jenkins \
  #-e JENKINS_NAME=Deep_Learning_cuda_10 \
  #-it \
  #-d \
  #--gpus all \
  #--name "deeplearning_debaleena" \
  #--restart always \
  #-v /home/docker/deeplearning_debaleena/jenkins_agent/ws:/home/jenkins \
  #-v /home/deeplearning_script/:/home/scripts/ \
  #--entrypoint "tail -f /dev/null" \
  #pollenm/deeplearning_debaleena

  docker run \
  -it \
  -d \
  --gpus all \
  --name "deeplearning_object_detection_julien" \
  --restart always \
  -v /home/jbaderot\@POLLEN-METROLOGY.local/Object_detection/:/home/scripts/ \
  -p 8092:8091 \
  --entrypoint="/bin/bash" \
  pollenm/deeplearning_object_detection

  #  --entrypoint="/usr/local/bin/jupyter notebook --ip 0.0.0.0 --no-browser --port=8091 --allow-root" \
#
# -v /home/docker/deeplearning_debaleena/jenkins_agent/ws:/home/jenkins \
#  -v /home/deeplearning_script/:/home/scripts/ \

