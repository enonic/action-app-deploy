# app-deploy-action
Composite action to deploy applications to an XP instance.

# What's new

- Easier setup from customers' side
  - Set the required arguments in your repository
  - Refer to this composite action script in a workflow


# Usage

See [action.yml](action.yml)
Specify the required arguments in a workflow. That will be used as an input to the deploy action. 
Mandatory arguments
- url
- username
- password

Optional arguments
- app_jar: path to the app to be deployed. If not given, the action will deploy all apps under "./build/libs/"
- client_cert 
- client_key

Note: If you need to authenticate using mTLS, use the client_key and client_cert.

The url, username and app_jar parameters can be given as string inputs. But password, client_cert and client_key has to be stored in the repository's secret store. 

Here is an example workflow
```yaml
jobs:
  app_deploy_job:
    runs-on: ubuntu-latest
    name: A job to deploy app
    steps: 
      - uses: actions/checkout@v2
      - id: deploy_app_to_XP
        uses: enonic-cloud/app-deploy-action@v1.0
        with:
          url: 'https://<org-proj>.enonic.cloud:4443'
          username: 'deploy-user'
          password: ${{ secrets.ENONIC_APP_DEPLOY_PASS }}
 ```



