#!/bin/bash

fn_create_network () {
  declare local NAME=$1;
  declare local DRIVER=$2;
  declare local SUBNET=$3;

  if docker network inspect "$NAME" >/dev/null 2>&1; then
    echo "Rede $NAME já existe. Pulando...";
    sleep 0.3;
  else
    echo "Criando rede $NAME...";
    docker network create --subnet "$SUBNET" --driver "$DRIVER" "$NAME";
    sleep 0.3;
  fi;
};