flutter pub run pigeon \
  --input pigeons/datawedge_pigeon.dart \
  --dart_out lib/src/pigeon.dart \
  --experimental_kotlin_out android/src/main/kotlin/com/circuskitchens/flutter_datawedge/pigeon/Pigeon.kt \
  --experimental_kotlin_package "com.circuskitchens.flutter_datawedge.pigeon" \
  --java_package "com.circuskitchens.flutter_datawedge" 