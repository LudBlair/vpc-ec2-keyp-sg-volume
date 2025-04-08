# vpc code 

resource "aws_vpc" "vpc1" {
  cidr_block = "172.120.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true



  tags ={
    Name = "utc-app"
    env = "Dev"
    team = "DevOPs"
  }
}

#internet gateway 
resource "aws_internet_gateway" "igtw1" {
    vpc_id = aws_vpc.vpc1.id
   tags ={
    Name = "utc-app"
    env = "Dev"
    team = "DevOPs"
  } 
}

#subnet public
resource "aws_subnet" "pubsub1" {
  vpc_id = aws_vpc.vpc1.id
  map_public_ip_on_launch = true
  cidr_block = "172.120.1.0/24"
  availability_zone = "us-east-1a"

    tags ={
    Name = "public-us-east-1a"
  } 
}

resource "aws_subnet" "pubsub2" {
  vpc_id = aws_vpc.vpc1.id
  map_public_ip_on_launch = true
  cidr_block = "172.120.2.0/24"
  availability_zone = "us-east-1b"

    tags ={
    Name = "public-us-east-1b"
  } 
}

#subnet private
resource "aws_subnet" "privatesub1" {
  vpc_id = aws_vpc.vpc1.id
  cidr_block = "172.120.3.0/24"
  availability_zone = "us-east-1a"

    tags ={
    Name = "private-us-east-1a"
  } 
}

resource "aws_subnet" "privatesub2" {
  vpc_id = aws_vpc.vpc1.id
  cidr_block = "172.120.4.0/24"
  availability_zone = "us-east-1b"

    tags ={
    Name = "private-us-east-1b"
  } 
}


#nat_gateway

resource "aws_eip" "elasticip1" {
  
}

resource "aws_nat_gateway" "ngtw1" {
  subnet_id = aws_subnet.pubsub1.id
  allocation_id = aws_eip.elasticip1.id
  tags = {
    name = "natgateway"
    env = "dev"
  }
}

#private route Table

resource "aws_route_table" "routetable1" {
  vpc_id = aws_vpc.vpc1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngtw1.id
  }
}


#public route table 

resource "aws_route_table" "routetable2" {
  vpc_id = aws_vpc.vpc1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igtw1.id
  }

}


#private route table association

resource "aws_route_table_association" "rta1" {
  subnet_id = aws_subnet.privatesub1.id
  route_table_id = aws_route_table.routetable1.id
}

resource "aws_route_table_association" "rta2" {
  subnet_id = aws_subnet.privatesub2.id
  route_table_id = aws_route_table.routetable1.id
}


#public route table association

resource "aws_route_table_association" "rtpublic1" {
  subnet_id = aws_subnet.pubsub1.id
  route_table_id = aws_route_table.routetable2.id
  }

resource "aws_route_table_association" "rtpublic2" {
  subnet_id = aws_subnet.pubsub2.id
  route_table_id = aws_route_table.routetable2.id
  }