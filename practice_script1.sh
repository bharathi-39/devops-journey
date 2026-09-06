#!/bin/bash

#Author: Bharathi Ganesh S
#DATE: 5/9/26
#Description: This scripts will be having few of the commands that is used to learn coding in linux
#commands : ps -ef ; df -h ; free -g ; nproc ; top ; if loop ; for loop ; trap ; grep ; wget ; kill ; awk

set -eox

ps -ef

free

nproc

ps -ef | grep "system" 

ps -ef | grep "system" | awk -F" " '{print $2}'

touch nathan.txt

a=10
b=7

if[ $a<$b ]
then
	 echo "A is smaller than B"
else
	 echo "B is smaller than A"
#yahoo
fi


trap 'rm nathan.txt' SIGINT




