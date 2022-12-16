enum MethodChannelMethods {
  createDataWedgeProfile("createDataWedgeProfile"),
  getPlatformVersion("getPlatformVersion"),
  sendDataWedgeCommandStringParameter("sendDataWedgeCommandStringParameter");

  final String value;

  const MethodChannelMethods(this.value);

  @override
  String toString() => value;
}
