enum MethodChannelMethods {
  createDataWedgeProfile("createDataWedgeProfile"),
  getPlatformVersion("getPlatformVersion"),
  listenScannerStatus("listenScannerStatus"),
  sendDataWedgeCommandStringParameter("sendDataWedgeCommandStringParameter");

  final String value;

  const MethodChannelMethods(this.value);
}
