#!/bin/bash
set -e
EXP_NAME=${1:-baseline}-`date "+%Y-%m-%d-%H-%M-%S"`
PROFILE_NAME=${2:-profile}
S3_BUCKET=ks-profiling-deep-learning
rm -f ${PROFILE_NAME}.qdrep
/opt/nvidia/nsight-systems/2020.3.1/target-linux-x64/nsys profile \
    -t cuda,osrt,nvtx,cudnn,cublas \
    -o ${PROFILE_NAME} \
    -w true run_lm.sh |& tee log.txt
echo "Profiling complete, saving results to S3..."
aws s3 cp ${PROFILE_NAME}.qdrep s3://${S3_BUCKET}/profiles/${EXP_NAME}/ |& tee log.txt -a
aws s3 presign s3://${S3_BUCKET}/profiles/${EXP_NAME}/${PROFILE_NAME}.qdrep \
    --expires-in 2678400 |& tee log.txt -a
aws s3 cp run_profile.sh s3://${S3_BUCKET}/profiles/${EXP_NAME}/
aws s3 cp log.txt s3://${S3_BUCKET}/profiles/${EXP_NAME}/
echo "Results written to s3://${S3_BUCKET}/profiles/${EXP_NAME}/"
