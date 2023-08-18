// Autogenerated from Pigeon (v10.1.6), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import, unnecessary_parenthesis, prefer_null_aware_operators, omit_local_variable_types, unused_shown_name, unnecessary_import

import 'dart:async';
import 'dart:typed_data' show Float64List, Int32List, Int64List, Uint8List;

import 'package:flutter/foundation.dart' show ReadBuffer, WriteBuffer;
import 'package:flutter/services.dart';

/// Result types when creating a profile
enum CreateProfileResponseType {
  profileAlreadyExists,
  profileNameEmpty,
  profileCreated,
}

/// Mode for profile creations
enum ConfigMode {
  createIfNotExists,
  overwrite,
  update,
}

/// Plugin to be configured
enum PluginName {
  barcode,
  msr,
  rfid,
  serial,
  voice,
  workflow,
  bdf,
  adf,
  tokens,
  intent,
  keystroke,
  ip,
  dcp,
  ekb,
}

enum ScannerIdentifer {
  auto,
  internalImager,
  internalLaser,
  internalCamera,
  serialSSI,
  bluetoothSSI,
  bluetoothRS6000,
  bluetoothDS2278,
  bluetoothDS3678,
  plugableSsi,
  plugableSsiRS5000,
  usbSsiDS3608,
  bluetoothZebra,
  usbZebra,
}

enum UpcSupplementalMode {
  none,
  always,
  auto,
  smart,
  supplemental378to379,
  supplemental978to979,
  supplemental414to419and434to439,
  supplemental977,
}

enum UpcEanCouponReport {
  oldMode,
  newMode,
  both,
}

enum UpcEanBooklandFormat {
  isbn10,
  isbn13,
}

enum ScanningMode {
  single,
  udi,
  multiBarcode,
  documentCapture,
}

enum InverseOcr {
  regular,
  inverse,
  auto,
}

enum OcrOrientation {
  degree_0,
  degree_90,
  degree_180,
  degree_270,
  omnidirectional,
}

enum IntentDelivery {
  startActivity,
  startService,
  broadcast,
}

enum DpmMode {
  disabled,
  mode1,
  mode2,
}

enum BeamWidth {
  narrow,
  normal,
  wide,
}

enum PowerMode {
  low,
  high,
  alwaysOn,
  optimized,
}

enum MpdMode {
  display_off,
  display_on,
}

enum PicklistMode {
  disabled,
  hardware,
  software,
}

enum ReaderMode {
  triggered,
  presentation,
}

enum TriggerSource {
  left,
  right,
  center,
  gun,
  proximity,
  keyMapperScan,
  keyMapperL1,
  keyMapperR1,
  wiredLeft,
  wiredRight,
}

enum DpmIlluminationControl {
  direct,
  indirect,
  cycle,
}

enum VolumeSliderType {
  ringer,
  musicMedia,
  alarms,
  notification,
}

enum CodeIdType {
  none,
  aim,
  symbol,
}

enum ViewFinderMode {
  enabled,
  staticReticle,
}

enum Charset {
  auto,
  utf8,
  iso88591,
  shiftJis,
  gb18030,
  none,
}

enum EffortLevel {
  level_0,
  level_1,
  level_2,
  level_3,
}

enum Inverse1dMode {
  disable,
  enable,
  auto,
}

enum DelayToLowPowerMode {
  seconds_1,
  seconds_30,
  minutes_1,
  minutes_5,
}

enum LcdMode {
  disabled,
  enabled,
}

enum IlluminationMode {
  off,
  torch,
}

enum SceneDetectQualifier {
  none,
  proximitySensor,
}

enum AimType {
  trigger,
  timedHold,
  timedRelease,
  pressAndRelease,
  presentation,
  continousRead,
  pressAndSustain,
  pressAndContinue,
  timedContinous,
}

enum SwitchOnEvent {
  disabled,
  onConnect,
  onDisconnect,
  connectOrDisconnect,
}

enum PresentationModeSensitivity {
  high,
  medium,
  low,
}

