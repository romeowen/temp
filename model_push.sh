#/bin/bash

. ./news/VERSION

if [[ $# -lt 1 ]];then
    echo "please input running_id"
    exit 1
fi

#:<<'gdttest'
mc_path=/data/home/datamining/modelclient_gdttest/shell
version=$ALGVERSION.$ALGSUBVER.0
hdfs_model_dir_dnn=/user/datamining/modelpushserver/DNN
time_str=$1
caffe_home=/data/home/datamining/caffe_refactoring_online
hadoop_bin=/data/home/datamining/hadoop-2.2.0/bin/hadoop

rm -f $mc_path/pctr.mdl-$version
cp -f ${caffe_home}/model/caffe_mixed_model_${time_str}.bin $mc_path/pctr.mdl-$version

${hadoop_bin} fs -rmr $hdfs_model_dir_dnn/$version/$time_str
${hadoop_bin} fs -mkdir $hdfs_model_dir_dnn/$version/$time_str
$mc_path/startModelClient.sh -a ${version} -f $mc_path/pctr.mdl-${version} -d $hdfs_model_dir_dnn/${version}/$time_str/pctr.mdl-${version}
sleep 5
#gdttest

#:<<'gdt'
mc_path=/data/home/datamining/modelclient_gdt/shell
version=$ALGVERSION.$ALGSUBVER.0
hdfs_model_dir_dnn=/user/datamining/modelpushserver/DNN
time_str=$1
caffe_home=/data/home/datamining/caffe_refactoring_online
hadoop_bin=/data/home/datamining/hadoop-2.2.0/bin/hadoop

rm -f $mc_path/pctr.mdl-$version
cp -f ${caffe_home}/model/caffe_mixed_model_${time_str}.bin $mc_path/pctr.mdl-$version

${hadoop_bin} fs -rmr $hdfs_model_dir_dnn/$version/$time_str
${hadoop_bin} fs -mkdir $hdfs_model_dir_dnn/$version/$time_str
$mc_path/startModelClient.sh -a ${version} -f $mc_path/pctr.mdl-${version} -d $hdfs_model_dir_dnn/${version}/$time_str/pctr.mdl-${version}
sleep 5
#gdt

:<<'sandbox'
mc_path=/data/home/datamining/modelclient_sandbox/shell
version=$ALGVERSION.$ALGSUBVER.0
hdfs_model_dir_dnn=/user/datamining/modelpushserver/DNN
time_str=$1
caffe_home=/data/home/datamining/caffe_refactoring_online
hadoop_bin=/data/home/datamining/hadoop-2.2.0/bin/hadoop

rm -f $mc_path/pctr.mdl-$version
cp -f ${caffe_home}/model/caffe_mixed_model_${time_str}.bin $mc_path/pctr.mdl-$version

${hadoop_bin} fs -rmr $hdfs_model_dir_dnn/$version/$time_str
${hadoop_bin} fs -mkdir $hdfs_model_dir_dnn/$version/$time_str
$mc_path/startModelClient.sh -a ${version} -f $mc_path/pctr.mdl-${version} -d $hdfs_model_dir_dnn/${version}/$time_str/pctr.mdl-${version}
sandbox


