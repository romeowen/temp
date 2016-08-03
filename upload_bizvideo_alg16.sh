#!/bin/bash

  # Assign a name to this task, do not use space inside.
  adpos_id=300
  alg_id=16
  HADOOP_BIN=/data/hadoopenv/hadoop-0.20.1-gdt/bin/hadoop
  drv_id="PSGD4FM4WX_bizvideo_ALG${alg_id}"
  task_name="pctr_lr_upload_${drv_id}"
  # Validate the input parameter.
  time_str=$1
  valid_check=`echo -n $time_str | sed 's/[0-9]\{12\}//g'`
  if [[ $# -eq 1 ]] && [[ x$valid_check = "x" ]]
  then
    true
  else
    logerror $task_name "Invalid input parameter: $@"
    has_failed=1
    return $has_failed
  fi

  # Get the day part.
  day_str=${time_str:0:8}
  model_name="fm_mdl_${adpos_id}.${alg_id}.0" 
  local_model_dir=$GDT_HOME/data/algorithm/sgd4bizvideo
  local_log=$local_model_dir/training_log_lr_${drv_id}.${time_str}  
  hdfs_model_dir_wx=/user/datamining/modelpushserver/WX  
  version="${adpos_id}.${alg_id}.0"
  cd $local_model_dir

  # 0. Check for new model.
  if [[ -e  ${model_name}.${time_str} ]]
  then
    loginfo $task_name "Got new model ${model_name}.$time_str"
  else
    logerror $task_name "There is no new model to upload."
    ((has_failed+=1))
    # NOTE: We don't retry here.
    return $has_failed
  fi
  
  #sleep 5
  loginfo $task_name "sync lr_mdl_${adpos_id}_ALG${alg_id}.bin.$time_str to R160"
  #:<<'WX'
  mc_path=/data/hadoopenv/modelclient_WX_300/shell
  $HADOOP_BIN fs -rmr $hdfs_model_dir_wx/${version}/$time_str
  $HADOOP_BIN fs -mkdir $hdfs_model_dir_wx/${version}/$time_str
  cp -rf $model_name.$time_str $mc_path/lr.mdl-${version}
  $mc_path/startModelClient.sh -a ${version} -f $mc_path/lr.mdl-${version} -d $hdfs_model_dir_wx/${version}/$time_str/pctr.mdl.${version} >> ${local_log} 2>&1 &
  
  if [[ $? -ne 0 ]]; then
    logerror $task_name "Failed to upload model to DNN."
    ((has_failed+=1))
    return $has_failed
  fi  
  #WX


