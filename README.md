# FastAPI ECS POC

## Content
- [About](#about)
- [Setup](#setup)
  - [Initialize Terraform](#initialize-terraform)
  - [Deploy](#deploy)
  - [Take Down](#take-down)
- [Testing the App](#testing-the-app)

## About
This is a small POC / template for deploying a FastAPI application to AWS ECS (Fargate)
and exposing it via API gateway. The app is quite simple and contains a single `GET`
endpoint, a single `POST` endpoint, and a documentation URL. The app's
infrastructure is deployed and managed using [terraform](https://www.terraform.io/).

## Setup
In order to set up the POC, first ensure you have the AWS credentials necessary for the deployment,
and that you have Docker installed in your PC. The setup is handled using [Go-Task](https://taskfile.dev/) to handle tasks.

### Initialize Terraform
The first thing you should do before deploying is to initialize Terraform for the project's
infrastructure. To do this, you can run `task terraform init` if you have Task installed. If you don't,
go to the `infrastructure` directory and run `terraform init`.

### Deploy
Finally, to deploy the infrastructure to AWS using terraform, you can run `task deploy`. Running this
will execute the following steps:
- First, it will deploy an ECS repository using Terraform, which will be used to store the application's
  Docker images.
- Next, it will package the Docker image and upload it to this ECR repository.
- Finally, it will deploy the ECS service along with its load balancer and API Gateway configuration.

### Take Down
Once you are done with the app, you can take it down from AWS by running `task take-down` to delete
the infrastructure.

## Testing the App
When the app is deployed, you can test it by hitting the API endpoints or by consulting the docs URL.

To do this, fetch the invoke URL from the terraform outputs and consult the endpoints with:
```python
import requests

endpoint_url = "{invoke-url}"

# Get endpoint
rsp = requests.get(
    "%s/dev/api/v1/add-numbers" % endpoint_url,
    params={"a": 1, "b": 2},
)
print(rsp, rsp.json())

# Post endpoint
rsp = requests.post(
    "%s/dev/api/v1/add-numbers" % endpoint_url,
    json={"a": 1, "b": 2},
)

print(rsp, rsp.json())
```

[Back to top.](#fastapi-ecs-poc)
