enum MethodChannelMethods {
  createDataWedgeProfile("createDataWedgeProfile"),
  updateDataWedgeProfile("updateDataWedgeProfile"),
  listenScannerStatus("listenScannerStatus"),
  sendDataWedgeCommandStringParameter("sendDataWedgeCommandStringParameter");

  final String value;

  const MethodChannelMethods(this.value);
}
