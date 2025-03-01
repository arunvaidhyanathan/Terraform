# Create an IAM User

    Create an IAM User dev-terraform-user
    provide admin permission.
    install terraform - brew install terraform. we can also install tfswitch.

***Initialize Terraform : terraform init
***Terraform Plan : terraform plan
Checking the state what is already is created and what it need to create.
State file - Maintains what is already create and what need to be created.

***Known after apply

To apply the infra - terraform apply

To delete the infra - terraform destroy

##CIDR (Classless Inter-Domain Routing)
-------------------------------------
At its core, CIDR is a notation system for representing IP address blocks. It's used to efficiently allocate and manage IP addresses. The key is the slash (/) notation:

IP Address/Prefix Length: 10.0.0.0/16
10.0.0.0 is the base IP address of the block.
/16 is the prefix length. It specifies how many bits of the IP address are fixed and represent the network. The remaining bits represent the hosts within that network.
How CIDR Works (IPv4 Example: 10.0.0.0/16)

/16 means the first 16 bits of the IP address are part of the network address. In binary, this is:
10.  0.  0.  0  (Decimal)
00001010.00000000.00000000.00000000  (Binary)
Use code with caution.
The first 16 bits (the first two octets) are fixed: 00001010.00000000 which translates to 10.0.
The remaining bits (32 - 16 = 16 bits) are available for host addresses within that network.
This CIDR block 10.0.0.0/16 represents the IP address range 10.0.0.0 to 10.0.255.255. It can accommodate 2<sup>16</sup> (65,536) addresses. However, you typically subtract two addresses: one for the network address itself (e.g., 10.0.0.0) and one for the broadcast address (e.g., 10.0.255.255), leaving 65,534 usable host addresses.
CIDR in AWS

In AWS, CIDR blocks are fundamental for defining:

VPCs (Virtual Private Clouds): When you create a VPC, you must specify a CIDR block for the VPC's address space. This determines the range of private IP addresses that resources within the VPC can use.
Subnets: A VPC is divided into subnets. Each subnet must have a CIDR block that falls within the VPC's CIDR block. Subnets provide isolation and are used to organize resources.
Route Tables: CIDR blocks are used in route tables to define where network traffic should be directed (e.g., traffic destined for a specific CIDR block should go to an internet gateway, a NAT gateway, another VPC, etc.).
Security Groups: CIDR blocks can be used to define source and destination IP address ranges for security group rules (allowing or denying traffic to instances).
Network ACLs (Network Access Control Lists): Similar to security groups, NACLs use CIDR blocks to control inbound and outbound traffic at the subnet level.
CIDR in Terraform

Terraform is an Infrastructure as Code (IaC) tool. It allows you to define and manage your AWS infrastructure in a declarative way. Therefore, CIDR blocks are extensively used in Terraform configurations when creating and managing AWS resources.

cidr_block Argument: Most AWS resources in Terraform that involve networking use a cidr_block argument to specify the IP address range. For example:
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"  # Must be within the VPC's CIDR
  availability_zone = "us-east-1a"
  tags = {
    Name = "public-subnet"
  }
}
Use code with caution.
Terraform
In this example:
aws_vpc defines a VPC with the CIDR block 10.0.0.0/16.
aws_subnet defines a subnet within the VPC with the CIDR block 10.0.1.0/24. Note how the subnet's CIDR is a subset of the VPC's CIDR.
cidrsubnet() Function: Terraform has a built-in cidrsubnet() function that is extremely useful for dynamically calculating CIDR blocks for subnets. This is a best practice for managing IP address ranges in a scalable and predictable way.
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "public1" {
  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, 0)  # creates 10.0.0.0/24
  availability_zone = "us-east-1a"
  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, 1)  # creates 10.0.1.0/24
  availability_zone = "us-east-1b"
  tags = {
    Name = "public-subnet-2"
  }
}
Use code with caution.
Terraform
cidrsubnet(prefix, newbits, netnum):
prefix: The base CIDR block (e.g., aws_vpc.main.cidr_block).
newbits: The number of additional bits to add to the prefix length. In the example, we add 8 bits to the /16 to create a /24 (16 + 8 = 24).
netnum: A decimal number that represents the subnet number. This is used to create different subnets within the larger CIDR block. 0 creates the first subnet, 1 creates the second, and so on.
Why IPv4 and IPv6

