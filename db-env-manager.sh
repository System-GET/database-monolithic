#!/bin/bash

declare local SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)";

source "$SCRIPT_DIR/setup/scripts/fn-create-network.sh";
source "$SCRIPT_DIR/setup/scripts/fn-clean-env.sh";

fn_main () {
  declare local OPTION, CONFIRM;
  declare local RUN_COMPOSE="docker compose -f";
  declare local COMPOSE_PATH="/setup/compose";

  while true; do
    clear;

    echo "GERENCIADOR DE AMBIENTE DE BANCO DE DADOS";
    echo "";
    echo "1) Subir ambiente de desenvolvimento";
    echo "2) Subir ambiente de QA";
    echo "3) Subir ambiente de staging";
    echo "4) Subir ambiente de homologação";
    echo "5) Subir ambiente de produção";
    echo "";
    echo "11) Parar ambiente de desenvolvimento";
    echo "12) Parar ambiente de QA";
    echo "13) Parar ambiente de staging";
    echo "14) Parar ambiente de homologação";
    echo "15) Parar ambiente de produção";
    echo "";
    echo "21) Rodar migrations em ambiente de desenvolvimento";
    echo "22) Rodar migrations em ambiente de QA";
    echo "23) Rodar migrations em ambiente de staging";
    echo "24) Rodar migrations em ambiente de homologação";
    echo "25) Rodar migrations em ambiente de produção";
    echo "";
    echo "31) Rodar testes unitários em ambiente de desenvolvimento";
    echo "32) Rodar testes unitários em ambiente de QA";
    echo "33) Rodar testes unitários em ambiente de staging";
    echo "34) Rodar testes unitários em ambiente de homologação";
    echo "35) Rodar testes unitários em ambiente de produção";
    echo "";
    echo "41) Criar infraestrutura de rede";
    echo "42) Criar containers base";
    echo "43) Limpar ambiente (containers, volumes, imagens e redes)";
    echo "";
    echo "0) Sair";

    echo "";
    echo "================================";
    read -p "Escolha uma opção: " OPTION;
    echo "================================";
    echo "";

    case $OPTION in
      1) ${RUN_COMPOSE} ${SCRIPT_DIR}${COMPOSE_PATH}/docker-compose.dev.yaml     up -d; ;;
      2) ${RUN_COMPOSE} ${SCRIPT_DIR}${COMPOSE_PATH}/docker-compose.qa.yaml      up -d; ;;
      3) ${RUN_COMPOSE} ${SCRIPT_DIR}${COMPOSE_PATH}/docker-compose.staging.yaml up -d; ;;
      4) ${RUN_COMPOSE} ${SCRIPT_DIR}${COMPOSE_PATH}/docker-compose.homolog.yaml up -d; ;;
      5) ${RUN_COMPOSE} ${SCRIPT_DIR}${COMPOSE_PATH}/docker-compose.prod.yaml    up -d; ;;

      11) ${RUN_COMPOSE} ${SCRIPT_DIR}${COMPOSE_PATH}/docker-compose.dev.yaml     down; ;;
      12) ${RUN_COMPOSE} ${SCRIPT_DIR}${COMPOSE_PATH}/docker-compose.qa.yaml      down; ;;
      13) ${RUN_COMPOSE} ${SCRIPT_DIR}${COMPOSE_PATH}/docker-compose.staging.yaml down; ;;
      14) ${RUN_COMPOSE} ${SCRIPT_DIR}${COMPOSE_PATH}/docker-compose.homolog.yaml down; ;;
      15) ${RUN_COMPOSE} ${SCRIPT_DIR}${COMPOSE_PATH}/docker-compose.prod.yaml    down; ;;

      21) ${RUN_COMPOSE} ${SCRIPT_DIR}${COMPOSE_PATH}/docker-compose.dev.yaml     run --rm dev_flyway     migrate; ;;
      22) ${RUN_COMPOSE} ${SCRIPT_DIR}${COMPOSE_PATH}/docker-compose.qa.yaml      run --rm qa_flyway      migrate; ;;
      23) ${RUN_COMPOSE} ${SCRIPT_DIR}${COMPOSE_PATH}/docker-compose.staging.yaml run --rm staging_flyway migrate; ;;
      24) ${RUN_COMPOSE} ${SCRIPT_DIR}${COMPOSE_PATH}/docker-compose.homolog.yaml run --rm homolog_flyway migrate; ;;
      25) ${RUN_COMPOSE} ${SCRIPT_DIR}${COMPOSE_PATH}/docker-compose.prod.yaml    run --rm prod_flyway    migrate; ;;

      31) ${RUN_COMPOSE} ${SCRIPT_DIR}${COMPOSE_PATH}/docker-compose.dev.yaml     run --rm dev_pg_prove ;;
      32) ${RUN_COMPOSE} ${SCRIPT_DIR}${COMPOSE_PATH}/docker-compose.qa.yaml      run --rm qa_pg_prove ;;
      33) ${RUN_COMPOSE} ${SCRIPT_DIR}${COMPOSE_PATH}/docker-compose.staging.yaml run --rm staging_pg_prove ;;
      34) ${RUN_COMPOSE} ${SCRIPT_DIR}${COMPOSE_PATH}/docker-compose.homolog.yaml run --rm homolog_pg_prove ;;
      35) ${RUN_COMPOSE} ${SCRIPT_DIR}${COMPOSE_PATH}/docker-compose.prod.yaml    run --rm prod_pg_prove ;;

      41) echo "Criando infraestrutura de rede...";
        sleep 1;
        fn_create_network dev_net     bridge 172.18.0.0/16;
        fn_create_network qa_net      bridge 172.19.0.0/16;
        fn_create_network staging_net bridge 172.20.0.0/16;
        fn_create_network homolog_net bridge 172.21.0.0/16;
        fn_create_network prod_net    bridge 172.22.0.0/16;
        echo "A infraestrutura de rede está pronta!";
      ;;
      42) ${RUN_COMPOSE} ${SCRIPT_DIR}${COMPOSE_PATH}/docker-compose.base.yaml up -d; ;;     
      43) fn_clean_env ;;
      
      0) echo "Saindo..."; sleep 3; clear; exit 0; ;;

      *) echo "Opção inválida. Tente novamente."; sleep 1; ;;
    esac;
    
    echo "================================";
    echo "";
    read -p "Pressione ENTER para continuar...";
  done;
};

fn_main;