## 1.1.5
  * Added support to reflect issues in Workforce that are created via email.

## 1.1.4
  * Generalized the Builder Classes APIs.
  * Set locale to 'en' while generating the issue payload.
  * Exposed a new API to fetch issue data.

## 1.1.3

* Added support for custom fields of type boolean and list.
* For new projects, all supported custom fields will be enabled by default.

## 1.1.2

* Added patch and delete support for notes from workforce.
* Added custom api for notes creation.
* Included the project name in the project path within the issue payload.

## 1.1.1

* Moved project level api key configuration to the global configuration.
* Added workforce endpoint configuration to the global configuration.
* For new projects, Workforce notifications will be enabled by default with all supported notifiable issue fields.
* Added log rotation for workforce logs.
* Added a Rake task to migrate all projects to the default Workforce settings.

## 1.1.0

* Added authorization for accessing workforce settings tab under project.
* Added group Id field in workforce settings tab to decide which workforce helpdesk group that issue should fall into
  for that particular project.
* Added attachment support for issues.
* Custom fields of issues are supported now. Provided UI in workforce settings tab to customize which fields has to be
  reflected in workforce

## 1.0.3

* Added enable or disable workforce notifications on project level.
* In plugin settings, now users can set workforce domain name instead of setting whole url.
* Issue notes will be now reflected as workforce ticket comments.
* Added patch support for issues.

## 1.0.2

* Fixed user check while sending notification to workforce.

## 1.0.1

* Added CHANGELOG file
* Fixed Plugin Version

## 1.0.0

* Initial release.
