#!/bin/bash

fn_clean_env () {
  declare local CONFIRM;
  declare local HAS_CONTAINERS;
  declare local HAS_VOLUMES;
  declare local HAS_IMAGES;
  
  read -p "Tem certeza que deseja LIMPAR TUDO? (y/N): " CONFIRM;
  
  if [[ "$CONFIRM" != "y" ]]; then
    echo "Operação cancelada."
  else
    echo "Limpando ambiente...";
    sleep 1;
    echo "";

    HAS_CONTAINERS=$(docker container ls -aq);
    HAS_VOLUMES=$(docker volume ls -q);
    HAS_IMAGES=$(docker image ls -q);

    [ -n "$HAS_CONTAINERS" ] && docker rm --force $HAS_CONTAINERS;
    [ -n "$HAS_VOLUMES" ]    && docker volume rm $HAS_VOLUMES;
    [ -n "$HAS_IMAGES" ]     && docker image rm $HAS_IMAGES;
    docker network prune --force;
    
    echo "Ambiente limpo com sucesso!";
  fi;
};