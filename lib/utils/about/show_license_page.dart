import 'package:flutter/material.dart';
import 'package:kabegami_resize/utils/about/get_app_version.dart';

void showLicense(BuildContext context) {
  getAppVersion().then((version) {
    showLicensePage(
      context: context,
      applicationName: '壁紙リサイズ',
      applicationVersion: version,
      applicationLegalese: '© 2024 Sena Aoyagi',
    );
  });
}