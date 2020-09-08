library flutter_automation;

import 'dart:io';

import 'package:args/args.dart';
import 'package:flutter_automation/commons.dart';
import 'package:flutter_automation/directory_helper/helper.dart';
import './firebase_auth.dart' as firebase_auth;
import './google_maps.dart' as google_maps;
import './android_signing.dart' as android_sign;
import './firestore_crud.dart' as firestore_crud;

/// deciphers which scripts to run based on the arguments provided by the user
void decipherScript(List<String> arguments) {
  var parser = ArgParser(allowTrailingOptions: true);
  parser.addFlag('help', abbr: 'h', negatable: false, help: "Usage help");
  parser.addFlag('firebase-auth',
      abbr: 'f', help: "Adds firebase authentication", negatable: false);
  parser.addFlag('firestore-crud',
      abbr: 'c', help: "Adds firestore CRUD boilerplate", negatable: false);
  parser.addFlag('google-maps',
      abbr: 'g', help: "Adds google maps", negatable: false);

  parser.addFlag("android-sign",
      abbr: 's', help: "Setups android signing config", negatable: false);

  var genParser = ArgParser(allowTrailingOptions: true);
  parser.addCommand("gen", genParser);
  genParser.addOption("path",
      abbr: "p",
      help: "Base path, defaults to $basePath",
      defaultsTo: basePath);
  genParser.addFlag("core",
      abbr: "c", help: "Generates core directory instead of feature directory");

  var argResults = parser.parse(arguments);
  if (argResults.command?.name == "gen") {
    final genArgResults = genParser.parse(argResults.command.arguments);
    if (genArgResults["core"]) {
      genCore(path: genArgResults["path"]);
    } else {
      genFeatureDirectory(
          path: genArgResults["path"],
          feature: argResults.command.arguments.first);
    }
    return;
  }
  if (argResults['help'] || argResults.arguments.length < 1) {
    stdout.write('Automation scripts for flutter');
    stdout.write(parser.usage);
    return;
  }

  if (argResults['firebase-auth']) {
    firebase_auth.firebaseAuth();
  }

  if (argResults['google-maps']) {
    google_maps.googleMaps();
  }

  if (argResults['android-sign']) {
    android_sign.androidSign();
  }

  if (argResults['firestore-crud']) {
    firestore_crud.firestoreCrud();
  }
}
