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


## Notes

No error handling of any kind, this is just a quick and dirty script 🙂