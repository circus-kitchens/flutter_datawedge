import 'package:flutter_datawedge/flutter_datawedge.dart';
import 'package:flutter_datawedge/models/flutter_datawedge_exception.dart';
import 'package:flutter_datawedge/models/scan_result.dart' as wedge;
import 'package:flutter_test/flutter_test.dart';

void main() {

  late FlutterDataWedge sut;

  setUp(() {
    sut=FlutterDataWedge(profileName: "TestProfile");
  });

  test('Test enableScanner requires initialization', () async {
    final result=await sut.enableScanner(true);
    expect(result.isFailure,true);
    expect(result.maybeError is NotInitializedException,true);
  });

  test('Test activateScanner requires initialization', () async {
    final result=await sut.activateScanner(true);
    expect(result.isFailure,true);
    expect(result.maybeError is NotInitializedException,true);
  });

  test('Test scannerControl requires initialization', () async {
    final result=await sut.scannerControl(true);
    expect(result.isFailure,true);
    expect(result.maybeError is NotInitializedException,true);
  });
}
