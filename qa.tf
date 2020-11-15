# Nano Instance to test the configuration from inside
# Tried with ubuntu but it does not have docker nor aws installed

## Creates a mini instances and adds to DNS
resource "aws_spot_instance_request" "qa" {
  count                       = 1
  ami                         = "ami-02ccb28830b645a41" # Linux 2
  instance_type               = "t3.medium"
  key_name                    = "appup-mc"
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id, aws_security_group.allow_http.id]
  subnet_id                   = aws_subnet.subnet_appup[0 + (count.index)].id
  associate_public_ip_address = true
  user_data                   = file("/Users/manohar/Documents/workspace/appup-devops/docker/qa/install.sh")

  // Connection to be used by provisioner to perform remote executions
  connection {
    // Use public IP of the instance to connect to it.
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("/Users/manohar/appup-workspace/pem/appup-mc.pem")
    timeout     = "3m"
    agent       = false
    host        = self.public_ip
  }

  # Copies the string in content into /tmp/file.log
  provisioner "file" {
    source      = "/Users/manohar/Documents/workspace/appup-devops/docker/qa"
    destination = "~"
  }

  tags = {
    Name = "qa-instance"
  }
}

output "qa" {
  value       = aws_spot_instance_request.qa[*].public_ip
  description = "EC2 Test instance"
}