enum LabelType {
  code39,
  codabar,
  code128,
  d2of5,
  iata2of5,
  i2of5,
  code93,
  upca,
  upce0,
  upce1,
  ean8,
  ean13,
  msi,
  ean128,
  trioptic39,
  bookland,
  coupon,
  databarCoupon,
  isbt128,
  code32,
  pdf417,
  micropdf,
  tlc39,
  code11,
  maxicode,
  datamatrix,
  qrcode,
  gs1Databar,
  gs1DatabarLim,
  gs1DatabarExp,
  uspostnet,
  usplanet,
  ukpostal,
  jappostal,
  auspostal,
  dutchpostal,
  finnishpostal4s,
  canpostal,
  chinese2of5,
  aztec,
  microqr,
  us4state,
  us4stateFics,
  compositeAb,
  compositeC,
  webcode,
  signature,
  korean3of5,
  matrix2of5,
  ocr,
  hanxin,
  mailmark,
  format,
  gs1Datamatrix,
  gs1Qrcode,
  dotcode,
  gridmatrix,
  undefined,
}

enum ScanSource {
  msr,
  scanner,
  simulscan,
  serial,
  voice,
  rfid,
}

enum DecodeMode {
  multiple,
  single,
}

enum ScannerState {
  waiting,
  scanning,
  idle,
  connected,
  disconnected,
  disabled,
}

/// Result when creating a profile
class CreateProfileResponse {
  CreateProfileResponse({
    required this.responseType,
  });

  CreateProfileResponseType responseType;

  Object encode() {
    return <Object?>[
      responseType.index,
    ];
  }

  static CreateProfileResponse decode(Object result) {
    result as List<Object?>;
    return CreateProfileResponse(
      responseType: CreateProfileResponseType.values[result[0]! as int],
    );
  }
}

/// An application that will trigger the profile
class AppEntry {
  AppEntry({
    required this.packageName,
    required this.activityList,
  });

  String packageName;

  List<String?> activityList;

  Object encode() {
    return <Object?>[
      packageName,
      activityList,
    ];
  }

  static AppEntry decode(Object result) {
    result as List<Object?>;
    return AppEntry(
      packageName: result[0]! as String,
      activityList: (result[1] as List<Object?>?)!.cast<String?>(),
    );
  }
}

class PluginIntentParamters {
  PluginIntentParamters({
    this.intentOutputEnabled,
    this.intentAction,
    this.intentCategory,
    this.intentDelivery,
    this.intentUseContentProvider,
  });

  bool? intentOutputEnabled;

  String? intentAction;

  String? intentCategory;

  IntentDelivery? intentDelivery;

  bool? intentUseContentProvider;

  Object encode() {
    return <Object?>[
      intentOutputEnabled,
      intentAction,
      intentCategory,
      intentDelivery?.index,
      intentUseContentProvider,
    ];
  }

  static PluginIntentParamters decode(Object result) {
    result as List<Object?>;
    return PluginIntentParamters(
      intentOutputEnabled: result[0] as bool?,
      intentAction: result[1] as String?,
      intentCategory: result[2] as String?,
      intentDelivery: result[3] != null
          ? IntentDelivery.values[result[3]! as int]
          : null,
      intentUseContentProvider: result[4] as bool?,
    );
  }
}

