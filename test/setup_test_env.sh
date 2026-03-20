#!/bin/bash

BIN_DIR=bin
TEST_OSSL_3_0_X=${BIN_DIR}/test_openssl_3019
TEST_OSSL_3_5_X=${BIN_DIR}/test_openssl_355
export REPORT_DIR=report
export LOG_DIR=report/log

# TODO SUT_IP also should go from here to test/common.py

# Two ports for each SUT (test exe)
# - One (xxx_AUTOMATION_PORT) port for communicating test control msgs between
#   python script and SUT (test exe)
# - Another port for the actual port [D]TLS connection is made
export OSSL_3_0_X_CLNT_AUTOMATION_PORT=25100
export OSSL_3_0_X_SERV_AUTOMATION_PORT=25200
export OSSL_3_0_X_CLNT_PORT=15100
export OSSL_3_0_X_SERV_PORT=15200
OSSL_3_0_X_CLNT=(${OSSL_3_0_X_CLNT_AUTOMATION_PORT},${OSSL_3_0_X_CLNT_PORT})
OSSL_3_0_X_SERV="${OSSL_3_0_X_SERV_AUTOMATION_PORT},${OSSL_3_0_X_SERV_PORT}"

export OSSL_3_5_X_CLNT_AUTOMATION_PORT=25300
export OSSL_3_5_X_SERV_AUTOMATION_PORT=25400
export OSSL_3_5_X_CLNT_PORT=15300
export OSSL_3_5_X_SERV_PORT=15400
OSSL_3_5_X_CLNT=(${OSSL_3_5_X_CLNT_AUTOMATION_PORT},${OSSL_3_5_X_CLNT_PORT})
OSSL_3_5_X_SERV="${OSSL_3_5_X_SERV_AUTOMATION_PORT},${OSSL_3_5_X_SERV_PORT}"

col_size=4
SUTS_INFO=(${TEST_OSSL_3_0_X} ${OSSL_3_0_X_CLNT} test_openssl_3019_clnt
                            ${OSSL_3_0_X_CLNT_AUTOMATION_PORT}
           ${TEST_OSSL_3_0_X} ${OSSL_3_0_X_SERV} test_openssl_3019_serv
                            ${OSSL_3_0_X_SERV_AUTOMATION_PORT}
           ${TEST_OSSL_3_5_X} ${OSSL_3_5_X_CLNT} test_openssl_355_clnt
                            ${OSSL_3_5_X_CLNT_AUTOMATION_PORT}
           ${TEST_OSSL_3_5_X} ${OSSL_3_5_X_SERV} test_openssl_355_serv
                            ${OSSL_3_5_X_SERV_AUTOMATION_PORT}
          )

# Get nth row and update to 2nd arg
get_sut()
{
    row=$1
    local -n a=$2
    start_idx=$((row * col_size))
    for ((i = 0; i < ${col_size}; i++)); do
        idx=$((start_idx + i))
        a+=(${SUTS_INFO[${idx}]})
    done
}

export LD_LIBRARY_PATH=${BIN_DIR}:$LD_LIBRARY_PATH

if [ -d ${REPORT_DIR} ]; then
    rm -rf ${REPORT_DIR}
fi
mkdir -p ${REPORT_DIR}
mkdir -p ${LOG_DIR}
