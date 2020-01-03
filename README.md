# Rundeck_Playgrounds
A repository that contains the IaC Code to Configure and Deploy an AWS AMI that contains Rundeck for testing purposes.

## Important

First verify you have both Terraform and Packer installed before running the project.

---
- `packer --version`
- Should return the binary's version like such: `1.4.3`
- If you don't have Packer installed, please go to [https://www.packer.io/downloads.html](https://www.packer.io/downloads.html)
  
---

- `terraform --version`
- Should return the binary's version like such: `Terraform v0.12.16`
- If you don't have Terraform installed, please go to [https://www.terraform.io/downloads.html](https://www.terraform.io/downloads.html)
---

### Bootstrap Project

- When both `Packer` and `Terraform` are available on your system please navigate directly into the playground's directory.
- `cd v3.2.0/`
- If you are looking to build/test the Rundeck Playground AMI, only run the following: `./ami` and wait for the build to succeed or fail.
- If you are looking to build the infrastructure that uses the Rundeck Playground AMI, navigate into the TF directory, `cd terraform/` and run `terraform apply -auto-approve` **THIS ONLY WORKS IF YOU HAVE PREVIOUSLY BUILT AN AMI**
- If you want to run the whole project that includes building the AMI and the Infrastructure, run `./build-all`