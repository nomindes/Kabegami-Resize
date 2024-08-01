import 'package:flutter/material.dart';
import 'show_license_page.dart';
import 'package:url_launcher/url_launcher.dart';

void handleLinkTap(BuildContext context, String url) {
  if (url != 'license') {
    launchUrl(Uri.parse(url));
  } else {
    showLicense(context);
  }
}