class PluginBarcodeParamters {
  PluginBarcodeParamters({
    this.dataBarToUpcEan,
    this.upcEnableMarginlessDecode,
    this.upcEanSecurityLevel,
    this.upcEanSupplemental2,
    this.upcEanSupplemental5,
    this.upcEanSupplementalMode,
    this.upcEanRetryCount,
    this.upcEeanLinearDecode,
    this.upcEanBookland,
    this.upcEanCoupon,
    this.upcEanCouponReport,
    this.upcEanZeroExtend,
    this.upceanBooklandFormat,
    this.scanningMode,
    this.docCaptureTemplate,
    this.commonBarcodeDynamicQuantity,
    this.barcodeHighlightingEnabled,
    this.ruleName,
    this.enableUdiGs1,
    this.enableUdiHibcc,
    this.enableUdiIccbba,
    this.ocrOrientation,
    this.ocrLines,
    this.ocrMinChars,
    this.ocrMaxChars,
    this.ocrSubset,
    this.ocrQuietZone,
    this.ocrTemplate,
    this.ocrCheckDigitModulus,
    this.ocrCheckDigitMultiplier,
    this.ocrCheckDigitValidation,
    this.inverseOcr,
    this.presentationModeSensitivity,
    this.enableHardwareTrigger,
    this.autoSwitchToDefaultOnEvent,
    this.digimarcDecoding,
    this.multiBarcodeCount,
    this.enableInstantReporting,
    this.reportDecodedBarcodes,
    this.scannerTriggerResource,
    this.scannerInputEnabled,
    this.scannerSelection,
    this.configureAllScanners,
    this.scannerSelectionByIdentifier,
    this.enableAimMode,
    this.beamTimer,
    this.enableAdaptiveScanning,
    this.beamWidth,
    this.powerMode,
    this.mpdMode,
    this.readerMode,
    this.linearSecurityLevel,
    this.picklist,
    this.aimType,
    this.sceneDetectQualifier,
    this.aimTimer,
    this.sameBarcodeTimeout,
    this.triggerWakeupScan,
    this.differentBarcodeTimeout,
    this.illuminationMode,
    this.illuminationBrightness,
    this.lcdMode,
    this.lowPowerTimeout,
    this.delayToLowPowerMode,
    this.inverse1dMode,
    this.viewFinderSize,
    this.viewFinderPosX,
    this.viewFinderPosY,
    this.marginlessEffortLevel1d,
    this.poorQualityBcDecodeEffortLevel,
    this.charsetName,
    this.autoCharsetPrefferedOrder,
    this.autoCharsetFallback,
    this.viewFinderMode,
    this.codeIdType,
    this.volumeSliderType,
    this.decodeAudioFeedbackUri,
    this.decodeHapticFeedback,
    this.btDisconnectOnExit,
    this.connectionIdleTime,
    this.establishConnectionTime,
    this.remoteScannerAudioFeedbackMode,
    this.remoteScannerLedFeedbackMode,
    this.displayBtAddressBarcode,
    this.goodDecodeLedTimer,
    this.decodingLedFeedback,
    this.decoderUsPlanetReportCheckDigit,
    this.decodeScreenNotification,
    this.decodeScreenTime,
    this.decodeScreenTranslucency,
    this.keepParingInfoAfterReboot,
    this.dpmIlluminationControl,
    this.dpmMode,
    this.qrLaunchEnable,
    this.qrLaunchEnableQrDecoder,
    this.qrLaunchShowConfirmationDialog,
    this.noDecodeTime,
  });

  bool? dataBarToUpcEan;

  bool? upcEnableMarginlessDecode;

  int? upcEanSecurityLevel;

  bool? upcEanSupplemental2;

  bool? upcEanSupplemental5;

  UpcSupplementalMode? upcEanSupplementalMode;

  int? upcEanRetryCount;

  bool? upcEeanLinearDecode;

  bool? upcEanBookland;

  bool? upcEanCoupon;

  UpcEanCouponReport? upcEanCouponReport;

  bool? upcEanZeroExtend;

  UpcEanBooklandFormat? upceanBooklandFormat;

  ScanningMode? scanningMode;

  String? docCaptureTemplate;

  int? commonBarcodeDynamicQuantity;

  bool? barcodeHighlightingEnabled;

  String? ruleName;

  bool? enableUdiGs1;

  bool? enableUdiHibcc;

  bool? enableUdiIccbba;

  OcrOrientation? ocrOrientation;

  int? ocrLines;

  int? ocrMinChars;

  int? ocrMaxChars;

  String? ocrSubset;

  int? ocrQuietZone;

  String? ocrTemplate;

  int? ocrCheckDigitModulus;

  int? ocrCheckDigitMultiplier;

  int? ocrCheckDigitValidation;

  InverseOcr? inverseOcr;

  PresentationModeSensitivity? presentationModeSensitivity;

