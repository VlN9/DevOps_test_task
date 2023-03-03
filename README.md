# Test task for DevOps position

## What is it?
This is the project for deploying dockerized Wordpress application in AWS for a few klicks.

<br>

## What do you need?
You need to install a few utils,rename and put your private key to .ssh directory:

<br>

* [awscli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
* [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
* [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
* [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
* Also you need perform next commands:

<br>

This command is needed for configuring credentials for AWS.

<br>


```
aws configure
```

<br>

This command is needed for correct work the ansible. 


<br>

```
mv <your-private-key> ~/.ssh/devops-task-key.pem && chmod 400 ~/.ssh/devops-task-key.pem
```

<br>

Now you are ready for the project deploying.

## Whats next?
Next you need clone this repository:

<br>

```
git clone https://github.com/VlN9/DevOps_test_task.git
```

<br>

Change working directory to project directory:

<br>

```
cd ./DevOps_test_task
```

<br>

And last but not least, deploy project:

<br>

```
terraform apply -auto-approve
```

### Enjoy your works :)

You can drop your infra with next command:

<br>

```
terraform destroy -auto-approve
```

# The End