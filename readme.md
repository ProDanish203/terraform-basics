# Terraform Basics: A Beginner's Guide to Infrastructure as Code

Terraform is an open-source Infrastructure as Code (IaC) tool developed by HashiCorp that allows you to build, change, and version infrastructure safely and efficiently. Unlike traditional methods of manually configuring servers and services, Terraform uses declarative configuration files to describe your desired infrastructure state.

![Terraform](/images/terraform-1.png)

## Key Characteristics of Terraform:

**Cloud Agnostic**: Terraform supports multiple cloud providers including AWS, Azure, Google Cloud, and many others. It can manage any service that has an API, making it incredibly versatile.

**Declarative Approach**: You describe what you want your infrastructure to look like, and Terraform figures out how to make it happen.

**State Management**: Terraform maintains a state file that tracks the current state of your infrastructure, enabling it to make intelligent decisions about what changes need to be applied.

**Resource Graph**: Terraform builds a dependency graph of your resources and parallelizes operations whenever possible for efficient execution.

![Terraform](/images/terraform.png)

## Terraform vs Configuration Management Tools

It's important to understand that Terraform serves a different purpose than configuration management tools:

- **Terraform**: Focuses on **provisioning** infrastructure (creating servers, networks, databases, etc.)
- **Ansible/Chef/Puppet**: Focus on **configuration management** (installing software, configuring applications, managing services)

These tools complement each other perfectly - use Terraform to provision your infrastructure and configuration management tools to configure the software running on that infrastructure.

### Setup and Installation:

1. Download terraform using `choco install terraform`
2. Create a user group on AWS console for terraform, then create a user and add it into the new group with the required permissions
3. Install AWS CLI
4. Configure the AWS using `aws configure`
5. Verify installation: `terraform version`

### Some Common Terraform Commands:

```bash
# Initialize a Terraform working directory
terraform init

# Create an execution plan
terraform plan

# Apply the changes required to reach the desired state
terraform apply

# Destroy the infrastructure
terraform destroy

# Login to Terraform Cloud
terraform login

# State management commands
terraform state list                    # List all resources in state
terraform state show [resource_name]   # Show detailed resource info
terraform show                         # Display all resource details

# Formatting and validation
terraform fmt                          # Format configuration files
terraform validate                     # Validate configuration syntax

# Plan review
terraform plan -out=tfplan             # Save plan to file
terraform apply tfplan                 # Apply saved plan
```

## Terraform Workflow:

The typical Terraform workflow follows these stages:

1. **Write**: Define your infrastructure in configuration files
2. **Plan**: Review the execution plan to understand what changes will be made
3. **Apply**: Execute the plan to create, update, or delete resources
4. **Manage**: Use state management and other commands to maintain your infrastructure

![Terraform Workflow](/images/terraform-workflow.png)

## Understanding Terraform State

The state file is arguably the most critical component of Terraform. It serves as a source of truth for your infrastructure and enables Terraform to:

- Track resource metadata
- Improve performance by caching resource attributes
- Enable collaboration through remote state storage
- Provide dependency mapping

![Terraform Remote Backend](/images/terraform-remote-backend.png)

### Types of Backends:

Terraform supports two main types of backends for state storage:

### 1. Local Backend

Best for individual developers or when collaboration isn't required. The state file is stored locally on your machine.

### 2. Remote Backend

Essential for team collaboration and production environments. Common options include:

**S3 Backend with DynamoDB State Locking**:

```bash

terraform {
  backend "s3" {
    bucket         = "terraform-backend-bucket"
    key            = "terraform/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}
```

**Terraform Cloud Backend**:

```bash

terraform {
  backend "remote" {
    organization = "your-organization"

    workspaces {
      name = "production-infrastructure"
    }
  }
}
```

## Variables and Outputs: Making Configurations Dynamic

Variables make your Terraform configurations reusable and flexible:

