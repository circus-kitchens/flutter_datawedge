//ignore_for_file: avoid_positional_boolean_parameters
import 'package:pigeon/pigeon.dart';

/// Result when creating a profile
class CreateProfileResponse {
  CreateProfileResponse({
    required this.responseType,
  });

  CreateProfileResponseType responseType;
}

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

class PluginBarcodeParamters {
  // All default parameters are taken from data wedge

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
  //? 500-1500
  int? decodeScreenTime;

  //? 20 - 50 in 5 increments
  int? decodeScreenTranslucency;

  bool? keepParingInfoAfterReboot;

  DpmIlluminationControl? dpmIlluminationControl;

  DpmMode? dpmMode;

  bool? qrLaunchEnable;

  bool? qrLaunchEnableQrDecoder;

  bool? qrLaunchShowConfirmationDialog;

  int? noDecodeTime;

  // in 1000 increments, 0 180000
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

  bool profileEnabled;
  List<AppEntry?>? appList;
}

@FlutterApi()
abstract class DataWedgeFlutterApi {
  void onScannerStatusChanged();
  void onScanResult();
  void onProfileChange();
}

@HostApi()
abstract class DataWedgeHostApi {
  @async
  CreateProfileResponse createProfile(
    String profileName,
  );

  String getPackageIdentifer();

  @async
  void setProfileConfig(ProfileConfig config);
  @async
  void listenScannerStatus();
}
