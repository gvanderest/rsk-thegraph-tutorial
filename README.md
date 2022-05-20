# RSK TheGraph Tutorial

[TheGraph](https://thegraph.com/en/) is a system that allows you to watch the blockchain on various networks and surface an indexed GraphQL API (called a subgraph) for querying in your stack. The main benefit to this approach is that your queries can be much faster against an indexed database, avoiding the need to make a round-trip JSON-RPC call each time, and you can query and traverse the data very quickly thanks to the GraphQL interface.

At this time, RSK is not officially supported by TheGraph, but that doesn't mean we can't use it-- we just need to set up a few self-hosted components to enjoy the same benefits existing networks do.

Today, we'll be setting up a few things on an AWS account:

1. A multi-node TheGraph cluster, fronted by an Application Load Balancer (ALB) for throughput and scalability, and
1. a custom subgraph to index and query the RIF Name Service (RNS) on RSK,
1. a multi-node RSK node cluster, which reads the RSK blockchain and lets TheGraph make RPC calls, also fronted by an ALB for redundancy

It should all look like this when we're done:

```plantuml
actor User

cloud {
    node TheGraphALB
    node TheGraph1
    node TheGraph2
    node TheGraphN

    node RSKNodeALB
    node RSKNode1
    node RSKNode2
    node RSKNodeN
}

cloud RSKBlockchain

User --> TheGraphALB
TheGraphALB --> TheGraph1
TheGraphALB --> TheGraph2
TheGraphALB --> TheGraphN

TheGraph1 --> RSKNodeALB
TheGraph2 --> RSKNodeALB
TheGraphN --> RSKNodeALB

RSKNodeALB --> RSKNode1
RSKNodeALB --> RSKNode2
RSKNodeALB --> RSKNodeN

RSKNode1 --> RSKBlockchain
RSKNode2 --> RSKBlockchain
RSKNodeN --> RSKBlockchain
```

## Prerequisites

- An Amazon Web Services (AWS) Account with IAM credentials capable of administrating the account - This tutorial assumes we're using AWS, but with some changes to the templates, we're certain that a parallel or equivalent
- Docker Client
- Terraform Client
- Ansible Client
- MacOS or Linux or Unix Desktop Environment
  - This guide has currently only been tested on MacOS

## Getting Started

1. Clone this repository
   ```shell
   $ git clone git@github.com:gvanderest/rsk-thegraph-tutorial.git
   ```
1. Make a copy of the environment file to populate:
   ```shell
   $ cp .env.example .env
   ```
1. Log into your AWS console and create or retrieve IAM credentials to allow creation of resources.
   - **Note:** You can add the `AdministratorAccess` managed policy to this User to simplify things, but for production usage you will want to be more specific with permissions.
1. Update the `.env` file with the IAM credentials:

   ```shell
   export AWS_ACCOUNT_ID=REPLACE_ME
   export AWS_ACCESS_KEY_ID=REPLACE_ME
   export AWS_SECRET_ACCESS_KEY=REPLACE_ME
   export AWS_DEFAULT_REGION=us-east-1
   ```

1. Create and download a keypair pem file:
   - Name: `rsk-thegraph-tutorial`
   - Key pair type: `RSA` (default)
   - Key pair file format: `.pem` (default)
   - ... Save it to the `/tmp` folder locally

## Deploy the RSK Nodes Cluster

1. Use Terraform to create the infrastructure
   ```shell
   make create-rsk-node-cluster
   ```
1. TODO: Build the Docker image for RSK Nodes
1. TODO: Push the Docker image to ECR
1. TODO: Deploy the Docker image to the host with Ansible

## Defining our Subgraph

- TODO: Where to find the ABI
- TODO: Finding the contract address and starting block
- TODO: Writing our own subgraph translation code
- TODO: Building the Docker image

## Deploy TheGraph Cluster

- TODO: Build docker image for TheGraph and deploy
- TODO: Build docker image for Subgraph and deploy

## Teardown

1. Use Terraform to clean up all the infrastructure from the account.

   ```shell
   make destroy-rsk-node-cluster
   make destroy-thegraph-cluster
   ```

## Now What?

Now that you've reached this point, you can modify the subgraph definition to index any contract interactions you wish and build projects that make use of the indexed data!

Good luck!

## Common Issues

### UnauthorizedOperation: You are not authorized to perform this operation.

This error indicates that the IAM credentials being used do not have permission to retrieve or create resources. Either use different IAM credentials or add the appropriate policy, such as managed policy `AdministratorAccess` in the AWS console.
