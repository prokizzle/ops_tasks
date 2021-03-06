# Ops Tasks

Provides your project with rake tasks for deploying to AWS via Opsworks

- Alerts Slack channel that deployment is starting
- Initiates a deployment on Opsworks
- Monitors deployment until completion
- Alerts Slack channel of result status for deployment

## Setup

#### Add gem & source

    # Gemfile
    gem 'ops_tasks', '~> 0.4'

#### or install

    gem install 'ops_tasks'

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
| production_layer_id | opsworks layer id for production servers |
| production_stack_id | opsworks stack id for production server |
| production_deploy_recipe | deployment recipe for production server (cookbook-name::recipe-name) |
| production_project_name | Project description used in hipchat alert ("App Name Production") |
| production_room_notifications | true or false; enable or disable slack alerts |
| production_slack_channel | Slack channel to alert of deployment |
| SLACK_API_TOKEN | API token for your slack team |
| SLACK_BOT_IMG | url for the icon that appears with the alert in slack. defaults to Bender. |

To add additional layers, just copy the above format, and change `production` to whatever you'd like to name it. The deploy task will automatically detect your configurations based on the environment variables you set.

```
your_server_name_layer_id
your_server_name_stack_id
your_server_name_deploy_recipe
your_server_name_project_name
your_server_name_slack_channel
your_server_name_room_notifications
```

You can use [figaro](https://github.com/laserlemon/figaro) or [dotenv](https://github.com/bkeepers/dotenv). I prefer figaro.

#### Ruby Setup (without rails)

1. If using figaro, add your `application.yml` file to the `./config/` directory (create one).
1. If using dotenv, use a `.env` file in the root of your project.
1. To generate a dotenv file, run the command

    `ops_tasks init`

1. To add a deploy environment, run the command

    `ops_tasks add <environment name>`

## Usage (With Rails)

If you only have one deployment environment in your env file, ops_tasks will run that one automatically. If more than one exists, ops_tasks will prompt you via a graphical menu.

### Update Cookbooks

    bundle exec rake ops_tasks:update_cookbooks

### Deploy to AWS

    bundle exec rake ops_tasks:deploy

    Select a server...
    1. staging
    2. production
    3. realtime
    4. sidekiq
    5. quit
    ?  4
    Sidekiq Server: Preparing deployment... successful
    Sidekiq Server: Running... successful

### Run Configuration Recipes

    bundle exec rake ops_tasks:configure

### Run Setup Recipes

    bundle exec rake ops_tasks:setup

## Usage (Without Rails)

Run any of these tasks from your project directory

    # Run the deploy recipe noted in your env
    ops_tasks deploy

    # Run the setup recipe(s) as listed in your OpsWorks Layer
    ops_tasks setup

    # Update your cookbooks on OpsWorks
    ops_tasks update_cookbooks

    # Run the configure recipe(s) as listed in your OpsWorks Layer
    ops_tasks configure


