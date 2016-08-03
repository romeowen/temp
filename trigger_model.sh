#!/bin/bash

# Usage: exec ads_pos alg_id full_path_model

function _get_current_quarter()
{
    current_min=`date +%Y%m%d%H%M`
    current_hour=${current_min:0:10}
    minutes_only=${current_min:10:2}

    # the statement below does not work for cases such as, quarter=$((08 / 15 * 15))
    # 08: value too great for base (error token is "08")
    # quarter=$((minutes_only / 15 * 15))
    quarter=$(expr $minutes_only / 15 \* 15)
    if [ $quarter -eq 0 ]; then
        quarter='00'
    fi

    echo ${current_hour}${quarter}
}

adpos_id=${1}
alg_id=${2}
model_file=${3}
#quarter_str=`_get_current_quarter`
quarter_str=${4}
hdfs_model_dir=/user/datamining/modelpushserver/DNN

# comment out exit to push the model
echo $hdfs_model_dir/${adpos_id}.${alg_id}.0/$quarter_str
# exit 1

path=$(cd `dirname $0` && pwd)
cd $path

rm -f pctr.mdl-${adpos_id}.${alg_id}.0
cp -f ${model_file} pctr.mdl-${adpos_id}.${alg_id}.0
echo $hdfs_model_dir/${adpos_id}.${alg_id}.0/$quarter_str
${HADOOP_HOME}/bin/hadoop fs -mkdir $hdfs_model_dir/${adpos_id}.${alg_id}.0/$quarter_str

export CLASSPATH=${path}/../lib/hadoop-0.20.1-tdw.0.1-core.jar:${path}/../lib/commons-logging-1.0.4.jar:${path}/../conf
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${path}/../lib:$JAVA_HOME/jre/lib/amd64/server

ulimit -c unlimited

../bin/ModelClient -a ${adpos_id}.${alg_id}.0 \
         -f pctr.mdl-${adpos_id}.${alg_id}.0 \
         -d $hdfs_model_dir/${adpos_id}.${alg_id}.0/$quarter_str/pctr.mdl.${adpos_id}.${alg_id}.0

