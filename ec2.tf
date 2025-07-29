resource "aws_instance" "ec2-server" {
  ami = "ami-071226ecf16aa7d96"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.pub-sub.id
  vpc_security_group_ids = [aws_security_group.SG.id]
  key_name = aws_key_pair.key1.key_name
  user_data = filebase64("setup.sh")

  tags ={
    Name = "terraform_instance"
  }
}