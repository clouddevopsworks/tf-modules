variable "zone_id" {
  type        = string
  description = "The ID of the hosted zone to contain this record"
}

variable "fqdn" {
  type        = string
  description = "The name of the record"
}

variable "record_type" {
  type        = string
  description = "The record type"
}

variable "ttl" {
  type        = number
  description = "The TTL of the record"
}

variable "record" {
  type        = list(string)
  description = "A string list of records"
}