#!/bin/bash

HOME=/home/pyuser

BOT_REPO=/share/bot_engine
ENV_DIR=$HOME/bot_engine

source $ENV_DIR/bin/activate

cd $BOT_REPO
pip install -r requirements.txt

cd rasa_ai/
python -m spacy download en
make train-nlu
make train-core

