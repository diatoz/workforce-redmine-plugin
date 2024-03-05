### Installation

1. Clone the Redmine Workforce Plugin into Redmine plugins directory

```sh
git clone https://github.com/diatoz/workforce-redmine-plugin.git plugins/workforce
```

2. Run the plugin migrations

```sh
bundle exec rake redmine:plugins:migrate
```

3. Restart the Redmine Instance
