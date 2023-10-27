#!/bin/bash

ROOT_PATH="/home/ubuntu/spring-github-action"
JAR_NAME=$(ls $ROOT_PATH/build/libs/ | grep 'SNAPSHOT.jar' | tail -n 1)
JAR_PATH=$ROOT_PATH/build/libs/$JAR_NAME
STOP_LOG="$ROOT_PATH/stop.log"
SERVICE_PID=$(pgrep -f $JAR) # 실행중인 Spring 서버의 PID

if [ -z "$SERVICE_PID" ]; then
  echo "서비스 NouFound" >> $STOP_LOG
else
  echo "서비스 종료 " >> $STOP_LOG
  kill "$SERVICE_PID"
  # kill -9 $SERVICE_PID # 강제 종료를 하고 싶다면 이 명령어 사용

APP_LOG="$ROOT_PATH/application.log"
ERROR_LOG="$ROOT_PATH/error.log"
START_LOG="$ROOT_PATH/start.log"

NOW=$(date +%c)

echo "[$NOW] $JAR 복사" >> $START_LOG
cp $JAR_PATH $ROOT_PATH/$JAR_NAME

echo "[$NOW] > $JAR 실행" >> $START_LOG
nohup java -jar $ROOT_PATH/$JAR_NAME > $APP_LOG 2> $ERROR_LOG &

SERVICE_PID=$(pgrep -f $ROOT_PATH/$JAR_NAME)
echo "[$NOW] > 서비스 PID: $SERVICE_PID" >> $START_LOG