library konversation_web;

import 'dart:async';
import 'dart:io';
import 'package:angel_common/angel_common.dart';
import 'package:angel_mustache/angel_mustache.dart';

/// Generates and configures an Angel server.
Future<Angel> createServer() async {
  var app = new Angel();

  // Loads app configuration from 'config/'.
  // It supports loading from YAML files, and also supports loading a `.env` file.
  //
  // https://github.com/angel-dart/configuration
  await app.configure(loadConfigurationFile());

  // All loaded configuration will be added to `app.properties`.
  print('Loaded configuration: ${app.properties}');

  await app.configure(mustache(new Directory('lib/views')));

  app.get('/', requestHandler);

  // Enable GZIP and DEFLATE compression (conserves bandwidth)
  // https://github.com/angel-dart/compress
  app.responseFinalizers.addAll([gzip(), deflate()]);

  // Logs requests and errors to both console, and a file named `log.txt`.
  // https://github.com/angel-dart/diagnostics
  await app.configure(logRequests(new File('log.txt')));

  return app;
}

requestHandler(ResponseContext res) async {
  var builddir = new Directory(res.app.properties['builddir']);
  
  return res.render('index', {});
}
