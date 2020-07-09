#!/bin/bash

export TRAIN_FILE=/home/ubuntu/data/wikitext-103-raw/wiki.train.raw
export TEST_FILE=/home/ubuntu/data/wikitext-103-raw/wiki.test.raw


python run_language_modeling.py \
    --output_dir=output \
    --model_type=roberta \
    --model_name_or_path=roberta-base \
    --do_train \
    --num_train_epochs=1 \
    --max_steps=100 \
    --per_device_train_batch_size=8 \
    --train_data_file=$TRAIN_FILE \
    --do_eval \
    --eval_data_file=$TEST_FILE \
    --per_device_eval_batch_size=16 \
    --mlm \
    --overwrite_output_dir

    # To run with mixed precision use this flag: --fp16 \
