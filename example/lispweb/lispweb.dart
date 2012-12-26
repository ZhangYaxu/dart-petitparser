// Copyright (c) 2012, Lukas Renggli <renggli@gmail.com>

library lispweb;

import 'dart:html';
import 'package:petitparser/lisp.dart';
import 'package:petitparser/petitparser.dart';

void inspector(Element element, Environment environment) {
  var result = '';
  while (environment != null) {
    result = '$result<ul>';
    for (var symbol in environment.keys) {
      result = '$result<li><b>$symbol</b>: ${environment[symbol]}</li>';
    }
    result = '$result</ul>';
    result = '$result<hr/>';
    environment = environment.owner;
  }
  element.innerHTML = result;
}

void main() {
  var parser = new LispParser();

  var root = new Environment();
  var native = Natives.importNatives(root);
  var standard = Natives.importStandard(native.create());
  var environment = standard.create();

  var input = query('#input');
  var output = query('#output');

  query('#evaluate').on.click.add((event) {
    var result = evalString(parser, environment, input.value);
    output.innerHTML = result.toString();
    inspector(query('#inspector'), environment);
  });
  inspector(query('#inspector'), environment);
}