import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/includes.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:influxui/influxui.dart';
import 'package:screen_capturer/screen_capturer.dart';
import 'package:screen_text_extractor/screen_text_extractor.dart';
import 'package:uni_platform/uni_platform.dart';
import 'package:url_launcher/url_launcher.dart';

class AllowAccessListItem extends StatelessWidget {
  const AllowAccessListItem({
    super.key,
    required this.title,
    required this.allowed,
    this.onTappedTryAllow,
    this.onTappedGoSettings,
  });

  final String title;
  final bool allowed;
  final VoidCallback? onTappedTryAllow;
  final VoidCallback? onTappedGoSettings;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Text.rich(
      TextSpan(
        text: allowed ? '✅' : '❌',
        children: [
          const TextSpan(text: '  '),
          TextSpan(text: title),
          const TextSpan(text: '      '),
          if (onTappedTryAllow != null)
            TextSpan(
              text: LocaleKeys.app_home_limited_banner_btn_allow.tr(),
              style: const TextStyle(
                decoration: TextDecoration.underline,
                decorationColor: ExtendedColors.white,
              ),
              recognizer: TapGestureRecognizer()..onTap = onTappedTryAllow,
            ),
          if (onTappedTryAllow != null) const TextSpan(text: ' / '),
          if (onTappedGoSettings != null)
            TextSpan(
              text: LocaleKeys.app_home_limited_banner_btn_go_settings.tr(),
              style: const TextStyle(
                decoration: TextDecoration.underline,
                decorationColor: ExtendedColors.white,
              ),
              recognizer: TapGestureRecognizer()..onTap = onTappedGoSettings,
            ),
        ],
      ),
      style: textTheme.bodyMedium!.copyWith(
        color: ExtendedColors.white,
        fontSize: 13,
      ),
    );
  }
}

class LimitedFunctionalityBanner extends StatelessWidget {
  const LimitedFunctionalityBanner({
    super.key,
    required this.isAllowedScreenCaptureAccess,
    required this.isAllowedScreenSelectionAccess,
    required this.onTappedRecheckIsAllowedAllAccess,
  });
  final bool isAllowedScreenCaptureAccess;
  final bool isAllowedScreenSelectionAccess;
  final VoidCallback onTappedRecheckIsAllowedAllAccess;

  bool get _isAllowedAllAccess =>
      isAllowedScreenCaptureAccess && isAllowedScreenSelectionAccess;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    if (_isAllowedAllAccess) return Container();

    return Container(
      color: ExtendedColors.orange,
      width: double.infinity,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(
          left: 0,
          right: 0,
        ),
        padding: const EdgeInsets.only(
          top: 12,
          bottom: 12,
          left: 18,
          right: 18,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                text: LocaleKeys.app_home_limited_banner_title.tr(),
              ),
              style: textTheme.bodyMedium!.copyWith(
                color: ExtendedColors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 6, bottom: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (UniPlatform.isMacOS)
                    AllowAccessListItem(
                      title: LocaleKeys
                          .app_home_limited_banner_text_screen_capture
                          .tr(),
                      allowed: isAllowedScreenCaptureAccess,
                      onTappedTryAllow: () {
                        ScreenCapturer.instance.requestAccess();
                        BotToast.showText(
                          text: LocaleKeys
                              .app_home_limited_banner_msg_allow_access_tip
                              .tr(),
                          align: Alignment.center,
                          duration: const Duration(seconds: 5),
                        );
                      },
                      onTappedGoSettings: () {
                        ScreenCapturer.instance.requestAccess(
                          onlyOpenPrefPane: true,
                        );
                      },
                    ),
                  if (UniPlatform.isMacOS)
                    AllowAccessListItem(
                      title: LocaleKeys
                          .app_home_limited_banner_text_screen_selection
                          .tr(),
                      allowed: isAllowedScreenSelectionAccess,
                      onTappedTryAllow: () {
                        screenTextExtractor.requestAccess();
                        BotToast.showText(
                          text: LocaleKeys
                              .app_home_limited_banner_msg_allow_access_tip
                              .tr(),
                          align: Alignment.center,
                          duration: const Duration(seconds: 5),
                        );
                      },
                      onTappedGoSettings: () {
                        screenTextExtractor.requestAccess(
                          onlyOpenPrefPane: true,
                        );
                      },
                    ),
                ],
              ),
            ),
            Row(
              children: [
                Tooltip(
                  message: LocaleKeys.app_home_limited_banner_tip_help.tr(),
                  child: IconButton(
                    FluentIcons.question_circle_20_regular,
                    iconSize: 18,
                    variant: IconButtonVariant.transparent,
                    size: IconButtonSize.small,
                    onPressed: () async {
                      Uri url = Uri.parse('${sharedEnv.webUrl}/docs');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: LocaleKeys.app_home_limited_banner_btn_check_again
                            .tr(),
                        style: const TextStyle(
                          color: ExtendedColors.white,
                          height: 1.3,
                          decoration: TextDecoration.underline,
                          decorationColor: ExtendedColors.white,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = onTappedRecheckIsAllowedAllAccess,
                      ),
                    ],
                  ),
                  style: textTheme.bodyMedium!.copyWith(
                    color: ExtendedColors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
