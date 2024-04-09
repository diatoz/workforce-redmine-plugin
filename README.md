## To install

1. Clone the Redmine Workforce Plugin into Redmine plugins directory

```sh
git clone https://github.com/diatoz/workforce-redmine-plugin.git plugins/workforce
```

2. Run the plugin migrations

```sh
bundle exec rake redmine:plugins:migrate
```

3. Restart the Redmine Instance

4. Login to the Redmine as an administrator. From navbar perform these navigation steps, Administration > Settings > API. Enable Rest API service and save it.

5. Create a user (workforce user) with required privileges to access Redmine from Workforce.

6. From navbar perform these navigation steps, Administration > plugins. In the plugins page, click configure in workforce plugin.

7. For Workforce Domain, enter the domain for the Workforce. For Workforce email, enter the created workforce user email id and save it.

8. Go the settings page of the project for which Workforce has to be notified. Click the Workforce tab, set the API key and save it.

9. Login as workforce user. Navigate to My account page from navbar and create an API key for the user. Share the created key to Workforce.

## To Uninstall

1. Rollback the migrations of Workforce plugin
```sh
bundle exec rake redmine:plugins:migrate NAME=workforce VERSION=0
```
2. Remove Workforce directory from the Redmine plugins directory.

3. Restart the Redmine instance.
