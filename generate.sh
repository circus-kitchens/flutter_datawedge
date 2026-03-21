#!/bin/bash
set -e

dart run pigeon \
  --input pigeons/datawedge_pigeon.dart \
  --dart_out lib/src/pigeon.dart \
  --kotlin_out android/src/main/kotlin/com/circuskitchens/flutter_datawedge/pigeon/Pigeon.kt \
  --kotlin_package "com.circuskitchens.flutter_datawedge.pigeon"
