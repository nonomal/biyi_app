import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/utils/utils.dart';
import 'package:biyi_app/widgets/feature_status_icon/feature_status_icon.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:reflect_colors/reflect_colors.dart';
import 'package:reflect_ui/reflect_ui.dart';
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
    return GappedRow(
      gap: 6,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FeatureStatusIcon(supported: allowed),
        Expanded(
          child: Wrap(
            spacing: 30,
            children: [
              Text(
                title,
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
                      style: TextStyle(
                        color: ReflectColors.neutral.shade700,
                        decoration: TextDecoration.underline,
                        decorationThickness: 1.5,
                        decorationColor: ReflectColors.neutral.shade700,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        height: 18 / 13,
                      ),
                    ),
                  ],
                ),
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
      kind: AlertKind.warning,
      variant: AlertVariant.filled,
      icon: const Icon(FluentIcons.warning_20_regular),
      title: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: LocaleKeys.app_home_limited_banner_title.tr()),
            WidgetSpan(
              child: Tooltip(
                message: LocaleKeys.app_home_limited_banner_tip_help.tr(),
                child: GestureDetector(
                  child: Container(
                    margin: const EdgeInsets.only(left: 4),
                    width: 16,
                    height: 16,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: HoverableArea(
                        builder: (context, hovered) {
                          return Center(
                            child: Icon(
                              FluentIcons.question_circle_20_regular,
                              size: 14,
                              color: hovered ? Colors.white70 : Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  onTap: () async {
                    Uri url = Uri.parse('${sharedEnv.webUrl}/docs');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      message: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 2),
        child: GappedColumn(
          gap: 6,
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
        ),
      ),
      actions: [
        Theme(
          data: Theme.of(context).copyWith(brightness: Brightness.light),
          child: Button(
            kind: ButtonKind.secondary,
            variant: ButtonVariant.tinted,
            onPressed: onTappedRecheckIsAllowedAllAccess,
            child: Text(
              LocaleKeys.app_home_limited_banner_btn_check_again.tr(),
            ),
          ),
        ),
        Expanded(child: Container()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }
}
