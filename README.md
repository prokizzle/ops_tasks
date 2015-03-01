# Datafiniti Ops Tasks

Provides your rails project with rake tasks for deploying to AWS via Opsworks

- Alerts hipchat room that deployment is starting
- Initiates a deployment on Opsworks
- Monitors deployment until completion
- Alerts hipchat room of result status for deployment

## Setup

#### Add gem & source

    # Gemfile
    gem 'ops_tasks'

#### Find your AWS IAM Credentials

If my AWS IAM user name was `Nick`

`https://console.aws.amazon.com/iam/home?region=us-east-1#users/Nick`

Then click 'Manage Access Keys' and create a new Access Key. The secret key will only be shown once. After that, you'll have to create a new one if you lose it.

#### Find your stack and instance IDs

These are listed on the settings or details page for stacks and instances, and they're called _Opsworks ID_.


#### Setup your environment variables as follows:

| variable name | description |
| --------------|-------------- |
| AWS_ACCESS_KEY_ID    | your AWS access key id / API key |
| AWS_SECRET_ACCESS_KEY | your AWS secret key / API secret |
| AWS_REGION            | region of AWS instance (should always be us-east-1) |
| staging_instance_id | opsworks instance id for qa/staging server |
| staging_stack_id | opsworks stack id for qa/staging server |
| staging_deploy_recipe | deployment recipe for qa/staging server (cookbook-name::recipe-name) |
| staging_project_name | Project description used in hipchat alert ("App Name QA") |
| staging_hipchat_room | hipchat room to alert of deployment |
| production_instance_id | opsworks instance id for production server |
| production_stack_id | opsworks stack id for production server |
| production_deploy_recipe | deployment recipe for production server (cookbook-name::recipe-name) |
| production_project_name | Project description used in hipchat alert ("App Name Production") |
| production_hipchat_room | hipchat room to alert of deployment |
| HIPCHAT_API_TOKEN | API token for hipchat |

You can use figaro or dotenv. I prefer figaro.

## Usage

### Update Cookbooks

    rake staging:update_cookbooks
    rake production:update_cookbooks

### Deploy to AWS

    rake staging:deploy
    rake production:deploy