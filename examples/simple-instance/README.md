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

### Init, Plan, & Apply

This the prerequisites taken care of and ssh key created you should be able to run the following command:

```shell
terraform init
```

Should output something like this:

```
Initializing modules...
- module.router
  Getting source "../../"
- module.vpc
  Found version 1.15.0 of terraform-aws-modules/vpc/aws on registry.terraform.io
  Getting source "terraform-aws-modules/vpc/aws"

Initializing provider plugins...
- Checking for available provider plugins on https://releases.hashicorp.com...
- Downloading plugin for provider "aws" (1.0.0)...
- Downloading plugin for provider "template" (1.0.0)...

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

Once the `init` has worked successfully we can see what this module plans to do by running the following command:

```shell
terraform plan -out the.plan
```

Which should list a bunch of output and at the very end tell us:

```
Plan: 18 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

This plan was saved to: the.plan

To perform exactly these actions, run the following command to apply:
    terraform apply "the.plan"
```

Which means we can now apply the plan:


```shell
terraform apply "the.plan"
```

This might take a few minutes but in the end we should see something like this:

```
Apply complete! Resources: 18 added, 0 changed, 0 destroyed.

Outputs:

router-public-ip = 55.173.84.55
```

Take note of the `router-public-ip` value, as we'll need that IP address in order to use the router.

### Verify it worked

It will take the instance a few minutes to boot up, install docker, and start the router. Once you've waited a good 5 minutes, ssh into our instance:

```shell
ssh -i ./ssh_key/id_rsa ubuntu@54.173.84.55
```

From there we can run:

```shell
docker ps
```

And we should see:

```
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
fc158f30cde9        netifi/proteus      "./bin/router-server…"   2 minutes ago       Up 2 minutes                            proteus-router
```

Similarly if we run:

```shell
docker logs proteus-router
```

we should see:

```
2018-01-21 15:19:56,211 INFO i.n.r.Bootstrap [main] 
2018-01-21 15:19:56,214 INFO i.n.r.Bootstrap [main]               _   _  __ _ 
2018-01-21 15:19:56,214 INFO i.n.r.Bootstrap [main]              | | (_)/ _(_)
2018-01-21 15:19:56,214 INFO i.n.r.Bootstrap [main]    _ __   ___| |_ _| |_ _ 
2018-01-21 15:19:56,214 INFO i.n.r.Bootstrap [main]   | '_ \ / _ \ __| |  _| |
2018-01-21 15:19:56,214 INFO i.n.r.Bootstrap [main]   | | | |  __/ |_| | | | |
2018-01-21 15:19:56,215 INFO i.n.r.Bootstrap [main]   |_| |_|\___|\__|_|_| |_|
2018-01-21 15:19:56,215 INFO i.n.r.Bootstrap [main] 
2018-01-21 15:19:56,215 INFO i.n.r.Bootstrap [main] Starting Proteus Router
2018-01-21 15:19:56,218 INFO i.n.r.u.C.ConfigHolder [main] rsocket router bound to 0.0.0.0:8001
2018-01-21 15:19:56,222 INFO i.n.r.u.C.ConfigHolder [main] rsocket router public address set to 127.0.0.1:8001
2018-01-21 15:19:56,223 INFO i.n.r.u.C.ConfigHolder [main] cluster bound to 0.0.0.0:7001
2018-01-21 15:19:56,224 INFO i.n.r.u.C.ConfigHolder [main] cluster service public address set to 127.0.0.1:7001
2018-01-21 15:19:56,225 INFO i.n.r.u.C.ConfigHolder [main] admin service bound to 0.0.0.0:6001
2018-01-21 15:19:56,225 INFO i.n.r.u.C.ConfigHolder [main] admin service public address set to 127.0.0.1:6001
2018-01-21 15:19:56,225 INFO i.n.r.Bootstrap [main] seeding cluster with 127.0.0.1:7001
2018-01-21 15:19:56,751 INFO i.n.r.Bootstrap [main] Cluster Server started
2018-01-21 15:19:56,829 INFO i.n.r.a.RouterSocketAcceptor [main] Setting router id to F02C121C97926CAC52AA
2018-01-21 15:19:56,832 INFO i.n.r.Bootstrap [main] Admin Server started
2018-01-21 15:19:56,835 INFO i.n.r.Bootstrap [main] Router started in 624.37 milliseconds
```

Which indicates that our router is up and running.

## Next Steps

From here you could follow our [Proteus 5 minute Quick Start](https://github.com/netifi/proteus-quickstart/wiki/Proteus-5-minute-Quick-Start) guide. However, you won't need to run the router locally now that you have one running in AWS, and you'll need to make sure you change the values for:

```
.host("localhost")
```

in the service and client to the `router-public-ip`.

## Clean Up

When you're done running your Proteus Router you can tear down this example with the following command:

```shell
terraform destroy
```