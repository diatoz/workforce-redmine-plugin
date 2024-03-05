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

## To Uninstall

1. Rollback migrations of Workforce plugin
```sh
bundle exec rake redmine:plugins:migrate NAME=workforce VERSION=0
```
2. Remove Workforce directory from the Redmine plugins directory

3. Restart the Redmine instance
