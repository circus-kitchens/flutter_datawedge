//ignore_for_file: avoid_positional_boolean_parameters

import 'package:pigeon/pigeon.dart';

/// Mode for profile creations
enum ConfigMode {
  createIfNotExists,
  overwrite,
  update,
}

/// An application that will trigger the profile
class AppEntry {
  AppEntry({
    required this.packageName,
    required this.activityList,
  });
  String packageName;
  List<String?> activityList;
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
  usbZebra
}

enum UpcSupplementalMode {
  none,
  always,
  auto,
  smart,
  supplemental378to379,
  supplemental978to979,
  supplemental414to419and434to439,
  supplemental977
}

enum UpcEanCouponReport { oldMode, newMode, both }

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
  omnidirectional
}

class PluginIntentParamters {
  bool? intentOutputEnabled;
  String? intentAction;
  String? intentCategory;
  IntentDelivery? intentDelivery;
  bool? intentUseContentProvider;
}

enum IntentDelivery { startActivity, startService, broadcast }

/// Used to configure the barcode plugin. Parameters can be found here
/// https://techdocs.zebra.com/datawedge/13-0/guide/api/setconfig/
class PluginBarcodeParamters {
  /// Configure decoders
  List<DecoderConfigItem?>? decoderConfig;

  // UPC Parameters below

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
  //? General parameters
  ScanningMode? scanningMode;
  String? docCaptureTemplate;
  int? commonBarcodeDynamicQuantity;
  bool? barcodeHighlightingEnabled;
  String? ruleName;
  bool? enableUdiGs1;
  bool? enableUdiHibcc;
  bool? enableUdiIccbba;
  OcrOrientation? ocrOrientation;

  /// Set number of lines to scan during OCR reading:
  int? ocrLines;

  /// Set minimum number of OCR characters (not including spaces) per line to
  /// decode during OCR reading. Integer value 3-100
  int? ocrMinChars;

  /// Set maximum number of OCR characters (not including spaces) per line to
  /// decode during OCR reading. Integer value:
  int? ocrMaxChars;

  /// Defines a custom group of characters in place of a preset font variant.
  String? ocrSubset;

  /// Set field width of blank space to stop scanning during OCR reading.
  /// The default is 50, indicating a six character width quiet zone. 20-99
  int? ocrQuietZone;

  /// Creates a template for precisely matching scanned OCR characters to a
  /// desired input format, which helps eliminate scanning errors. The template
  /// expression is formed by numbers and letters. The default is 99999999 which
  ///  accepts any alphanumeric character OCR string. If there are less than
  ///  8 '9' characters, the '9' represents only digit values.
  /// More info https://techdocs.zebra.com/datawedge/13-0/guide/input/barcode/#ocrparamsocraocrb
  String? ocrTemplate;

  /// Sets the Check Digit Modulus value for OCR Check Digit Calculation.
  int? ocrCheckDigitModulus;

  /// Sets OCR check digit multipliers for the character positions.
  int? ocrCheckDigitMultiplier;

  /// None - 0 (default)
  /// Product Add Left to Right - 3
  /// Product Add Right to Left - 1
  /// Digit Add Left to Right - 4
  /// Digit Add Right to Left - 2
  /// Product Add Right to Left Simple Remainder - 5
  /// Digit Add Right to Left Simple Remainder - 6
  /// Health Industry - HIBCC43 - 9
  int? ocrCheckDigitValidation;

  /// White or light words on black or dark background. This option is used
  /// to select normal, inverse or both OCR scanning.
  InverseOcr? inverseOcr;

  PresentationModeSensitivity? presentationModeSensitivity;
  //? barcode_trigger_mode
  bool? enableHardwareTrigger;
  SwitchOnEvent? autoSwitchToDefaultOnEvent;
  bool? digimarcDecoding;
  //? Multi barcode parameters
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
  //? 0 - 1800
  int? connectionIdleTime;
  //? 30-60
  int? establishConnectionTime;
  //? 1-3
  int? remoteScannerAudioFeedbackMode;
  //? 1-3
  int? remoteScannerLedFeedbackMode;
  bool? displayBtAddressBarcode;
  //? 0 - 1000
  int? goodDecodeLedTimer;
  bool? decodingLedFeedback;
  bool? decoderUsPlanetReportCheckDigit;
  bool? decodeScreenNotification;
  //// Length of time (in milliseconds) to display the screen notification
  /// upon successful decode. 500-1500
  int? decodeScreenTime;

  /// Sets the translucency value for the decode notification green screen -
  /// higher values result to more translucency.
  ///  Values range from 20 to 50 in increments of 5:
  int? decodeScreenTranslucency;

