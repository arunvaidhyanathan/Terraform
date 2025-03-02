provider "aws" {
  region = "us-east-1"
}

resource "aws_db_subnet_group" "mydbsubnetgroup" {
  name       = "mydbsubnetgroup"
  subnet_ids = ["subnet-0425e7a87863355a1", "subnet-09e2ff89b4d3868c6"] # Replace with your actual subnet IDs

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "myrds" {
    engine = "postgres"
    engine_version = "12.15" # Updated engine version
    allocated_storage = 20
    storage_type = "gp2"
    storage_encrypted = true
    multi_az = false
    backup_retention_period = 7
    db_subnet_group_name = aws_db_subnet_group.mydbsubnetgroup.name
    db_name = "csawt"
    identifier = "my-first-rds"
    instance_class = "db.m5.large"
    username = "cads" 
    password = "password"
    port = 5432
    parameter_group_name = "default.postgres12"
    skip_final_snapshot = true
}