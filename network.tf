#create vpc in us-east-1
resource "aws_vpc" "vpc_master" {
  provider             = aws.region-master
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    "name" = "master-vpc-jenkins"
  }
}

#create vpc in us-west-2
resource "aws_vpc" "vpc_workers" {
  provider             = aws.region-worker
  cidr_block           = "192.168.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    "name" = "worker-vpc-jenkins"
  }

}



#create IGW in us-east-1
resource "aws_internet_gateway" "igw_master" {
  provider = aws.region-master
  vpc_id   = aws_vpc.vpc_master.id
}

#create IGW in us-west-2
resource "aws_internet_gateway" "igw_workers" {
  provider = aws.region-worker
  vpc_id   = aws_vpc.vpc_workers.id
}


#get all availability zones for vpc in master region 
data "aws_availability_zones" "azs" {
  provider = aws.region-master
  state    = "available"
}

#create subnet #1 in us-east-1
resource "aws_subnet" "subnet_1" {
  provider          = aws.region-master
  vpc_id            = aws_vpc.vpc_master.id
  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  cidr_block        = "10.0.1.0/24"
}

#create subnet #2 in us-east-1
resource "aws_subnet" "subnet_2" {
  provider          = aws.region-master
  vpc_id            = aws_vpc.vpc_master.id
  availability_zone = element(data.aws_availability_zones.azs.names, 1)
  cidr_block        = "10.0.2.0/24"
}

#create subnet #1 in us-west-2
resource "aws_subnet" "subnet_1_worker" {
  provider   = aws.region-worker
  vpc_id     = aws_vpc.vpc_workers.id
  cidr_block = "192.168.1.0/24"
}



