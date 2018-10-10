import 'dart:io';

import 'package:args/args.dart';
import 'package:pub_client/pub_client.dart';
import 'package:pubspec_parse/pubspec_parse.dart' as pbs;
import 'package:pub_semver/pub_semver.dart' as sem;

main(List<String> arguments) async {
  exitCode = 0;

  var parser = new ArgParser();
  var parseResults = parser.parse(arguments);

  PubClient client = new PubClient();

  if (parseResults.rest.isEmpty) {
    print(
        "You need to provide a filename as argument (dart SpecCheck.dart file.yaml)");
    exit(-1);
  }

  print("Processing this file: " + parseResults.rest[0]);

  var myFile = new File(parseResults.rest[0]);

  myFile.readAsString().then((thestring) async {
    var doc = pbs.Pubspec.parse(thestring);

    doc.dependencies.forEach((package, version) {
      if (package is String) {
        client.getPackage(package).then((onlinePackage) {
          var currentConstraint =
              sem.VersionConstraint.parse(version.toString().split(" ")[1]);
          var newestVersion = sem.Version.parse(onlinePackage.latest.version);

          if (!currentConstraint.allows(newestVersion)) {
            print("\n--------- MAJOR DIFFERENCE ---------");
            print("Changelog: " +
                "https://pub.dartlang.org/packages/"+package+"#-changelog-tab-");
          }
          print(version.toString() +
              " => " +
              onlinePackage.latest.version +
              " \t " +
              package);
          if (!currentConstraint.allows(newestVersion)) {
            print("------------------------------------");
          }
        }).catchError((error) {
          //print(error);
        });
      }
    });
  });
}