```bash
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"

  validation {
    condition     = contains(["t2.micro", "t2.small", "t2.medium"], var.instance_type)
    error_message = "Invalid instance type. Must be one of: t2.micro, t2.small, t2.medium."
  }
}

# Usage in resources
resource "aws_instance" "web" {
  instance_type = var.instance_type
  # ... other configuration
}
```

### Variable Types:

Terraform supports various data types:

```bash
Primitive Types -> string, number, bool
Collection Types -> list, map, set
Complex Types -> object, tuple
```

### Variable Assignment Precedence

Terraform follows a specific order when determining variable values (from lowest to highest priority):

1. Manual entry during plan/apply
2. Default values in variable declaration
3. `TF_VAR_<NAME>` environment variables
4. `terraform.tfvars` file
5. `.auto.tfvars` files
6. Command line flags (`var="key=value"`)

### Local Variables:

Local values help you avoid repetition and make your code more maintainable:

```bash
locals {
  common_tags = {
    Environment = var.environment
    Project     = "web-application"
    ManagedBy   = "terraform"
  }

  service_name = "${var.environment}-web-service"
  service_port = 8080
}

# Usage
resource "aws_instance" "web" {
  tags = local.common_tags
  # ... other configuration
}
```

### Output variables:

Outputs allow you to extract useful information from your Terraform configurations:

```bash
output "instance_public_ip" {
  description = "Public IP address of the web server"
  value       = aws_instance.web.public_ip
}

output "database_connection_string" {
  description = "Database connection string"
  value       = "postgresql://${aws_db_instance.main.username}:${var.db_password}@${aws_db_instance.main.endpoint}/${aws_db_instance.main.name}"
  sensitive   = true
}
```

### Passing variables and variable files via CLI:

```bash
terraform apply -var="db_pass=root"
terraform apply -var-file="terraform.tfvars"
```

## Expressions and Functions

Terraform provides a rich expression language for dynamic configurations:

### String

```bash
"foo" # literal string
"foo ${var.bar}" # template string
```

### Conditionals

```bash
# Ternary operator
instance_type = var.environment == "production" ? "t3.large" : "t2.micro"

# More complex conditions
storage_encrypted = var.environment == "production" || var.environment == "staging" ? true : false
```

### **Other expression types:**

- For expressions
- Splat expressions
- Dynamic blocks
- Type constraints
- Version constraints

### Useful Built-in Functions

```bash
# String functions
upper(var.environment)                    # Convert to uppercase
lower(var.region)                        # Convert to lowercase
join("-", ["web", "server", var.env])   # Join strings with delimiter
split(",", var.availability_zones)      # Split string into list

# Collection functions
length(var.subnet_ids)                   # Get length of list/map
concat(var.public_subnets, var.private_subnets)  # Combine lists
merge(local.common_tags, var.custom_tags)        # Merge maps

# File functions
file("${path.module}/user-data.sh")     # Read file contents
templatefile("config.tpl", var.config_vars)  # Template file with variables

# Encoding functions
base64encode(local.user_data)           # Base64 encode
jsonencode(local.policy_document)       # Convert to JSON
```

### Other function types:

- Collection
- Encoding
- Filesystem
- Date & Time
- Hash & Crypto
- IP Network
- Type Conversion

## Meta-Arguments: Controlling Resource Behavior

Meta-arguments provide special functionality for controlling how Terraform manages resources:

### depends_on

Allows specifying dependencies which do not manifest directly through consumption of data from another resource. For example if the creation order of two resources matters, the latter can be specified to depend on the former.

### count

Allows for creation of multiple of a particular resource or module. This is most useful if each instance configuration is nearly identical.

```bash
resource "aws_instance" "web" {
  count         = 3
  instance_type = "t2.micro"

  tags = {
    Name = "web-server-${count.index + 1}"
  }
}
```

### for_each

Also allows for multiple of a particular resource or module but allows for more control across the instances by iterating over a list.

```bash
resource "aws_instance" "web" {
  for_each = toset(var.availability_zones)

  availability_zone = each.key
  instance_type     = "t2.micro"

  tags = {
    Name = "web-server-${each.key}"
  }
}
```

