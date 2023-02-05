# Terraform Module - AWS Route53 zone

Manages a Route53 Hosted Zone. The module support `private` or `public` Zones based on user requirement.

Learn [Terraform](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) documentation for more information.
 
## Input Variables

|  Variable Name |   Type| Description|Allowed values| Default value|Remarks|
| ------------ | ------------ |------------|------------|------------|------------|
| private_zone  | bool |Specify whether to create a public or private dns zone.|true/false|true|mandatory|
| service  | string |An indication whether the resource is created on primary or disaster recovery. Passed in the `Name` of the resource.|dr/dc|dc|mandatory|
| accessibility  |  string |An indication whether the resource is publicly accessed or not. Passed in the `Name` of the resource.|  prv/pub| prv|mandatory|
| domain_name  |  string |This is the name of the hosted zone|NA| NA|mandatory|
| vpc_id  |  string |Configuration block(s) specifying VPC(s) to associate with a private hosted zone.|NA| NA|optional when private_zone=true|
| default_tags  | map(string) |Used as resource Tags.|NA|Refer the Section `Usage`|mandatory|
| tags  | map(string) |Used as resource Tags.|NA|Refer the Section `Usage`|mandatory|


## Usage

1. Create a file with .tf extension.

```
module "hosted_zone" {
  source        = "../../modules/route53-zone"
  private_zone  = true
  service       = "dc"
  accessibility = "prv"
  domain_name   = "poc.we-wash.com"
  vpc_id        = <<vpc id>>
  default_tags  = {
                    company    = "we-wash"
                    department = "technical_operations"
                    createdby  = "terraform"
                  }
  tags          = {
                    environment = "poc"
                  }
}
```

2. Execute the command

Setup the AWS credentials for the relevant environment, prior to execute the below commands. Learn how to configure [Environment variables to configure the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html) for more information.

```
terraform apply -auto-approve -target=module.hosted_zone
```
```
terraform destroy -auto-approve -target=module.hosted_zone
```

`Note: All the variable can be passed as terraform command line parameters.`

## Outputs

|  Variable Name |Type|Description|Remarks
| ------------ | ------------ |------------|------------|
| dns_hosted_zone_id_public_zone  | list(string) |The Hosted Zone ID. This can be referenced by zone records|when private_zone=false|
| name_servers_public_zone  | list(string) |A list of name servers in associated (or default) delegation set|when private_zone=false|
| dns_hosted_zone_id_private_zone  | list(string) |The Hosted Zone ID. This can be referenced by zone records|when private_zone=true|
| name_servers_private_zone  | list(string) |A list of name servers in associated (or default) delegation set|when private_zone=true|

## Authors

admin@we-wash.com