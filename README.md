![rundeck-horizontal-01](https://user-images.githubusercontent.com/42847572/72653771-1293d080-3952-11ea-9b2f-7a3f64017ce2.jpg)

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

# First steps before to use the Rundeck API
We need a **API** token, we can obtein it in the next way
## 1-. 
Login in your main page, the predeterminate credentials are:
User:admin
Password:admin
![0](https://user-images.githubusercontent.com/42847572/72653659-926d6b00-3951-11ea-9d13-4db6273e9be5.PNG)

## 2-.  
Once logged in, we will go to the top right of the page and click on the user image.
![1](https://user-images.githubusercontent.com/42847572/72653672-a022f080-3951-11ea-9729-9ec9e2d816cf.PNG)
## 3-.
Then we right click on the **"profile"** option.
![2](https://user-images.githubusercontent.com/42847572/72653673-a022f080-3951-11ea-84f1-5ddfaca5541b.PNG)
## 4-.

Onse inside, we'll select a plus image in the **"User API tokens"**.
![3](https://user-images.githubusercontent.com/42847572/72653674-a022f080-3951-11ea-9778-332d9beafdc3.PNG)
## 5-.
In this section we'll write the user, role and the expiration if is need it. Once done, we right clic in **"Generate New Token"**.

![4](https://user-images.githubusercontent.com/42847572/72653675-a022f080-3951-11ea-8785-d9def1da4ffe.PNG)
## 6-.
In the panel we right clic in **"Show token"**
This will be our token to use de **API**.
![5](https://user-images.githubusercontent.com/42847572/72653676-a0bb8700-3951-11ea-9d0f-77805efaec0d.PNG)

# Using de Rundeck API

## Create Project

In a terminal we can create a new project with the next command.

    curl -X POST $URL:4440/api/11/projects?authtoken=$TOKEN --header "Content-Type: application/json" --data-raw '{ "name": "$PROJECT_NAME", "config": { "propname":"propvalue" } }'

With the following values:

$URL=Your Rundeck url.
$TOKEN=Your Rundeck token obteined in the defore steps.
$PROJECT_NAME= The name of the project that you want to create.


## Get information about our project

In a terminal we can information about our project to validate with the next command.

   

    curl -X GET $URL:4440/api/11/project/prueba?authtoken=$TOKEN --header "Content-Type: application/json"

With the following values:

$URL=Your Rundeck url.
$TOKEN=Your Rundeck token obteined in the defore steps.

## Create Job with a XML file

In a terminal we can create a Job with a XML file with the next command.

    curl -v --header "X-Rundeck-Auth-Token:$TOKEN" -F xmlBatch=@"$FILENAME"  http://$URL:4440/api/21/project/one/jobs/import

With the following values:

$URL=Your Rundeck url.
$TOKEN=Your Rundeck token obteined in the defore steps.
$FILENAME=The name of your file with the configuration to create the Job.

### We can use this xml configuration to deploy a job with the command "Hello World".

    <joblist>   <job>
        <defaultTab>nodes</defaultTab>
        <description>first manual</description>
        <executionEnabled>true</executionEnabled>
        <id></id>
        <loglevel>INFO</loglevel>
        <name>API</name>
        <nodeFilterEditable>false</nodeFilterEditable>
        <scheduleEnabled>true</scheduleEnabled>
        <sequence keepgoing='false' strategy='node-first'>
         <command> <exec>echo "hello world"</exec>
          </command>
        </sequence>
        <uuid></uuid>   </job> </joblist>

You can edit the Name of the Job or add more commands or call scripts.

### After to create the Job we'll obtein a output like this:

    <id>10fa8c17-ab9b-426b-b8b2-040a0312e1f9</id>
          <name>API</name>
          <group></group>
          <project>one</project>

In this output we can see an **"id"**, this one we need it to run the Job.

## Run the Job

In a terminal we can run the Job  with the next command.

    curl -X POST $URL:4440/api/19/job/$JOBID/run?authtoken=$TOKEN --header "Content-Type:text/xml"

With the following values:

$URL=Your Rundeck url.
$TOKEN=Your Rundeck token obteined in the defore steps.
$JOBID=Your job id that you obtein in the before step.