  bool? enableHardwareTrigger;

  SwitchOnEvent? autoSwitchToDefaultOnEvent;

  bool? digimarcDecoding;

  int? multiBarcodeCount;

  bool? enableInstantReporting;

  bool? reportDecodedBarcodes;

  TriggerSource? scannerTriggerResource;

  bool? scannerInputEnabled;

  ScannerIdentifer? scannerSelection;

  bool? configureAllScanners;

  String? scannerSelectionByIdentifier;

  bool? enableAimMode;

  int? beamTimer;

  bool? enableAdaptiveScanning;

  BeamWidth? beamWidth;

  PowerMode? powerMode;

  MpdMode? mpdMode;

  ReaderMode? readerMode;

  int? linearSecurityLevel;

  PicklistMode? picklist;

  AimType? aimType;

  SceneDetectQualifier? sceneDetectQualifier;

  int? aimTimer;

  int? sameBarcodeTimeout;

  bool? triggerWakeupScan;

  int? differentBarcodeTimeout;

  IlluminationMode? illuminationMode;

  int? illuminationBrightness;

  LcdMode? lcdMode;

  int? lowPowerTimeout;

  DelayToLowPowerMode? delayToLowPowerMode;

  Inverse1dMode? inverse1dMode;

  int? viewFinderSize;

  int? viewFinderPosX;

  int? viewFinderPosY;

  EffortLevel? marginlessEffortLevel1d;

  EffortLevel? poorQualityBcDecodeEffortLevel;

  Charset? charsetName;

  List<String?>? autoCharsetPrefferedOrder;

  Charset? autoCharsetFallback;

  ViewFinderMode? viewFinderMode;

  CodeIdType? codeIdType;

  VolumeSliderType? volumeSliderType;

  String? decodeAudioFeedbackUri;

  bool? decodeHapticFeedback;

  bool? btDisconnectOnExit;

  int? connectionIdleTime;

  int? establishConnectionTime;

  int? remoteScannerAudioFeedbackMode;

  int? remoteScannerLedFeedbackMode;

  bool? displayBtAddressBarcode;

  int? goodDecodeLedTimer;

  bool? decodingLedFeedback;

  bool? decoderUsPlanetReportCheckDigit;

  bool? decodeScreenNotification;

  int? decodeScreenTime;

  int? decodeScreenTranslucency;

  bool? keepParingInfoAfterReboot;

  DpmIlluminationControl? dpmIlluminationControl;

  DpmMode? dpmMode;

  bool? qrLaunchEnable;

  bool? qrLaunchEnableQrDecoder;

  bool? qrLaunchShowConfirmationDialog;

  int? noDecodeTime;

