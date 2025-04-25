# action-app-deploy
Composite action to deploy applications to an XP instance.

# Usage

In your workflow specify the required arguments to be used as an input to this deploy action and use the action to execute the deployment task. 
See [action.yml](action.yml)

## Mandatory arguments
- url

## Optional arguments
- app_jar: name path to the app to be deployed. If it's not given, the action will look for an app under "./build/libs/"
- client_cert: client certificate for mTLS authentication
- client_key: client key for mTLS authentication
- cred_file: Enonic XP Service Account Key file content 

Note: The url and app_jar parameters can be given as string or secret inputs. But cred_file, client_cert and client_key must be stored in secrets. 

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
          client_key: ${{ secrets.CLIENT_KEY }}
          client_cert: ${{ secrets.CLIENT_CERT }}
          cred_file: ${{ secrets.CRED_FILE }}
 ```



