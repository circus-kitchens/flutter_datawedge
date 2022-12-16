enum ScannerPluginCommand {
  ///RESUME_PLUGIN:  resumes the scanner when changing from the SUSPEND_PLUGIN suspended state.
  ///SCANNER_STATUS notification broadcasts WAITING and SCANNING states, rotating between each depending on
  ///whether scanning is taking place. In the WAITING state it is expecting an action from the user such as a trigger
  ///press. In the SCANNING state it is actively performing a scan resulting from an action such as a trigger press
  resumePlugin('RESUME_PLUGIN'),

  ///SUSPEND_PLUGIN: suspends the scanner so it is temporarily inactive when switching from the WAITING or SCANNING state.
  ///SCANNER_STATUS notification broadcasts IDLE state
  suspendPlugin('SUSPEND_PLUGIN'),

  ///  ENABLE_PLUGIN: enables the plug-in; scanner becomes active. SCANNER_STATUS
  ///  notification broadcasts WAITING and SCANNING states,
  ///  rotating between each depending on whether scanning is taking place.
  enablePlugin('ENABLE_PLUGIN'),

  ///  DISABLE_PLUGIN: disables the plug-in; scanner becomes inactive.
  ///  SCANNER_STATUS notification broadcasts DISABLED state.
  disablePlugin('DISABLE_PLUGIN');

  final String value;

  const ScannerPluginCommand(this.value);

  static ScannerPluginCommand fromString(String value) {
    return ScannerPluginCommand.values.firstWhere((e) => e.value == value);
  }
}
