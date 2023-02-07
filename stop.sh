#!/bin/bash

# Copyright (c) 2009-2018. Authors: see NOTICE file.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

. configuration.sh

echo "Stopping Cytomine... Data will be preserved in databases."

podman stop ${INSTANCE_PREFIX}memcached
podman rm -v ${INSTANCE_PREFIX}memcached

if [[ "$(podman ps -q -f name=${INSTANCE_PREFIX}rabbitmq)" ]]
then
    podman stop ${INSTANCE_PREFIX}rabbitmq
    podman rm -v ${INSTANCE_PREFIX}rabbitmq
fi

podman stop ${INSTANCE_PREFIX}mongodb
podman rm -v ${INSTANCE_PREFIX}mongodb
podman stop ${INSTANCE_PREFIX}postgresql
podman rm -v ${INSTANCE_PREFIX}postgresql

if [[ "$(podman ps -q -f name=${INSTANCE_PREFIX}backup_mongo)" ]]
then
    podman stop ${INSTANCE_PREFIX}backup_mongo
    podman rm -v ${INSTANCE_PREFIX}backup_mongo
fi

if [[ "$(podman ps -q -f name=${INSTANCE_PREFIX}backup_postgis)" ]]
then
    podman stop ${INSTANCE_PREFIX}backup_postgis
    podman rm -v ${INSTANCE_PREFIX}backup_postgis
fi

if [[ "$(podman ps -q -f name=${INSTANCE_PREFIX}retrieval)" ]]
then
    podman stop ${INSTANCE_PREFIX}retrieval
    podman rm -v ${INSTANCE_PREFIX}retrieval
fi

if [[ "$(podman ps -q -f name=${INSTANCE_PREFIX}iipJP2)" ]]
then
    podman stop ${INSTANCE_PREFIX}iipJP2
    podman rm -v ${INSTANCE_PREFIX}iipJP2
fi

podman stop ${INSTANCE_PREFIX}iipCyto
podman rm -v ${INSTANCE_PREFIX}iipCyto

if [[ "$(podman ps -q -f name=${INSTANCE_PREFIX}bioformat)" ]]
then
    podman stop ${INSTANCE_PREFIX}bioformat
    podman rm -v ${INSTANCE_PREFIX}bioformat
fi

if [[ "$(podman ps -q -f name=${INSTANCE_PREFIX}ims)" ]]
then
    podman stop ${INSTANCE_PREFIX}ims
    podman rm -v ${INSTANCE_PREFIX}ims
fi

if [[ "$(podman ps -q -f name=${INSTANCE_PREFIX}core)" ]]
then
    podman stop ${INSTANCE_PREFIX}core
    podman rm -v ${INSTANCE_PREFIX}core
fi

if [[ "$(podman ps -q -f name=${INSTANCE_PREFIX}webUI)" ]]
then
    podman stop ${INSTANCE_PREFIX}webUI
    podman rm -v ${INSTANCE_PREFIX}webUI
fi

if [[ "$(podman ps -q -f name=${INSTANCE_PREFIX}iris)" ]]
then
    podman stop ${INSTANCE_PREFIX}iris
    podman rm -v ${INSTANCE_PREFIX}iris
fi

podman stop ${INSTANCE_PREFIX}nginx
podman rm -v ${INSTANCE_PREFIX}nginx

if [[ "$(podman ps -q -f name=${INSTANCE_PREFIX}software_router)" ]]
then
    podman stop ${INSTANCE_PREFIX}software_router
    podman rm -v ${INSTANCE_PREFIX}software_router
fi

if [[ "$(podman ps -q -f name=${INSTANCE_PREFIX}slurm)" ]]
then
    podman stop ${INSTANCE_PREFIX}slurm
    podman rm -v ${INSTANCE_PREFIX}slurm
fi

echo "Done."
