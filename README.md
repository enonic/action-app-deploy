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
- deploy user name
- deploy user password
- path to the app to be deployed
- name of the app

Optional arguments (If you deploy over MTLS)
- client certificate 
- client key

The url, username, path and name of the app are given as string inputs. 
But the password, client certificate and client key has to be stored in the repository's secret store. 
Note: As the client key and certificate are files with multiple lines, the action script can process them only if you put the base64 encoded values of the content of the client key and certificate. 

e.g. To add client key into github secret first run the command :
```
cat client.key | base64
 ```
Then copy the output of the command and put it under the secret store in your github repository.


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
          client_key: ${{ secrets.ENONIC_MTLS_CLIENT_KEY }}
          client_cert: ${{ secrets.ENONIC_MTLS_CLIENT_CERT }}
          app_src_path: './build/libs/'
          appname: "chucknorris-2.1.0.jar"
 ```

### Deploy an app over MTLS

```yaml
 - name: Deployment over MTLS
      if: | 
         contains(steps.check_cert_exist.outputs.CLIENT_CERT_EXIST, 'True') &&
         contains(steps.check_key_exist.outputs.CLIENT_KEY_EXIST, 'True')
      run: |
         curl --key ./client.key --cert ./client.cert -X POST -f -s -S -o - -u ${{ inputs.username }}:${{ inputs.password }} -F file=@$(find ${{ inputs.app_src_path }} -name '${{ inputs.appname }}') ${{ inputs.url }}/app/install | xargs echo
      shell: bash
```
### Deploy an app without MTLS

```yaml
    - name: Deployment without MTLS
      if: | 
         !contains(steps.check_cert_exist.outputs.CLIENT_CERT_EXIST, 'True') 
         || !contains(steps.check_key_exist.outputs.CLIENT_KEY_EXIST, 'True')
      run: |
         curl -X POST -f -s -S -o - -u ${{ inputs.username }}:${{ inputs.password }} -F file=@$(find ${{ inputs.app_src_path }} -name '${{ inputs.appname }}') ${{ inputs.url }}/app/install | xargs echo
      shell: bash
```
