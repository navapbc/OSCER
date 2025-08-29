# Set up income verification as a service

The reporting app leverages the Centers for Medicare and Medicaid Services (CMS) Income Verification as a Service (IVaaS) API to verify income and eligible activity information for meeting Medicaid community engagement requirements. This guide provides an overview of the steps needed to integrate with the IVaaS API.

## Obtain IVaaS API keys

Contact your CMS representative to obtain API keys. You'll want two API keys, one for [IVaaS sandbox demo environment](https://sandbox-verify-demo.navapbc.cloud/cbv/entry) and one for the IVaaS production environment. You'll also be given a unique client agency identifier representing your organization.

## Store your API keys as SSM secrets

```bash
aws ssm put-parameter --name "/reporting-app-dev/service/ivaas-api-key" --value "<your-sandbox-demo-api-key>" --type "SecureString" --description "Income verification as a service API key for sandbox demo environment"
```

```bash
aws ssm put-parameter --name "/reporting-app-staging/service/ivaas-api-key" --value "<your-sandbox-demo-api-key>" --type "SecureString" --description "Income verification as a service API key for sandbox demo environment"
```

```bash
aws ssm put-parameter --name "/reporting-app-prod/service/ivaas-api-key" --value "<your-production-api-key>" --type "SecureString" --description "Income verification as a service API key for production environment"
```

## Update the client agency ID for your instance of the reporting app

Update the `IVAAS_CLIENT_AGENCY_ID` variable in [environment_variables.tf](/infra/reporting-app/app-config/env-config/environment_variables.tf) with the value provided to you by the IVaaS team.

## Apply the changes to your environments

For the dev environment, run:

```bash
make infra-update-app-service APP_NAME=reporting-app ENVIRONMENT=dev
```

Repeat for other environments.
