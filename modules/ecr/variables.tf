variable "repositories" {
  type        = list(string)
  description = "ECR repo list"
}

variable "tags" {
  type = map(string)
}
