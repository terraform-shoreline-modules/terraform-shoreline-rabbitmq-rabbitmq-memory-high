resource "shoreline_notebook" "rabbitmq_memory_high_incident" {
  name       = "rabbitmq_memory_high_incident"
  data       = file("${path.module}/data/rabbitmq_memory_high_incident.json")
  depends_on = [shoreline_action.invoke_rabbitmq_connections_script,shoreline_action.invoke_modify_memory_limit]
}

resource "shoreline_file" "rabbitmq_connections_script" {
  name             = "rabbitmq_connections_script"
  input_file       = "${path.module}/data/rabbitmq_connections_script.sh"
  md5              = filemd5("${path.module}/data/rabbitmq_connections_script.sh")
  description      = "An increase in the number of connections to the Rabbitmq server, causing it to consume more memory resources."
  destination_path = "/agent/scripts/rabbitmq_connections_script.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "modify_memory_limit" {
  name             = "modify_memory_limit"
  input_file       = "${path.module}/data/modify_memory_limit.sh"
  md5              = filemd5("${path.module}/data/modify_memory_limit.sh")
  description      = "Increase the memory allocation for Rabbitmq by adding more RAM or increasing the memory limit."
  destination_path = "/agent/scripts/modify_memory_limit.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_rabbitmq_connections_script" {
  name        = "invoke_rabbitmq_connections_script"
  description = "An increase in the number of connections to the Rabbitmq server, causing it to consume more memory resources."
  command     = "`chmod +x /agent/scripts/rabbitmq_connections_script.sh && /agent/scripts/rabbitmq_connections_script.sh`"
  params      = ["RABBITMQ_LOG_FILE_PATH","RABBITMQ_PID_FILE_PATH","RABBITMQ_PID","RABBITMQ_MAX_CONNECTIONS"]
  file_deps   = ["rabbitmq_connections_script"]
  enabled     = true
  depends_on  = [shoreline_file.rabbitmq_connections_script]
}

resource "shoreline_action" "invoke_modify_memory_limit" {
  name        = "invoke_modify_memory_limit"
  description = "Increase the memory allocation for Rabbitmq by adding more RAM or increasing the memory limit."
  command     = "`chmod +x /agent/scripts/modify_memory_limit.sh && /agent/scripts/modify_memory_limit.sh`"
  params      = ["OLD_MEMORY_LIMIT","NEW_MEMORY_LIMIT"]
  file_deps   = ["modify_memory_limit"]
  enabled     = true
  depends_on  = [shoreline_file.modify_memory_limit]
}

