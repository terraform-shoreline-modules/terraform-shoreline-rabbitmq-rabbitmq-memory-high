bash

#!/bin/bash



# Define variables

RABBITMQ_PID_FILE=${RABBITMQ_PID_FILE_PATH}

RABBITMQ_LOG_FILE=${RABBITMQ_LOG_FILE_PATH}

RABBITMQ_MAX_CONNECTIONS=${RABBITMQ_MAX_CONNECTIONS}



# Get the current number of open connections to Rabbitmq

CURRENT_CONNECTIONS=$(rabbitmqctl list_connections | grep -v "total" | wc -l)



# Check if the current number of connections is greater than the maximum allowed connections

if [[ "$CURRENT_CONNECTIONS" -gt "$RABBITMQ_MAX_CONNECTIONS" ]]; then

    echo "Number of open connections ($CURRENT_CONNECTIONS) is greater than the maximum allowed connections ($RABBITMQ_MAX_CONNECTIONS)." >> "$RABBITMQ_LOG_FILE"

    

    # Get the process ID of the Rabbitmq server

    RABBITMQ_PID=$(cat "$RABBITMQ_PID_FILE")

    

    # Get the current memory usage of the Rabbitmq server

    MEMORY_USAGE=$(ps -p $RABBITMQ_PID -o rss | grep -v RSS)

    

    echo "Current memory usage of Rabbitmq server: $MEMORY_USAGE" >> "$RABBITMQ_LOG_FILE"

    

    # Restart the Rabbitmq server to free up memory resources

    systemctl restart rabbitmq-server

    

    echo "Rabbitmq server restarted." >> "$RABBITMQ_LOG_FILE"

fi