  Object encode() {
    return <Object?>[
      dataBarToUpcEan,
      upcEnableMarginlessDecode,
      upcEanSecurityLevel,
      upcEanSupplemental2,
      upcEanSupplemental5,
      upcEanSupplementalMode?.index,
      upcEanRetryCount,
      upcEeanLinearDecode,
      upcEanBookland,
      upcEanCoupon,
      upcEanCouponReport?.index,
      upcEanZeroExtend,
      upceanBooklandFormat?.index,
      scanningMode?.index,
      docCaptureTemplate,
      commonBarcodeDynamicQuantity,
      barcodeHighlightingEnabled,
      ruleName,
      enableUdiGs1,
      enableUdiHibcc,
      enableUdiIccbba,
      ocrOrientation?.index,
      ocrLines,
      ocrMinChars,
      ocrMaxChars,
      ocrSubset,
      ocrQuietZone,
      ocrTemplate,
      ocrCheckDigitModulus,
      ocrCheckDigitMultiplier,
      ocrCheckDigitValidation,
      inverseOcr?.index,
      presentationModeSensitivity?.index,
      enableHardwareTrigger,
      autoSwitchToDefaultOnEvent?.index,
      digimarcDecoding,
      multiBarcodeCount,
      enableInstantReporting,
      reportDecodedBarcodes,
      scannerTriggerResource?.index,
      scannerInputEnabled,
      scannerSelection?.index,
      configureAllScanners,
      scannerSelectionByIdentifier,
      enableAimMode,
      beamTimer,
      enableAdaptiveScanning,
      beamWidth?.index,
      powerMode?.index,
      mpdMode?.index,
      readerMode?.index,
      linearSecurityLevel,
      picklist?.index,
      aimType?.index,
      sceneDetectQualifier?.index,
      aimTimer,
      sameBarcodeTimeout,
      triggerWakeupScan,
      differentBarcodeTimeout,
      illuminationMode?.index,
      illuminationBrightness,
      lcdMode?.index,
      lowPowerTimeout,
      delayToLowPowerMode?.index,
      inverse1dMode?.index,
      viewFinderSize,
      viewFinderPosX,
      viewFinderPosY,
      marginlessEffortLevel1d?.index,
      poorQualityBcDecodeEffortLevel?.index,
      charsetName?.index,
      autoCharsetPrefferedOrder,
      autoCharsetFallback?.index,
      viewFinderMode?.index,
      codeIdType?.index,
      volumeSliderType?.index,
      decodeAudioFeedbackUri,
      decodeHapticFeedback,
      btDisconnectOnExit,
      connectionIdleTime,
      establishConnectionTime,
      remoteScannerAudioFeedbackMode,
      remoteScannerLedFeedbackMode,
      displayBtAddressBarcode,
      goodDecodeLedTimer,
      decodingLedFeedback,
      decoderUsPlanetReportCheckDigit,
      decodeScreenNotification,
      decodeScreenTime,
      decodeScreenTranslucency,
      keepParingInfoAfterReboot,
      dpmIlluminationControl?.index,
      dpmMode?.index,
      qrLaunchEnable,
      qrLaunchEnableQrDecoder,
      qrLaunchShowConfirmationDialog,
      noDecodeTime,
    ];
  }

