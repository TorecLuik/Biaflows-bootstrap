#!/bin/bash

#
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
#made scripts in a util folder

. ./configuration.sh

if [ -z "$1" ]
then
	echo "No argument supplied. Data is restored from manBU.sql file"
	NAME="manBU.sql"
else
	NAME=$1
fi

podman cp $NAME ${INSTANCE_PREFIX}postgresql:/BU.sql

podman exec -e PGPASSWORD="docker" ${INSTANCE_PREFIX}postgresql psql -h localhost -U docker -c "UPDATE pg_database SET datistemplate = 'false' WHERE datname ='docker'"
podman exec -e PGPASSWORD="docker" ${INSTANCE_PREFIX}postgresql psql -h localhost -U docker -c "select pg_terminate_backend(pid) from pg_stat_activity where datname='docker' AND pid <> pg_backend_pid()"
podman exec -e PGPASSWORD="docker" ${INSTANCE_PREFIX}postgresql dropdb -h localhost -U docker docker

#Then recreate the db (the commands are on your deployment files).
podman exec -e PGPASSWORD="docker" ${INSTANCE_PREFIX}postgresql createdb -h localhost -U docker  --encoding='utf-8' --template=template0 -O docker docker
podman exec -e PGPASSWORD="docker" ${INSTANCE_PREFIX}postgresql psql -h localhost -U docker -d docker -c "CREATE EXTENSION IF NOT EXISTS postgis;"
podman exec -e PGPASSWORD="docker" ${INSTANCE_PREFIX}postgresql psql -h localhost -U docker -d docker -c "CREATE EXTENSION IF NOT EXISTS ltree;"
podman exec -e PGPASSWORD="docker" ${INSTANCE_PREFIX}postgresql psql -h localhost -U docker -d docker -c "GRANT ALL ON geometry_columns TO PUBLIC;"
podman exec -e PGPASSWORD="docker" ${INSTANCE_PREFIX}postgresql psql -h localhost -U docker -d docker -c "GRANT ALL ON geography_columns TO PUBLIC;"
podman exec -e PGPASSWORD="docker" ${INSTANCE_PREFIX}postgresql psql -h localhost -U docker -d docker -c "GRANT ALL ON spatial_ref_sys TO PUBLIC;"


podman exec -e PGPASSWORD="docker" ${INSTANCE_PREFIX}postgresql psql -h localhost -U docker -w -d docker -f /BU.sql

echo "Terminated"


