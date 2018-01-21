# simple-instance

This example was built so that you could start with nothing and have a router running and accessable to your local machine in a few minutes.

We will create the following things with this module:

- A VPC
- Public Subnets
- An Internet gateway and appropriate routing tables
- A security group to govern access to your Proteus Router
- A key pair so you can access your Proteus Router
- An instance running the Proteus Router

## Usage

### Prerequisites

We assume that you already have access to an AWS account and credential key pair with the AdministratorAccess policy attached. To use your credential key pair with this project please set the following environment variables in the shell before executing any `terraform` commands:

```shell
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```

We also assume that you have [Terraform](https://www.terraform.io/downloads.html) already installed.

### Input Variables

These are the following variables that are already wired up for you to override. We recommend putting this overrides in a `terraform.tfvars` file inside of this directory rather than overriding the variable defaults.

`aws_region`

 - This specifies which region the instance is going to be deployed into.

`tags`

 - Specifies any additional tags that the resources should have appended.

`security_group_cidr_blocks`

 - A list of cidr blocks that should have access to the Proteus Router. Since you will be accessing the router over the internet they should reference public ip addresses. By default we allow everyone access to the host so that it is easier to start developing.

`name`

 - A name that should be used to identify all the resources created by this example project.

### Outputs

`router-public-ip`

 - This is the public ip address of the router which your code should use for development and testing.


### SSH Key Pair

#### Create a new key

Run the following command __from this directory__.

```shell
ssh-keygen -t rsa -b 4096 -C "proteus-test@example.com"
```

When `ssh-keygen` asks: 

```
Enter file in which to save the key:
``` 

be sure to reply with: 

```
./ssh_key/id_rsa
```

When you're done creating the key, make sure to run: 

```shell
chmod -R 400 ./ssh_key
```

so that you can use it.

#### Use an existing key

To use an existing key simply copy the __public__ key of the existing key to: `./ssh_key/id_rsa.pub`

When you're done creating the key, make sure to run: 

```shell
chmod -R 400 ./ssh_key
```

so that you can use it.

A public key will typically start with `ssh-rsa AAAA` and can often be found in your `$HOME/.ssh/` directory ending with a `.pub`, for example: 

```shell
cat $HOME/.ssh/id_rsa.pub
```

should show an existing key that you might often use from the host that you might be running this example from.

### Init & Apply

This the prerequisites taken care of and ssh key created you should be able to run the following command:

```shell
terraform init
```

```shell
terraform apply
```

### Destroy

When you're done running your Proteus Router you can tear down this example with the following command:

```shell
terraform destroy
```

## Next Steps
