#!/bin/sh

# From https://github.com/Sikwan/random-json-logger
# 
# Generate four random log messages:
# 
# {"@timestamp": "2018-03-02T22:33:27-06:00", "level":"ERROR", "message": "something happened in this execution."}
# {"@timestamp": "2018-03-02T22:33:27-06:00", "level":"INFO", "message": "takes the value and converts it to string."}
# {"@timestamp": "2018-03-02T22:33:27-06:00", "level":"WARN", "message": "variable not in use."}
# {"@timestamp": "2018-03-02T22:33:27-06:00", "level":"DEBUG", "message": "first loop completed."}
# 

while [ 1 ]
do
   waitTime=$(shuf -i 1-5 -n 1)
   sleep $waitTime &
   wait $!
   instruction=$(shuf -i 0-4 -n 1)
   d=`date -Iseconds`
   case "$instruction" in
      "1") echo "{\"@timestamp\": \"$d\", \"level\": \"ERROR\", \"message\": \"something happened in this execution.\"}"
      ;;
      "2") echo "{\"@timestamp\": \"$d\", \"level\": \"INFO\", \"message\": \"takes the value and converts it to string.\"}"
      ;;
      "3") echo "{\"@timestamp\": \"$d\", \"level\": \"WARN\", \"message\": \"variable not in use.\"}"
      ;;
      "4") echo "{\"@timestamp\": \"$d\", \"level\": \"DEBUG\", \"message\": \"first loop completed.\"}"
      ;;
   esac
done