  /// Enable/disable automatic re-connection to the connected Bluetooth scanner
  ///  after device reboot. Applies only to connected Bluetooth scanners:
  bool? keepParingInfoAfterReboot;

  /// Controls the illumination for decoding DPM barcodes.
  /// Default value is cycle.
  DpmIlluminationControl? dpmIlluminationControl;

  /// Optimize DPM barcode decoding performance based on the barcode size.
  /// Default is Mode 2
  DpmMode? dpmMode;

  bool? qrLaunchEnable;
  bool? qrLaunchEnableQrDecoder;
  bool? qrLaunchShowConfirmationDialog;

  /// Integer from 0 to 180000 in 1000 increments
  int? noDecodeTime;
}

enum DpmMode {
  disabled,
  mode1,
  mode2,
}

enum BeamWidth { narrow, normal, wide }

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

enum PicklistMode { disabled, hardware, software }

enum ReaderMode { triggered, presentation }

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

enum DpmIlluminationControl { direct, indirect, cycle }

enum VolumeSliderType { ringer, musicMedia, alarms, notification }

enum CodeIdType { none, aim, symbol }

enum ViewFinderMode { enabled, staticReticle }

enum Charset { auto, utf8, iso88591, shiftJis, gb18030, none }

enum EffortLevel {
  level_0,
  level_1,
  level_2,
  level_3,
}

enum Inverse1dMode { disable, enable, auto }

enum DelayToLowPowerMode {
  seconds_1,
  seconds_30,
  minutes_1,
  minutes_5,
}

enum LcdMode { disabled, enabled }

enum IlluminationMode { off, torch }

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
  timedContinous
}

enum SwitchOnEvent { disabled, onConnect, onDisconnect, connectOrDisconnect }

enum PresentationModeSensitivity { high, medium, low }

class PluginConfig {
  PluginConfig({
    required this.pluginName,
    required this.resetConfig,
    this.outputPluginName,
  });

  bool resetConfig;
  PluginName pluginName;
  String? outputPluginName;
}

class ProfileConfig {
  ProfileConfig({
    required this.profileName,
    required this.configMode,
    required this.profileEnabled,
    this.appList,
    this.barcodeParamters,
  });

  String profileName;
  ConfigMode configMode;

  PluginBarcodeParamters? barcodeParamters;
  PluginIntentParamters? intentParamters;

  bool profileEnabled;
  List<AppEntry?>? appList;
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
}

class StatusChangeEvent {
  StatusChangeEvent({required this.newState});
  ScannerState newState;
}

@FlutterApi()
abstract class DataWedgeFlutterApi {
  void onScannerStatusChanged(StatusChangeEvent statusEvent);
  void onScanResult(ScanEvent scanEvent);
  void onProfileChange();
  void onConfigUpdate();
}

@HostApi()
abstract class DataWedgeHostApi {
  @async
  void createProfile(
    String profileName,
  );

  void registerForNotifications();
  void unregisterForNotifications();

  @async
  String suspendPlugin();

  @async
  String resumePlugin();

  @async
  String enablePlugin();

  @async
  String disablePlugin();

  @async
  String softScanTrigger(bool on);

  String getPackageIdentifer();

  @async
  void setDecoder(Decoder decoder, bool enabled, String profileName);

  @async
  void setProfileConfig(ProfileConfig config);
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

enum DecodeMode { multiple, single }

enum ScannerState {
  waiting,
  scanning,
  idle,
  connected,
  disconnected,
  disabled,
}

enum Decoder {
  australianPostal,
  aztec,
  canadianPostal,
  chinese2of5,
  codabar,
  code11,
  code32,
  code39,
  code93,
  code128,
  compositeAb,
  compositeC,
  datamatrix,
  signature,
  d2of5,
  dotcode,
  dutchPostal,
  ean8,
  ean13,
  finnishPostal4s,
  gridMatrix,
  gs1Databar,
  gs1DatabarLim,
  gs1DatabarExp,
  gs1Datamatrix,
  gs1Qrcode,
  hanxin,
  i2of5,
  japanesePostal,
  korean3of5,
  mailmark,
  matrix2of5,
  maxicode,
  micrE13b,
  micropdf,
  microqr,
  msi,
  ocrA,
  ocrB,
  pdf417,
  qrcode,
  tlc39,
  trioptic39,
  ukPostal,
  usCurrency,
  usplanet,
  usPostal,
  uspostnet,
  upca,
  upce0,
  upce1,
  us4state,
  us4stateFics,
}

class DecoderConfigItem {
  Decoder? decoder;
  bool? enabled;
}
