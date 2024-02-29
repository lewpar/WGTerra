// Test RDS Instance
resource "aws_db_instance" "rds-test-db" {
    allocated_storage = 10

    db_name = "test_db"

    engine = "mysql"
    engine_version = "5.7"

    instance_class = "db.t3.micro"

    username = "testuser"
    password = "241db3203b"

    parameter_group_name = "default.mysql5.7"

    db_subnet_group_name = aws_db_subnet_group.rds-test-db-subnet-grp.name

    vpc_security_group_ids = [ aws_security_group.wireguard-nsg.id ]

    skip_final_snapshot = true
}

// Test RDS Subnet Group
resource "aws_db_subnet_group" "rds-test-db-subnet-grp" {
    name = "rds-test-db-subnet-grp"
    
    subnet_ids = [ aws_subnet.wireguard-vpc-subnet-1.id, aws_subnet.wireguard-vpc-subnet-2.id ]

    tags = {
        Name = "rds-test-db-subnet-grp"
    }
}