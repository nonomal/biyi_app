import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/utils/utils.dart';
import 'package:biyi_app/widgets/alert/alert.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:open_colors/open_colors.dart';
import 'package:reflect_ui/reflect_ui.dart' hide Alert;
import 'package:screen_capturer/screen_capturer.dart';
import 'package:screen_text_extractor/screen_text_extractor.dart';
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
    final ThemeData themeData = Theme.of(context);
    final textStyle = themeData.textTheme.bodyMedium?.copyWith(
      color: OpenColors.yellow.shade600,
      height: 24 / 14,
    );
    return GappedRow(
      gap: 4,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: allowed
              ? Icon(
                  FluentIcons.checkmark_circle_12_filled,
                  color: OpenColors.green.shade600,
                  size: 20,
                )
              : Icon(
                  FluentIcons.dismiss_circle_12_filled,
                  color: OpenColors.red.shade600,
                  size: 20,
                ),
        ),
        Expanded(
          child: Wrap(
            spacing: 30,
            children: [
              Text(
                title,
                style: textStyle,
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      children: [
                        if (onTappedTryAllow != null)
                          TextSpan(
                            text: LocaleKeys.app_home_limited_banner_btn_allow
                                .tr(),
                            recognizer: TapGestureRecognizer()
                              ..onTap = onTappedTryAllow,
                          ),
                        if (onTappedTryAllow != null)
                          const TextSpan(
                            text: ' / ',
                            style: TextStyle(
                              decoration: TextDecoration.none,
                            ),
                          ),
                        if (onTappedGoSettings != null)
                          TextSpan(
                            text: LocaleKeys
                                .app_home_limited_banner_btn_go_settings
                                .tr(),
                            recognizer: TapGestureRecognizer()
                              ..onTap = onTappedGoSettings,
                          ),
                      ],
                      style: textStyle?.copyWith(
                        color: OpenColors.yellow.shade600,
                        decoration: TextDecoration.underline,
                        decorationColor: OpenColors.yellow.shade600,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                style: textStyle,
              ),
            ],
          ),
        ),
      ],
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

  Widget _build(BuildContext context) {
    if (_isAllowedAllAccess) return Container();
    return Alert(
      type: AlertType.warning,
      icon: const Icon(FluentIcons.warning_20_regular),
      title: LocaleKeys.app_home_limited_banner_title.tr(),
      messageBuilder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AllowAccessListItem(
              title:
                  LocaleKeys.app_home_limited_banner_text_screen_capture.tr(),
              allowed: isAllowedScreenCaptureAccess,
              onTappedTryAllow: () {
                ScreenCapturer.instance.requestAccess();
                BotToast.showText(
                  text: LocaleKeys.app_home_limited_banner_msg_allow_access_tip
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
            AllowAccessListItem(
              title:
                  LocaleKeys.app_home_limited_banner_text_screen_selection.tr(),
              allowed: isAllowedScreenSelectionAccess,
              onTappedTryAllow: () {
                screenTextExtractor.requestAccess();
                BotToast.showText(
                  text: LocaleKeys.app_home_limited_banner_msg_allow_access_tip
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
        );
      },
      actions: [
        Button(
          color: OpenColors.yellow,
          onPressed: onTappedRecheckIsAllowedAllAccess,
          child: Text(LocaleKeys.app_home_limited_banner_btn_check_again.tr()),
        ),
        Expanded(child: Container()),
        Tooltip(
          message: LocaleKeys.app_home_limited_banner_tip_help.tr(),
          child: IconButton(
            FluentIcons.question_circle_20_regular,
            variant: IconButtonVariant.filled,
            color: OpenColors.yellow,
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }
}
