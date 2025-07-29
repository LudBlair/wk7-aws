#generate key pair
resource "tls_private_key" "ec2_key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#public-key

resource "aws_key_pair" "key1" {
  key_name = "terraform-key"
  public_key = tls_private_key.ec2_key_pair.public_key_openssh
}

#download key

resource "local_file" "local-key" {
  filename = "terraform-key.pem"
  content = tls_private_key.ec2_key_pair.private_key_openssh
  file_permission = 0400

}