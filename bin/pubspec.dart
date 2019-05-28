import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:pub_client/pub_client.dart';
import 'package:pubspec_parse/pubspec_parse.dart' as pbs;
import 'package:pub_semver/pub_semver.dart' as sem;

const showChangeLogsUrls = 'showChangeLogsUrls';
const showAllChangeLogsUrls = 'showAllChangeLogsUrls';

main(List<String> arguments) async {
  exitCode = 0;

  var parser = new ArgParser()
    ..addFlag(showChangeLogsUrls, negatable: false, abbr: 'c')
    ..addFlag(showAllChangeLogsUrls, negatable: false, abbr: 'a');
  var parseResults = parser.parse(arguments);

  PubClient client = new PubClient();

  if (parseResults.rest.isEmpty) {
    print(
        "You need to provide a filename as argument (dart SpecCheck.dart file.yaml)");
    exit(-1);
  }

  bool showChangeLogs = parseResults[showChangeLogsUrls];
  bool showAllChangeLogs = parseResults[showAllChangeLogsUrls];

  print("\n------------------------------------");
  print("Processing this file: " + parseResults.rest[0]);
  print("------------------------------------\n");

  var myFile = new File(parseResults.rest[0]);

  String theString = await myFile.readAsString();

  var doc = pbs.Pubspec.parse(theString);

  await printAvailableUpdates(
    doc.dependencies,
    client,
    showChangeLogs,
    showAllChangeLogs,
  );
  print("\n------------------------------------");
  print("Dev dependencies");
  print("------------------------------------");
  await printAvailableUpdates(
    doc.devDependencies,
    client,
    showChangeLogs,
    showAllChangeLogs,
  );
  print("\n------------------------------------");
  print("Done processing yaml file");
  print("------------------------------------");
  exit(0);
}

Future printAvailableUpdates(
  Map<String, pbs.Dependency> dependencies,
  PubClient client,
  bool showChangeLogs,
  bool showAllChangeLogs,
) async {
  for (var package in dependencies.keys) {
    var version = dependencies[package];

    if (package is String) {
      try {
        FullPackage onlinePackage = await client.getPackage(package);

        sem.VersionRange currentConstraint =
            sem.VersionConstraint.parse(version.toString().split(" ")[1]);
        var newestVersion = sem.Version.parse(onlinePackage.latest.version);

        if (!currentConstraint.allows(newestVersion)) {
          print("\n--------- MAJOR DIFFERENCE ---------");
          print("Changelog: " +
              "https://pub.dartlang.org/packages/" +
              package +
              "#-changelog-tab-");
        } else if (showChangeLogs || showAllChangeLogs) {
          if (!showAllChangeLogs &&
              currentConstraint.min.toString() ==
                  onlinePackage.latest.version.toString()) {
            print("------------------------------------");
            print("No new version, no changelog needed");
          } else {
            print("------------------------------------");
            print("Changelog: " +
                "https://pub.dartlang.org/packages/" +
                package +
                "#-changelog-tab-");
          }
        }
        print(version.toString() +
            " => " +
            onlinePackage.latest.version +
            " \t " +
            package);
        if (!currentConstraint.allows(newestVersion)) {
          print("------------------------------------");
        }
      } catch (e) {}
    }
  }
}
