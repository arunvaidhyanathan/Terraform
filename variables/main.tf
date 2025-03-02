variable "vpcname" {
    type = string
    default = "myvpc"
}

variable "sshport" {
    type = number
    default = 22
}

variable "enabled" {
    type = bool
    default = true
}

variable "mylist" {
    type = list(string)
    default = ["value1", "value2", "value3"]
}

variable "mymap" {
    type = map
    default = {
        key1 = "value1"
        key2 = "value2"
        key3 = "value3"
    }
}

resource "aws_vpc" "myvpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = var.inputname
    }
}

variable "inputname" {
    type = string
    description = "set the name of the VPC"
}

output "vpcid" {
    value = aws_vpc.myvpc.id
  
}

variable "mytuple" {
    type = tuple([
        string,
        number,
        bool
    ])
    default = ["value1", 22, true]
  
}

variable "myobject" {
    type = object({
        name = string
        port = list(number)
    })
    default = {
        name = "arun"
        port = [22, 25, 80]
}
}