data "aws_ami" "windows_2022" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base-*"]
  }
}

resource "aws_instance" "api_server" {
  ami                    = data.aws_ami.windows_2022.id
  instance_type          = "t3.medium"
  subnet_id              = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  key_name = "my-ec2-keypair"

  user_data_replace_on_change = true

  root_block_device {
    volume_size = 50
    volume_type = "gp3"
  }

  user_data = <<EOF
  <powershell>
  ${file("${path.module}/../bootstrap/ec2-bootstrap.ps1")}
  </powershell>
  EOF

}