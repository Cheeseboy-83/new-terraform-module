variable "name" {
  description = "The name of the network watcher"
  type        = string
}

variable "location" {
  description = "The location of the network watcher"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which the network watcher will be created"
  type        = string
}

variable "tags" {
  description = "The tags to associate with the network watcher"
  type        = map(string)
}