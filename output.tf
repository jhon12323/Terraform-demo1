output "aws_instance-public_ip" {
    description = "Instance public ip"    
    value = aws_instance.my-ec2-vm.public_ip
  }