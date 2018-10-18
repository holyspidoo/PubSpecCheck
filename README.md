# PubSpecCheck

Utility to check the versions of packages in a pubspec.yaml file. Useful to see if there is a shift in major versions _(ex: 0.7.0 to 0.8.0)_ so you can update your version rules inside the pubspec file.

## Usage

```
dart SpecCheck.dart yourfile.yaml
```

## Example

If you run the script on its own pubspec.yaml
```
> dart SpecCheck.dart pubspec.yaml
```

You will get

```
[pubspec.yaml]
HostedDependency: ^2.1.15 => 2.1.15 	 yaml
HostedDependency: ^0.1.2+2 => 0.1.2+2 	 pubspec_parse
HostedDependency: ^3.0.0 => 3.0.2 	 pub_client
HostedDependency: ^1.5.0 => 1.5.0 	 args
```


If a major change is detected, it will give you the link to the changelog to see if there are any breaking changes. Here is an example:

```
--------- MAJOR DIFFERENCE ---------
Changelog: https://pub.dartlang.org/packages/flutter_inapp_purchase#-changelog-tab-
HostedDependency: 0.7.0 => 0.8.0         flutter_inapp_purchase
------------------------------------
HostedDependency: ^0.5.18 => 0.5.20      firebase_auth
```


Please note that if you don't use ^ in your yaml file, you will get a notification of a major difference as well.

```
--------- MAJOR DIFFERENCE ---------
Changelog: https://pub.dartlang.org/packages/flutter_inapp_purchase#-changelog-tab-
HostedDependency: 0.8.0 => 0.8.2         flutter_inapp_purchase
------------------------------------
```

## Show all changelogs

With the -c flag, all changelogs urls will be shown for packages where the versions are different from those found in the pubspec.yaml file.

For example, when running this:
```
> dart SpecCheck.dart pubspec.yaml
```

You might get something like:
```
------------------------------------
Changelog: https://pub.dartlang.org/packages/timeago#-changelog-tab-
HostedDependency: ^2.0.1 => 2.0.8        timeago

--------- MAJOR DIFFERENCE ---------
Changelog: https://pub.dartlang.org/packages/flutter_inapp_purchase#-changelog-tab-
HostedDependency: 0.8.0 => 0.8.2         flutter_inapp_purchase
------------------------------------
------------------------------------
No new version, no changelog needed
HostedDependency: ^0.3.2 => 0.3.2        package_info
------------------------------------
```


## Notes

No error handling of any kind, this is just a quick and dirty script 🙂