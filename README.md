
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Rabbitmq memory high incident.
---

A Rabbitmq memory high incident occurs when a node uses more than 90% of the allocated RAM. This can cause performance issues and impact the overall functionality of the system. It is important to promptly address this issue to prevent any further damage.

### Parameters
```shell
export RABBITMQ_PID="PLACEHOLDER"

export RABBITMQ_PID_FILE_PATH="PLACEHOLDER"

export RABBITMQ_LOG_FILE_PATH="PLACEHOLDER"

export RABBITMQ_MAX_CONNECTIONS="PLACEHOLDER"

export NEW_MEMORY_LIMIT="PLACEHOLDER"

export OLD_MEMORY_LIMIT="PLACEHOLDER"
```

## Debug

### Check the status of the Rabbitmq service
```shell
sudo systemctl status rabbitmq-server
```

### Check the memory usage of the Rabbitmq process
```shell
sudo ps aux | grep rabbitmq
```

### Check the memory usage of the Rabbitmq process using pidstat
```shell
sudo pidstat -r -p ${RABBITMQ_PID}
```

### Check the Rabbitmq log for any errors related to memory usage
```shell
sudo tail -f /var/log/rabbitmq/rabbit*.log | grep "memory"
```

### Check the system memory usage to see if there is any other process consuming too much memory
```shell
sudo free -h
```

### Check the Rabbitmq queue size and message count
```shell
sudo rabbitmqctl list_queues
```

### Restart the Rabbitmq service to clear any memory leaks
```shell
sudo systemctl restart rabbitmq-server
```

### An increase in the number of connections to the Rabbitmq server, causing it to consume more memory resources.
```shell
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


```

## Repair

### Increase the memory allocation for Rabbitmq by adding more RAM or increasing the memory limit.
```shell
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


```