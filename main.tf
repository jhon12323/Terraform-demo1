resource "aws_instance" "my-ec2-vm" {
  ami           = data.aws_ami.amazon.id 
  instance_type = "t2.micro"
  key_name      = "ubuntu"
  #count = terraform.workspace == "default" ? 1 : 1    
	user_data = file("apache.sh")  
  vpc_security_group_ids = [aws_security_group.vpc-ssh.id, aws_security_group.vpc-web.id]
  tags = {
    "Name" = "vm-${terraform.workspace}-0"
  }
# PLAY WITH /tmp folder in EC2 Instance with File Provisioner
  # Connection Block for Provisioners to connect to EC2 Instance
  connection {
    type = "ssh"
    host = self.public_ip # Understand what is "self"
    user = "ec2-user"
    password = ""
    private_key = file("private-key/ubuntu.pem")
  }  

  provisioner "file" {
    source      = "apps/index.html"
    destination = "/tmp/index.html"
  }

# Copies the file to Apache Webserver /var/www/html directory
  provisioner "remote-exec" {
    inline = [
      "sleep 120",  # Will sleep for 120 seconds to ensure Apache webserver is provisioned using user_data
      "sudo cp /tmp/index.html /var/www/html"
    ]
  }

}