  static PluginBarcodeParamters decode(Object result) {
    result as List<Object?>;
    return PluginBarcodeParamters(
      dataBarToUpcEan: result[0] as bool?,
      upcEnableMarginlessDecode: result[1] as bool?,
      upcEanSecurityLevel: result[2] as int?,
      upcEanSupplemental2: result[3] as bool?,
      upcEanSupplemental5: result[4] as bool?,
      upcEanSupplementalMode: result[5] != null
          ? UpcSupplementalMode.values[result[5]! as int]
          : null,
      upcEanRetryCount: result[6] as int?,
      upcEeanLinearDecode: result[7] as bool?,
      upcEanBookland: result[8] as bool?,
      upcEanCoupon: result[9] as bool?,
      upcEanCouponReport: result[10] != null
          ? UpcEanCouponReport.values[result[10]! as int]
          : null,
      upcEanZeroExtend: result[11] as bool?,
      upceanBooklandFormat: result[12] != null
          ? UpcEanBooklandFormat.values[result[12]! as int]
          : null,
      scanningMode: result[13] != null
          ? ScanningMode.values[result[13]! as int]
          : null,
      docCaptureTemplate: result[14] as String?,
      commonBarcodeDynamicQuantity: result[15] as int?,
      barcodeHighlightingEnabled: result[16] as bool?,
      ruleName: result[17] as String?,
      enableUdiGs1: result[18] as bool?,
      enableUdiHibcc: result[19] as bool?,
      enableUdiIccbba: result[20] as bool?,
      ocrOrientation: result[21] != null
          ? OcrOrientation.values[result[21]! as int]
          : null,
      ocrLines: result[22] as int?,
      ocrMinChars: result[23] as int?,
      ocrMaxChars: result[24] as int?,
      ocrSubset: result[25] as String?,
      ocrQuietZone: result[26] as int?,
      ocrTemplate: result[27] as String?,
      ocrCheckDigitModulus: result[28] as int?,
      ocrCheckDigitMultiplier: result[29] as int?,
      ocrCheckDigitValidation: result[30] as int?,
      inverseOcr: result[31] != null
          ? InverseOcr.values[result[31]! as int]
          : null,
      presentationModeSensitivity: result[32] != null
          ? PresentationModeSensitivity.values[result[32]! as int]
          : null,
      enableHardwareTrigger: result[33] as bool?,
      autoSwitchToDefaultOnEvent: result[34] != null
          ? SwitchOnEvent.values[result[34]! as int]
          : null,
      digimarcDecoding: result[35] as bool?,
      multiBarcodeCount: result[36] as int?,
      enableInstantReporting: result[37] as bool?,
      reportDecodedBarcodes: result[38] as bool?,
      scannerTriggerResource: result[39] != null
          ? TriggerSource.values[result[39]! as int]
          : null,
      scannerInputEnabled: result[40] as bool?,
      scannerSelection: result[41] != null
          ? ScannerIdentifer.values[result[41]! as int]
          : null,
      configureAllScanners: result[42] as bool?,
      scannerSelectionByIdentifier: result[43] as String?,
      enableAimMode: result[44] as bool?,
      beamTimer: result[45] as int?,
      enableAdaptiveScanning: result[46] as bool?,
      beamWidth: result[47] != null
          ? BeamWidth.values[result[47]! as int]
          : null,
      powerMode: result[48] != null
          ? PowerMode.values[result[48]! as int]
          : null,
      mpdMode: result[49] != null
          ? MpdMode.values[result[49]! as int]
          : null,
      readerMode: result[50] != null
          ? ReaderMode.values[result[50]! as int]
          : null,
      linearSecurityLevel: result[51] as int?,
      picklist: result[52] != null
          ? PicklistMode.values[result[52]! as int]
          : null,
      aimType: result[53] != null
          ? AimType.values[result[53]! as int]
          : null,
      sceneDetectQualifier: result[54] != null
          ? SceneDetectQualifier.values[result[54]! as int]
          : null,
      aimTimer: result[55] as int?,
      sameBarcodeTimeout: result[56] as int?,
      triggerWakeupScan: result[57] as bool?,
      differentBarcodeTimeout: result[58] as int?,
      illuminationMode: result[59] != null
          ? IlluminationMode.values[result[59]! as int]
          : null,
      illuminationBrightness: result[60] as int?,
      lcdMode: result[61] != null
          ? LcdMode.values[result[61]! as int]
          : null,
      lowPowerTimeout: result[62] as int?,
      delayToLowPowerMode: result[63] != null
          ? DelayToLowPowerMode.values[result[63]! as int]
          : null,
      inverse1dMode: result[64] != null
          ? Inverse1dMode.values[result[64]! as int]
          : null,
      viewFinderSize: result[65] as int?,
      viewFinderPosX: result[66] as int?,
      viewFinderPosY: result[67] as int?,
      marginlessEffortLevel1d: result[68] != null
          ? EffortLevel.values[result[68]! as int]
          : null,
      poorQualityBcDecodeEffortLevel: result[69] != null
          ? EffortLevel.values[result[69]! as int]
          : null,
      charsetName: result[70] != null
          ? Charset.values[result[70]! as int]
          : null,
      autoCharsetPrefferedOrder: (result[71] as List<Object?>?)?.cast<String?>(),
      autoCharsetFallback: result[72] != null
          ? Charset.values[result[72]! as int]
          : null,
      viewFinderMode: result[73] != null
          ? ViewFinderMode.values[result[73]! as int]
          : null,
      codeIdType: result[74] != null
          ? CodeIdType.values[result[74]! as int]
          : null,
      volumeSliderType: result[75] != null
          ? VolumeSliderType.values[result[75]! as int]
          : null,
      decodeAudioFeedbackUri: result[76] as String?,
      decodeHapticFeedback: result[77] as bool?,
      btDisconnectOnExit: result[78] as bool?,
      connectionIdleTime: result[79] as int?,
      establishConnectionTime: result[80] as int?,
      remoteScannerAudioFeedbackMode: result[81] as int?,
      remoteScannerLedFeedbackMode: result[82] as int?,
      displayBtAddressBarcode: result[83] as bool?,
      goodDecodeLedTimer: result[84] as int?,
      decodingLedFeedback: result[85] as bool?,
      decoderUsPlanetReportCheckDigit: result[86] as bool?,
      decodeScreenNotification: result[87] as bool?,
      decodeScreenTime: result[88] as int?,
      decodeScreenTranslucency: result[89] as int?,
      keepParingInfoAfterReboot: result[90] as bool?,
      dpmIlluminationControl: result[91] != null
          ? DpmIlluminationControl.values[result[91]! as int]
          : null,
      dpmMode: result[92] != null
          ? DpmMode.values[result[92]! as int]
          : null,
      qrLaunchEnable: result[93] as bool?,
      qrLaunchEnableQrDecoder: result[94] as bool?,
      qrLaunchShowConfirmationDialog: result[95] as bool?,
      noDecodeTime: result[96] as int?,
    );
  }
}

