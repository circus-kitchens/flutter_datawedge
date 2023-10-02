import '../models/action_result.dart';
import '../src/consts/datawedge_api_targets.dart';

extension ActionResultLog on ActionResult {
  String get logContent {
    return switch (this.command) {
      DatawedgeApiTargets.softScanTrigger => '${result}',
      DatawedgeApiTargets.scannerPlugin =>
        result == "SUCCESS" ? '$result' : '${resultInfo!['RESULT_CODE']}',
      DatawedgeApiTargets.getProfiles => '${resultInfo!['profiles']}',
      DatawedgeApiTargets.getActiveProfile => '${resultInfo!['activeProfile']}',
    };
  }
}
