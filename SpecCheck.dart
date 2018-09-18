import 'dart:io';

import 'package:args/args.dart';
import 'package:pub_client/pub_client.dart';
import 'package:pubspec_parse/pubspec_parse.dart' as pbs;

main(List<String> arguments) async {
  exitCode = 0;
   var parser = new ArgParser();
  var parseResults = parser.parse(arguments);

  print(parseResults.rest);

  PubClient client = new PubClient();

  var myFile = new File(parseResults.rest[0]);

  myFile.readAsString().then((thestring) async {
    var doc = pbs.Pubspec.parse(thestring);

    doc.dependencies.forEach((package, version) {
      
      if (package is String) {
        client.getPackage(package).then((onlinePackage) {
          print(
              version.toString() +
              " => " +
              onlinePackage.latest.version +
              " \t "+package);
        }).catchError((error) {
          //print(error);
        });
      }
    });
    
  });
   
}