class ProfileConfig {
  ProfileConfig({
    required this.profileName,
    required this.configMode,
    this.barcodeParamters,
    this.intentParamters,
    required this.profileEnabled,
    this.appList,
  });

  String profileName;

  ConfigMode configMode;

  PluginBarcodeParamters? barcodeParamters;

  PluginIntentParamters? intentParamters;

  bool profileEnabled;

  List<AppEntry?>? appList;

  Object encode() {
    return <Object?>[
      profileName,
      configMode.index,
      barcodeParamters?.encode(),
      intentParamters?.encode(),
      profileEnabled,
      appList,
    ];
  }

  static ProfileConfig decode(Object result) {
    result as List<Object?>;
    return ProfileConfig(
      profileName: result[0]! as String,
      configMode: ConfigMode.values[result[1]! as int],
      barcodeParamters: result[2] != null
          ? PluginBarcodeParamters.decode(result[2]! as List<Object?>)
          : null,
      intentParamters: result[3] != null
          ? PluginIntentParamters.decode(result[3]! as List<Object?>)
          : null,
      profileEnabled: result[4]! as bool,
      appList: (result[5] as List<Object?>?)?.cast<AppEntry?>(),
    );
  }
}

class ScanEvent {
  ScanEvent({
    required this.labelType,
    required this.source,
    required this.dataString,
    required this.decodeData,
    required this.decodeMode,
  });

  LabelType labelType;

  ScanSource source;

  String dataString;

  List<Uint8List?> decodeData;

  DecodeMode decodeMode;

  Object encode() {
    return <Object?>[
      labelType.index,
      source.index,
      dataString,
      decodeData,
      decodeMode.index,
    ];
  }

  static ScanEvent decode(Object result) {
    result as List<Object?>;
    return ScanEvent(
      labelType: LabelType.values[result[0]! as int],
      source: ScanSource.values[result[1]! as int],
      dataString: result[2]! as String,
      decodeData: (result[3] as List<Object?>?)!.cast<Uint8List?>(),
      decodeMode: DecodeMode.values[result[4]! as int],
    );
  }
}

class StatusChangeEvent {
  StatusChangeEvent({
    required this.newState,
  });

  ScannerState newState;

  Object encode() {
    return <Object?>[
      newState.index,
    ];
  }

  static StatusChangeEvent decode(Object result) {
    result as List<Object?>;
    return StatusChangeEvent(
      newState: ScannerState.values[result[0]! as int],
    );
  }
}

class _DataWedgeFlutterApiCodec extends StandardMessageCodec {
  const _DataWedgeFlutterApiCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is ScanEvent) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else if (value is StatusChangeEvent) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128: 
        return ScanEvent.decode(readValue(buffer)!);
      case 129: 
        return StatusChangeEvent.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

abstract class DataWedgeFlutterApi {
  static const MessageCodec<Object?> codec = _DataWedgeFlutterApiCodec();

  void onScannerStatusChanged(StatusChangeEvent statusEvent);

  void onScanResult(ScanEvent scanEvent);

  void onProfileChange();

  void onConfigUpdate();

