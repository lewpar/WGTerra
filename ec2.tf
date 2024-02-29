// WireGuard EC2 Instance
resource "aws_instance" "wireguard-ec2" {
  ami           = "ami-04f5097681773b989" // Ubuntu ap-southeast-2
  instance_type = "t2.micro"
  key_name      = aws_key_pair.wireguard-ec2-key-pair.key_name

  subnet_id = aws_subnet.wireguard-vpc-subnet-1.id
  vpc_security_group_ids = [ aws_security_group.wireguard-nsg.id ]

  associate_public_ip_address = true

  tags = {
    Name = "wireguard-ec2"
  }

  user_data = file("./wireguard-setup.sh")
}

// WireGuard EC2 Instance Key Pair
resource "tls_private_key" "tls-key-pair" {
    algorithm = "RSA"
    rsa_bits = 4096
}

resource "aws_key_pair" "wireguard-ec2-key-pair" {
    key_name = "wireguard-ec2-key-pair"
    public_key = tls_private_key.tls-key-pair.public_key_openssh
}

resource "local_file" "wireguard-ec2-key-pair-private" {
    content = trimspace(tls_private_key.tls-key-pair.private_key_pem)
    filename = "${path.module}/wg.key.pem"
}