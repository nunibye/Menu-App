import 'package:flutter/material.dart';
import 'package:menu_app/views/about_page.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutController extends ChangeNotifier {
  final BuildContext context;

  String donateLink = 'https://www.buymeacoffee.com/christiantknab';

  AboutController({required this.context});

  openEmail(BuildContext context) async {
    EmailContent email = EmailContent(to: ["ucscmenuapp@gmail.com"]);
    // Android: Will open mail app or show native picker.
    // iOS: Will open mail app if single mail app found.
    var result = await OpenMailApp.composeNewEmailInMailApp(
      nativePickerTitle: 'Select email app to compose',
      emailContent: email,
    );
    if (context.mounted) {
      // If no mail apps found, show error
      if (!result.didOpen && !result.canOpen) {
        showNoMailAppsDialog(context);

        // iOS: if multiple mail apps found, show dialog to select.
      } else if (!result.didOpen && result.canOpen) {
        showDialog(
          context: context,
          builder: (_) {
            return MailAppPickerDialog(
              mailApps: result.options,
              emailContent: email,
            );
          },
        );
      }
    }
  }

  launchDonateLink() {
    launchUrl(Uri.parse(donateLink));
  }
}
