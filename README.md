# action-app-deploy
Composite action to deploy applications to an XP instance.

# What's new

- Easier setup for customers
  - Set the required arguments in your repository
  - Refer to this composite action script in a workflow


# Usage

In your workflow specify the required arguments to be used as an input to this deploy action and use the actinon to execute the deployment task. 
See [action.yml](action.yml)

## Mandatory arguments
- url
- username
- password

## Optional arguments
- app_jar: name path to the app to be deployed. If it's not given, the action will look for an app under "./build/libs/"
- client_cert: required only if you need to authenticate using mTLS
- client_key: required only if  you need to authenticate using mTLS

Note: The url, username and app_jar parameters can be given as string or secret inputs. But password, client_cert and client_key has to be stored in a secret store. 

Here is an example workflow
```yaml
jobs:
  app_deploy_job:
    runs-on: ubuntu-latest
    name: A job to deploy app
    steps: 
      - uses: actions/checkout@v3
      - id: deploy_app_to_XP
        uses: enonic/action-app-deploy@<tag>
        with:
          url: 'https://<org-proj>.enonic.cloud:4443'
          username: 'deploy-user'
          password: ${{ secrets.XP_PASS }}
 ```



