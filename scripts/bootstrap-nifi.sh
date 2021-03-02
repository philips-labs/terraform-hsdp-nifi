#!/bin/bash

usage() {
    cat <<-EOF
usage: bootstrap-cluster.sh
      -n node1,node2,...
      -d docker
      -x external_ip
      -p kafka_certificate_password
      -t zookeeper_trust_store_password
      -k zookeeper_key_store_password
EOF
}

kill_nifi() {
  echo Killing NiFi...
  docker kill nifi
  docker rm nifi
}

create_volume() {
  docker volume create database_repository || echo "'database_repository' volume already created"
  docker volume create provenance_repository || echo "'provenance_repository' volume already created"
  docker volume create flowfile_repository || echo "'flowfile_repository' volume already created"
  docker volume create content_repository || echo "'content_repository' volume already created"
  docker volume create --driver local --name data --opt type=none --opt device=`pwd`/data --opt o=bind || echo "'data' volume already created"
}

start_nifi() {
  local image="$1"
  local external_ip="$2"
#  local cert_pass="$3"
#  local zoo_key_pass="$4"
#  local zoo_trust_pass="$5"
  mkdir -m 777 -p $HOME/data
  docker run -d \
    --restart always \
    --name nifi \
    --env NIFI_JMX_PORT=5555 \
    --env NIFI_WEB_HTTP_PORT=8080 \
    --env NIFI_JVM_HEAP_INIT="$nifi_jvm_xms" \
    --env NIFI_JVM_HEAP_MAX="$nifi_jvm_xmx" \
    -v 'database_repository:/opt/nifi/nifi-current/database_repository' \
    -v 'provenance_repository:/opt/nifi/nifi-current/provenance_repository' \
    -v 'flowfile_repository:/opt/nifi/nifi-current/flowfile_repository' \
    -v 'content_repository:/opt/nifi/nifi-current/content_repository' \
    -v "data:/opt/nifi/nifi-current/data" \
    -p 8282:8080 \
    "$image"
}

load_certificates_and_restart(){
  docker cp ./kafka.truststore.jks kafka:/bitnami/kafka/config/certs/
  docker cp ./kafka.keystore.jks kafka:/bitnami/kafka/config/certs/
  docker cp ./zookeeper.truststore.jks kafka:/bitnami/kafka/config/certs/
  docker cp ./zookeeper.keystore.jks kafka:/bitnami/kafka/config/certs/
  docker exec kafka ls -laR /bitnami/kafka/config/certs
  docker restart kafka -t 10
}

docker_login(){
  if [ -n "${docker_username}" ] || [ -n "${docker_password}" ] || [ -n "${docker_registry}" ]; then
    docker login -u ${docker_username} -p ${docker_password} ${docker_registry}
  fi
}

##### Main
docker_username=
docker_password=
docker_registry=
image=
external_ip=
kafka_cert_pass=
zoo_key_store_pass=
zoo_trust_store_pass=

while [ "$1" != "" ]; do
    case $1 in
        -x | --externalip )     shift
                                external_ip=$1
                                ;;
        --docker-username )     shift
                                docker_username=$1
                                ;;
        --docker-password )     shift
                                docker_password=$1
                                ;;
        --docker-registry )     shift
                                docker_registry=$1
                                ;;
        --docker-image )         shift
                                image=$1
                                ;;        
        --nifi-jvm-xms )        shift
                                nifi_jvm_xms=$1
                                ;;
        --nifi-jvm-xmx )        shift
                                nifi_jvm_xmx=$1
                                ;;
                              
                              
#        -p | --cert-pass )      shift
#                                kafka_cert_pass=$1
#                                ;;
#        -k | --zoo-key-pass )   shift
#                                zoo_key_store_pass=$1
#                                ;;
#        -t | --zoo-trust-pass ) shift
#                                zoo_trust_store_pass=$1
#                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

kill_nifi
create_volume
docker_login
start_nifi "$image" "$external_ip"
#"$kafka_cert_pass" "$zoo_key_store_pass" "$zoo_trust_store_pass"
#load_certificates_and_restart
