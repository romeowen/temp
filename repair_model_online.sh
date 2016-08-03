#/bin/bash

. ./news/VERSION

if [[ $# -lt 2 ]];then
    echo "please input running_id and repair_running_id"
    exit 1
fi

#:<<'gdt'
mc_path=/data/home/datamining/modelclient_gdt/shell
version=$ALGVERSION.$ALGSUBVER.0
hdfs_model_dir_dnn=/user/datamining/modelpushserver/DNN
time_str=$1
repair_time_str=$2
caffe_home=/data/home/datamining/caffe_refactoring_online
hadoop_bin=/data/home/datamining/hadoop-2.2.0/bin/hadoop

rm -f $mc_path/pctr.mdl-$version
cp -f ${caffe_home}/model/caffe_mixed_model_${time_str}.bin $mc_path/pctr.mdl-$version

${hadoop_bin} fs -rmr $hdfs_model_dir_dnn/$version/$repair_time_str
${hadoop_bin} fs -mkdir $hdfs_model_dir_dnn/$version/$repair_time_str
$mc_path/startModelClient.sh -a ${version} -f $mc_path/pctr.mdl-${version} -d $hdfs_model_dir_dnn/${version}/$repair_time_str/pctr.mdl-${version}
#gdt


#:<<'gdttest'
mc_path=/data/home/datamining/modelclient_gdttest/shell
version=$ALGVERSION.$ALGSUBVER.0
hdfs_model_dir_dnn=/user/datamining/modelpushserver/DNN
time_str=$1
repair_time_str=$2
caffe_home=/data/home/datamining/caffe_refactoring_online
hadoop_bin=/data/home/datamining/hadoop-2.2.0/bin/hadoop

rm -f $mc_path/pctr.mdl-$version
cp -f ${caffe_home}/model/caffe_mixed_model_${time_str}.bin $mc_path/pctr.mdl-$version

${hadoop_bin} fs -rmr $hdfs_model_dir_dnn/$version/$repair_time_str
${hadoop_bin} fs -mkdir $hdfs_model_dir_dnn/$version/$repair_time_str
$mc_path/startModelClient.sh -a ${version} -f $mc_path/pctr.mdl-${version} -d $hdfs_model_dir_dnn/${version}/$repair_time_str/pctr.mdl-${version}
#gdttest