  static void setup(DataWedgeFlutterApi? api, {BinaryMessenger? binaryMessenger}) {
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.flutter_datawedge.DataWedgeFlutterApi.onScannerStatusChanged', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null,
          'Argument for dev.flutter.pigeon.flutter_datawedge.DataWedgeFlutterApi.onScannerStatusChanged was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final StatusChangeEvent? arg_statusEvent = (args[0] as StatusChangeEvent?);
          assert(arg_statusEvent != null,
              'Argument for dev.flutter.pigeon.flutter_datawedge.DataWedgeFlutterApi.onScannerStatusChanged was null, expected non-null StatusChangeEvent.');
          api.onScannerStatusChanged(arg_statusEvent!);
          return;
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.flutter_datawedge.DataWedgeFlutterApi.onScanResult', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null,
          'Argument for dev.flutter.pigeon.flutter_datawedge.DataWedgeFlutterApi.onScanResult was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final ScanEvent? arg_scanEvent = (args[0] as ScanEvent?);
          assert(arg_scanEvent != null,
              'Argument for dev.flutter.pigeon.flutter_datawedge.DataWedgeFlutterApi.onScanResult was null, expected non-null ScanEvent.');
          api.onScanResult(arg_scanEvent!);
          return;
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.flutter_datawedge.DataWedgeFlutterApi.onProfileChange', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          // ignore message
          api.onProfileChange();
          return;
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.flutter_datawedge.DataWedgeFlutterApi.onConfigUpdate', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          // ignore message
          api.onConfigUpdate();
          return;
        });
      }
    }
  }
}

class _DataWedgeHostApiCodec extends StandardMessageCodec {
  const _DataWedgeHostApiCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is AppEntry) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else if (value is CreateProfileResponse) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else if (value is PluginBarcodeParamters) {
      buffer.putUint8(130);
      writeValue(buffer, value.encode());
    } else if (value is PluginIntentParamters) {
      buffer.putUint8(131);
      writeValue(buffer, value.encode());
    } else if (value is ProfileConfig) {
      buffer.putUint8(132);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128: 
        return AppEntry.decode(readValue(buffer)!);
      case 129: 
        return CreateProfileResponse.decode(readValue(buffer)!);
      case 130: 
        return PluginBarcodeParamters.decode(readValue(buffer)!);
      case 131: 
        return PluginIntentParamters.decode(readValue(buffer)!);
      case 132: 
        return ProfileConfig.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

class DataWedgeHostApi {
  /// Constructor for [DataWedgeHostApi].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  DataWedgeHostApi({BinaryMessenger? binaryMessenger})
      : _binaryMessenger = binaryMessenger;
  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = _DataWedgeHostApiCodec();

  Future<CreateProfileResponse> createProfile(String arg_profileName) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.flutter_datawedge.DataWedgeHostApi.createProfile', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_profileName]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as CreateProfileResponse?)!;
    }
  }

  Future<String> registerForNotifications() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.flutter_datawedge.DataWedgeHostApi.registerForNotifications', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(null) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as String?)!;
    }
  }

  Future<String> unregisterForNotifications() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.flutter_datawedge.DataWedgeHostApi.unregisterForNotifications', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(null) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as String?)!;
    }
  }

  Future<String> suspendPlugin() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.flutter_datawedge.DataWedgeHostApi.suspendPlugin', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(null) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as String?)!;
    }
  }

  Future<String> resumePlugin() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.flutter_datawedge.DataWedgeHostApi.resumePlugin', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(null) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as String?)!;
    }
  }

  Future<String> enablePlugin() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.flutter_datawedge.DataWedgeHostApi.enablePlugin', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(null) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as String?)!;
    }
  }

  Future<String> disablePlugin() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.flutter_datawedge.DataWedgeHostApi.disablePlugin', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(null) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as String?)!;
    }
  }

  Future<String> getPackageIdentifer() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.flutter_datawedge.DataWedgeHostApi.getPackageIdentifer', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(null) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as String?)!;
    }
  }

  Future<void> setProfileConfig(ProfileConfig arg_config) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.flutter_datawedge.DataWedgeHostApi.setProfileConfig', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_config]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return;
    }
  }
}
