#!/usr/bin/env bash

BASE_DIR=$(cd ~/caffe_refactoring_online && pwd)
CAFFE_BUILD=${BASE_DIR}/build/tools
RESULT_DIR=${BASE_DIR}/result
START_ITER=0
STEP=1

. ${BASE_DIR}/schedule/this_alg/VERSION

if [ -f ~/thirdparty/set_env.sh ]; then
    . ~/thirdparty/set_env.sh
fi

if [ "x$1" == "x" ]; then
    echo "Must specific the running id"
    exit
fi

RUNNING_ID=$1
PERF_BIN=~/bin/perf.src/perf

predict_iter_size=20000

W_RUNNING_ID=${RUNNING_ID}
if [ "x$2" != "x" ]; then
    W_RUNNING_ID=$2
fi

if [ "x$3" != "x" ]; then
    predict_iter_size=$3
fi

if [ ! -d ${RESULT_DIR} ]; then
    mkdir -p ${RESULT_DIR}
fi

#set -x

for i in `seq ${START_ITER} ${STEP} ${MAX_EPOCHES}`; do
    modelid=$i

    MODEL_FILE=${BASE_DIR}/model/gdt_snapshots_${ADPOS_TYPE}_${W_RUNNING_ID}_iter_${modelid}.caffemodel
    if [ -f ${MODEL_FILE} ]; then
        ${CAFFE_BUILD}/caffe predict -model ${BASE_DIR}/model/gdt_${ADPOS_TYPE}_predict.prototxt.${RUNNING_ID} \
            -weights ${MODEL_FILE} \
            2>${RESULT_DIR}/labels_${RUNNING_ID}_${modelid}.txt

        grep "label_with_prob\[" ${RESULT_DIR}/labels_${RUNNING_ID}_${modelid}.txt | awk '{print $6 " " $7}' > ${RESULT_DIR}/score_${RUNNING_ID}_${modelid}.txt

        echo -ne "$i\t"

        ${PERF_BIN} -roc -file ${RESULT_DIR}/score_${RUNNING_ID}_${modelid}.txt
    fi
done
