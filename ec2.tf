# Nano Instance to test the configuration from inside
# Tried with ubuntu but it does not have docker nor aws installed

## Creates a mini instances and adds to DNS
resource "aws_spot_instance_request" "agents" {
  count = 1
  #ami                         = "ami-00eb20669e0990cb4" # Linux 1
  ami                         = "ami-0dacb0c129b49f529" # Different for each region
  instance_type               = "t3.small"
  key_name                    = "appup-mc"
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id, aws_security_group.allow_http.id]
  subnet_id                   = aws_subnet.subnet_appup[0 + (count.index)].id
  associate_public_ip_address = true
  user_data                   = file("/Users/manohar/Documents/workspace/appup-devops/docker/cloud/agent/install.sh")

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
    source      = "/Users/manohar/Documents/workspace/appup-devops/docker/cloud/agent"
    destination = "~"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x ~/agent/install_nginx.sh",
      "~/agent/install_nginx.sh",
    ]
  }

  tags = {
    Name = "Agent-instance"
  }
}

output "ec2test" {
  value       = aws_spot_instance_request.agents[*].public_ip
  description = "EC2 Test instance"
}

resource "aws_route53_record" "agents" {
  zone_id = aws_route53_zone.route53-appup-ch.zone_id
  name    = "agents"
  type    = "A"
  ttl     = "5"
  records = aws_spot_instance_request.agents[*].public_ip
}


output "ec2test-domain" {
  value       = aws_route53_record.agents[*].name
  description = "EC2 Test instance"
}
