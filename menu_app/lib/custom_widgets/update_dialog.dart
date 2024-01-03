import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void showUpdateDialog(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Required'),
          content: const Text(
              'Your app is out of date. It may not function properly. Please update to the latest version.'),
          actions: [
            TextButton(
              onPressed: () {
                // Replace the URL with your app's store URL
                // This example assumes you're using the Google Play Store for Android
                // and the App Store for iOS
                if (Platform.isAndroid || Platform.isIOS) {
                  final appId = Platform.isAndroid
                      ? 'com.orderOfTheCone.android.menu_app'
                      : '1670523487';
                  final url = Uri.parse(
                    Platform.isAndroid
                        ? "market://details?id=$appId"
                        : "https://apps.apple.com/app/id$appId",
                  );
                  launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  );
                }
              },
              child: const Text('Update Now'),
            ),
          ],
        );
      },
    );
  }