IPv4: The original version of the Internet Protocol. It uses 32-bit addresses, which means it can only support a limited number of unique addresses (approximately 4.3 billion). IPv4 is still widely used, but it's facing address exhaustion problems.
IPv6: The successor to IPv4. It uses 128-bit addresses, providing a vastly larger address space (practically limitless). IPv6 is designed to address the IPv4 address exhaustion problem and offers other improvements in security and network management.
CIDR with IPv6

The concept of CIDR applies equally to IPv6. The syntax is the same, but the addresses are much longer.

Example IPv6 CIDR: 2001:db8::/32
2001:db8:: is the base IPv6 address.
/32 is the prefix length.
AWS and IPv6:

AWS supports IPv6 in VPCs. You can associate both IPv4 and IPv6 CIDR blocks with a VPC.
Subnets can be configured to be IPv6-only, IPv4-only, or dual-stack (supporting both).
You need to configure routing and security groups to handle IPv6 traffic.
Terraform and IPv6:

In Terraform, you would use IPv6 CIDR blocks in the cidr_block argument of resources like aws_vpc and aws_subnet when you want to create IPv6-enabled VPCs and subnets.
Terraform also has the cidrsubnet() function that can be used with IPv6 prefixes. You have the cidrhost() and cidrnetmask() as well.
Example Terraform with IPv6

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  ipv6_cidr_block = "2600:1f16:7a0:dd00::/56" # Example IPv6 CIDR
  assign_generated_ipv6_cidr_block = true # Alternative to defining ipv6_cidr_block directly
  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  ipv6_cidr_block = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, 0)
  assign_ipv6_address_on_creation = true #instances launched in this subnet will be assigned an IPv6 address
  availability_zone = "us-east-1a"

  tags = {
    Name = "public-subnet"
  }
}
Use code with caution.
Terraform
Key Takeaways

CIDR is a fundamental notation for representing IP address blocks.
It's essential for defining VPCs, subnets, route tables, and security groups in AWS.
Terraform uses CIDR blocks extensively in resource configurations, especially with the cidr_block argument and the cidrsubnet() function.
AWS and Terraform support both IPv4 and IPv6. IPv6 is the future and provides a much larger address space.
When working with IPv6, the same CIDR concepts apply, just with longer addresses.





    -
Create Policy:

{
    "Version": "2025-02-22",
    "Statement": [
        {
            "Sid": "AllowPostgreSQLActions",
            "Effect": "Allow",
            "Action": [
                "rds:CreateDBInstance",
                "rds:ModifyDBInstance",
                "rds:DeleteDBInstance",
                "rds:DescribeDBInstances",
                "rds:CreateDBSecurityGroup",
                "rds:AuthorizeDBSecurityGroupIngress",
                "rds:DescribeDBSecurityGroups",
                "ec2:DescribeSecurityGroups",
                "ec2:CreateSecurityGroup",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:DeleteSecurityGroup"

            ],
            "Resource": "*"  //Ideally, restrict this to the specific RDS instance ARN.
        },
        {
            "Sid": "AllowVPCRead",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeVpcs",
                "ec2:DescribeSubnets"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowS3AccessForTerraformState",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject",
                "s3:ListBucket"
            ],
            "Resource": "arn:aws:s3:::YOUR_TERRAFORM_STATE_BUCKET/*"  //Replace with your bucket ARN
        },
          {
              "Sid": "AllowIAMPassRole",
              "Effect": "Allow",
              "Action": "iam:PassRole",
              "Resource": "arn:aws:iam::*:role/YOUR_IAM_ROLE_NAME", // Replace with your IAM role ARN
              "Condition": {
                  "StringEquals": {
                      "iam:PassedToService": "rds.amazonaws.com"
                  }
              }
          }
    ]
}