# Odoo ECS Deployment with AWS Copilot

This project contains the necessary configurations to deploy Odoo on AWS ECS using AWS Copilot.

## Prerequisites

- AWS CLI configured with appropriate permissions
- AWS Copilot CLI installed
- Docker installed locally

## Deployment Instructions

1. Configure preconditions:

```bash
export APP_ENV=prod
```

1. Configure AWS CLI:
```bash
aws iam create-user --user-name copilot-admin
aws iam attach-user-policy --user-name copilot-admin --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
aws iam create-access-key --user-name copilot-admin
aws configure
```

1. Initialize the Copilot application:
```bash
copilot init --app odoo-app
copilot env init --name prod --app odoo-app --profile default
copilot env deploy --name ${APP_ENV} --app odoo-app
```

1. Create the database service:
```bash
copilot svc init --name odoo-db --svc-type "Backend Service" --dockerfile ./Dockerfile.db
```

1. Create the Odoo service:
```bash
copilot svc init --name odoo --svc-type "Backend Service" --dockerfile ./Dockerfile
```

1. Set up secrets:
```bash
# Set Odoo admin password
copilot secret init --name ADMIN_PASSWORD --app odoo-app

# Set database password
copilot secret init --name DB_PASSWORD
```

1. Deploy the services:
```bash
# Deploy database first
copilot svc deploy --name odoo-db

# Deploy Odoo
copilot svc deploy --name odoo
```

## Environment Management

To create a new environment (e.g., staging):
```bash
copilot env init --name staging --app odoo-app --profile default
```

To deploy to a specific environment:
```bash
copilot svc deploy --name odoo --env staging
```

## Monitoring

Copilot provides built-in monitoring through:
- CloudWatch Logs
- CloudWatch Metrics
- Service logs via `copilot svc logs`

## Scaling

Adjust service scaling:
```bash
copilot svc scale --name odoo --count 3
```

## Cleanup

To delete the entire application:
```bash
copilot app delete
```

## Security Considerations

- All sensitive credentials are stored in AWS Secrets Manager
- Network access is restricted through VPC configuration
- EFS volumes are secured with IAM authentication
- Regular security updates should be applied to the container images

## License

This library is licensed under the AGPLv3 License. See the LICENSE file.
