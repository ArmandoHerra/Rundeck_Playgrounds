# Rundeck_Playgrounds

![rundeck-horizontal-01](https://user-images.githubusercontent.com/42847572/72653771-1293d080-3952-11ea-9b2f-7a3f64017ce2.jpg)

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

---

## Rundeck v3 API (UI)

We need an **API** token, we can obtain it by following these steps:

## Step 1

Login in your main page, the predeterminate credentials are:

```txt
Username: admin
Password: admin
```

![0](https://user-images.githubusercontent.com/42847572/72653659-926d6b00-3951-11ea-9d13-4db6273e9be5.PNG)

## Step 2

Once logged in, we will go to the top right of the page and click on the user image.

![1](https://user-images.githubusercontent.com/42847572/72653672-a022f080-3951-11ea-9729-9ec9e2d816cf.PNG)

## Step 3

Then we right click on the **"profile"** option.

![2](https://user-images.githubusercontent.com/42847572/72653673-a022f080-3951-11ea-84f1-5ddfaca5541b.PNG)

## Step 4

Once inside, we select the plus icon on the **"User API tokens"** section.

![3](https://user-images.githubusercontent.com/42847572/72653674-a022f080-3951-11ea-9778-332d9beafdc3.PNG)

## Step 5

In this section we write the username to which we want to associate the token with, any roles or groups associated, and the expiration if it's needed. Once done, we click the **"Generate New Token"** button.

![4](https://user-images.githubusercontent.com/42847572/72653675-a022f080-3951-11ea-8785-d9def1da4ffe.PNG)

## Step 6

In the panel we click on the **"Show token"** button.

This will be our token to use de **API**.

![5](https://user-images.githubusercontent.com/42847572/72653676-a0bb8700-3951-11ea-9d0f-77805efaec0d.PNG)

## Using de Rundeck API

### Create Project

In a terminal we can create a new project with the following command.

```sh
curl -vk -X POST $URL:4440/api/11/projects \
  --header "X-Rundeck-Auth-Token: $TOKEN" \
  --header "Content-Type: application/json" \
  --data-raw '{ "name": "$PROJECT_NAME" }'
```

Where the variables equate to the following values.

```sh
$URL="Your Rundeck URL."
$TOKEN="Your Rundeck Token obtained in the previous steps."
$PROJECT_NAME="The name of the project that you want to create."
```

### Get information about our project

In a terminal we can obtain information about our project with the following command.

```sh
curl -vk $URL:4440/api/11/project/$PROJECT_NAME \
  --header "X-Rundeck-Auth-Token: $TOKEN" \
  --header "Content-Type: application/json"
```

Where the variables equate to the following values.

```sh
$URL="Your Rundeck URL."
$TOKEN="Your Rundeck Token."
$PROJECT_NAME="The name of the project that you want to create."
```

## Importing a Job with an XML file

In a terminal we can create a Job with an XML file with the following command.

```sh
curl -vk http://$URL:4440/api/21/project/$PROJECT_NAME/jobs/import \
  --header "X-Rundeck-Auth-Token: $TOKEN" \
  -F xmlBatch=@"$FILENAME"
```

Where the variables equate to the following values.

```sh
$URL="Your Rundeck URL."
$TOKEN="Your Rundeck Token."
$PROJECT_NAME="The name of the project that you created."
$FILENAME="The name of your file with the configuration to create the Job."
```

### Importing an example job

We can use this xml configuration to deploy an example job with the command "Hello World".

```xml
<joblist>
  <job>
    <defaultTab>nodes</defaultTab>
    <description>An example description</description>
    <executionEnabled>true</executionEnabled>
    <id></id>
    <loglevel>INFO</loglevel>
    <name>Example Job</name>
    <nodeFilterEditable>false</nodeFilterEditable>
    <scheduleEnabled>true</scheduleEnabled>
    <sequence keepgoing='false' strategy='node-first'>
      <command>
        <exec>echo "Hello World"</exec>
      </command>
    </sequence>
    <uuid></uuid>
  </job>
</joblist>
```

You can edit the Name of the Job, add more commands, or call scripts.

#### After creating the Job we will obtain an output that looks like this:

```xml
<result success='true' apiversion='34'>
  <succeeded count='1'>
    <job index='1' href='http://$SERVER_IP:4440/api/34/job/$JOB_ID'>
      <id>f3e96a18-f516-4058-b24c-6293fc20c15d</id>
      <name>API</name>
      <group></group>
      <project>Test-Project</project>
      <permalink>http://$SERVER_IP:4440/project/Test-Project/job/show/$JOB_ID</permalink>
    </job>
  </succeeded>
  <failed count='0' />
  <skipped count='0' />
</result>
```

In this output we can see an **"id"**, this is the ID of the job we just imported into Rundeck, we need it to run the Job after importing it.

### Running the example Job

In a terminal we can run the example Job with the following command.

```sh
curl -vk -X POST $URL:4440/api/19/job/$JOB_ID/run \
  --header "X-Rundeck-Auth-Token: $TOKEN" \
  --header "Content-Type:text/xml"
```

Where the variables equate to the following values.

```sh
$URL="Your Rundeck URL."
$TOKEN="Your Rundeck Token."
$JOB_ID="The Job ID obtained when you imported the XML File into Rundeck"
```
