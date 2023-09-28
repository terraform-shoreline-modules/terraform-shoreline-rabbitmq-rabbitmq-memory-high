bash

#!/bin/bash



# Set the new memory limit value

NEW_MEMORY_LIMIT=${NEW_MEMORY_LIMIT}



# Stop Rabbitmq

sudo service rabbitmq stop



# Modify the memory limit in the configuration file

sudo sed -i "s/MEMORY_LIMIT=${OLD_MEMORY_LIMIT}/MEMORY_LIMIT=$NEW_MEMORY_LIMIT/g" /etc/rabbitmq/rabbitmq-env.conf



# Start Rabbitmq

sudo service rabbitmq start