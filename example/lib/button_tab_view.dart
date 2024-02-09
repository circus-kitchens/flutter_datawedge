import 'package:flutter/material.dart';
import 'package:flutter_datawedge/flutter_datawedge.dart';

class ButtonTabView extends StatelessWidget {
  ButtonTabView(this.fdw);

  final FlutterDataWedge fdw;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async => fdw.enableScanner(true),
                  child: Text('Enable Scanner'),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async => fdw.enableScanner(false),
                  child: Text('Disable Scanner'),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => fdw.activateScanner(true),
                  child: Text('Activate Scanner'),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => fdw.activateScanner(false),
                  child: Text('Deactivate Scanner'),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => fdw.scannerControl(true),
                  child: Text('Scanner Control Activate'),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => fdw.scannerControl(false),
                  child: Text('Scanner Control DeActivate'),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => fdw.requestProfiles(),
                  child: Text('Request Profiles'),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => fdw.requestActiveProfile(),
                  child: Text('Request active Profile'),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => fdw.updateProfile(
                    profileName: 'Example app profile',
                    pluginName: 'KEYSTROKE',
                    config: {
                      'keystroke_output_enabled': true,
                    },
                  ),
                  child: Text('Enable KeyStroke Events'),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => fdw.updateProfile(
                    profileName: 'Example app profile',
                    pluginName: 'KEYSTROKE',
                    config: {
                      'keystroke_output_enabled': false,
                    },
                  ),
                  child: Text('Disable KeyStroke Events'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
