# Rundeck_Playgrounds
A repository that contains the IaC Code to Configure and Deploy an AWS AMI that contains Rundeck for testing purposes.

## Important

First verify you have Terraform, Packer and the AWS CLI installed before running the project.

---

- Run the following command on your system: `packer --version`
- It should return the binary's version like such: `1.4.3`
- If you don't have Packer installed, please go to [https://www.packer.io/downloads.html](https://www.packer.io/downloads.html)
  
---

- Run the following command on your system: `terraform --version`
- It should return the binary's version like such: `Terraform v0.12.16`
- If you don't have Terraform installed, please go to [https://www.terraform.io/downloads.html](https://www.terraform.io/downloads.html)
  
---

- Run the following command on your system: `aws`
- It should return an output similar to the following:

```txt
usage: aws [options] <command> <subcommand> [<subcommand> ...] [parameters]
To see help text, you can run:

  aws help
  aws <command> help
  aws <command> <subcommand> help
aws: error: the following arguments are required: command
```

- If you don't see the output, you don't have the `awscli` installed, please go to [https://aws.amazon.com/cli/](https://aws.amazon.com/cli/) and install the CLI.
  
---

### Bootstraping the Project

- When `Packer`, `Terraform` and the `awscli` are available on your system please navigate directly into the desired playground's directory.
- `cd v3.2.0/` or `cd v1.4.4/`
- To run the whole project that includes building the AMI and the Infrastructure, run `./build-all` and it will take care of creating all the necessary files and steps, like creating the `.pem` file that gives you access to the running instance.
