# ## Input Variables in Terraform
# variable "instance_type" {
#   description = "EC2 instance type"
#   type        = string
#   default     = "t2.micro"
# }

# ## Usage (var.instance_type)

# ## Local Variables in Terraform
# locals {
#   service_name = "my_service"
#   service_port = 8080
#   owner        = "Danish Siddiqui"
# }

# ## Output Variables in Terraform
# output "instance_ip_addr" {
#   value = aws_instance.instance.public_ip
# }

# ## Setting input variables (in order of precedence: lowest to highest)
# ## Manual entry durin plan/apply
# ## Default values in declaration block
# ## TF_VAR_<NAME> environment variables
# ## terraform.tfvars file
# ## *.auto.tfvars files
# ## Command line flags (e.g., -var="instance_type=t2.small")

# ## Types and Validations
# ## Types:
# ## Primitive Types: string, number, bool
# ## Collection Types: list, map, set
# ## Complex Types: object, tuple

# ## Validation: 
# ## - Type checking happens automatically
# ## - Custom validation can be added using the `validation` block

# ## Example of a validation block
# variable "instance_type" {
#   description = "EC2 instance type"
#   type        = string
#   default     = "t2.micro"

#   validation {
#     condition     = contains(["t2.micro", "t2.small", "t2.medium"], var.instance_type)
#     error_message = "Invalid instance type. Must be one of: t2.micro, t2.small, t2.medium."
#   }
# }