### lifecycle

Lifecycle meta-arguments control how Terraform treats particular resources.

```bash
resource "aws_instance" "web" {
  # ... configuration

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = true
    ignore_changes       = [tags]
  }
}
```

## Provisioners: Executing Actions

A provisioner allows you to perform some action either locally or on a remote machine. Theres a number of different provisioners like:

```bash
- file
- local-exec
- remote-exec
- vendor
	- chef
	- puppet
```

**Important Note**: Provisioners should be used as a last resort. It's generally better to use cloud-init, user data, or configuration management tools.

## Modules: Organizing and Reusing Code

Modules are containers for multiple resources that are used together. A module consists of a collection of `.tf` files kept together in a directory.

Modules are the main way to package and reuse resource configurations with Terraform.

```bash
module "web_app" {
  source = "../web-app-module"

  # Input variables
  bucket_name = "bucket-name"
  domain      = "abc.com"
  db_name     = "mydb"
  db_user     = "danish"
  db_pass     = var.db_pass
}
```

### Types Of Modules:

Terraform has two types of modules:

- **Root Module** which contains all `.tf` files in your main working directory where you run commands
- **Child Modules** which are separate, reusable modules referenced from other modules using the `module` block.

**Module sources:**

Modules can be sourced from various locations including local filesystem paths, the official Terraform Registry with community modules, Git repositories like GitHub/Bitbucket, HTTP URLs for custom distribution, and cloud storage buckets like S3 or GCS for private organizational modules.

**What makes a good module?**

Good modules raise abstraction levels by hiding complex configurations, group related resources logically, provide sensible defaults while allowing customization, expose necessary input variables for flexibility, and return useful outputs to enable integration with other infrastructure components.

## Managing Multiple Environments:

There are generally two main approaches to manage multiple environments:

### Workspaces:

Use multiple named sections within a single backend:

```bash
# Create and switch to workspaces
terraform workspace new production
terraform workspace new staging
terraform workspace new development

# List workspaces
terraform workspace list

# Switch workspace
terraform workspace select production

# Use workspace in configuration
resource "aws_instance" "web" {
  instance_type = terraform.workspace == "production" ? "t3.large" : "t2.micro"

  tags = {
    Environment = terraform.workspace
  }
}
```

### Directory Structure

Organize environments using separate directories:

```bash
environments/
├── production/
│   ├── main.tf
│   ├── variables.tf
│   └── terraform.tfvars
├── staging/
│   ├── main.tf
│   ├── variables.tf
│   └── terraform.tfvars
└── development/
    ├── main.tf
    ├── variables.tf
    └── terraform.tfvars
```

### Addressing Code Rot

Common issues that can cause "code rot" in Terraform:

1. **Out-of-band changes**: Manual changes made directly in the cloud console
2. **Unpinned versions**: Not specifying provider or module versions
3. **Deprecated dependencies**: Using outdated resources or arguments
4. **Unapplied changes**: Configuration drift between code and actual infrastructure

**Best Practices to Prevent Code Rot**:

- Use version constraints for providers and modules
- Regularly run `terraform plan` to detect drift
- Implement CI/CD pipelines for infrastructure changes
- Use policy as code tools like Sentinel or OPA
- Regular infrastructure audits and updates

# Conclusion

Terraform stands as the industry-leading Infrastructure as Code solution because it combines cloud-agnostic flexibility with declarative simplicity, allowing teams to manage complex infrastructure through version-controlled code rather than manual processes. Its powerful state management, extensive provider ecosystem, and modular architecture make it the optimal choice for organizations seeking to achieve infrastructure consistency, reduce human error, and scale their operations efficiently. By adopting Terraform, you're not just automating infrastructure provisioning - you're embracing a methodology that brings software development best practices to infrastructure management, resulting in more reliable, auditable, and collaborative infrastructure operations that can evolve with your business needs.
