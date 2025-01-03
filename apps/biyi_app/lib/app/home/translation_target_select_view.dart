import 'dart:math' as math;

import 'package:biyi_app/models/settings_base.dart';
import 'package:biyi_app/utils/language_util.dart';
import 'package:biyi_app/widgets/widgets.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:reflect_ui/reflect_ui.dart';

class AvailableLanguageSelector extends StatelessWidget {
  const AvailableLanguageSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 12, top: 12, bottom: 12),
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.start,
        runAlignment: WrapAlignment.start,
        spacing: 6,
        runSpacing: 6,
        children: [
          for (String supportedLanguage in kSupportedLanguages)
            Container(
              margin: EdgeInsets.zero,
              child: Builder(
                builder: (_) {
                  bool isSelected = value == supportedLanguage;
                  Widget child = LanguageLabel(
                    supportedLanguage,
                    flagSize: 18,
                  );
                  return Button(
                    variant: isSelected
                        ? ButtonVariant.filled
                        : ButtonVariant.outlined,
                    onPressed: () => onChanged(supportedLanguage),
                    child: child,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class TranslationTargetSelectView extends StatefulWidget {
  const TranslationTargetSelectView({
    super.key,
    // this.viewKey,
    required this.translationMode,
    required this.isShowSourceLanguageSelector,
    required this.isShowTargetLanguageSelector,
    required this.onToggleShowSourceLanguageSelector,
    required this.onToggleShowTargetLanguageSelector,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.onChanged,
  });
  // final Key viewKey;
  final TranslationMode translationMode;
  final bool isShowSourceLanguageSelector;
  final bool isShowTargetLanguageSelector;
  final ValueChanged<bool> onToggleShowSourceLanguageSelector;
  final ValueChanged<bool> onToggleShowTargetLanguageSelector;
  final String sourceLanguage;
  final String targetLanguage;
  final Function(String sourceLanguage, String targetLanguage) onChanged;

  @override
  State<TranslationTargetSelectView> createState() =>
      _TranslationTargetSelectViewState();
}

class _TranslationTargetSelectViewState
    extends State<TranslationTargetSelectView> {
  bool _isRotated = false;

  void _handleChanged(String sourceLanguage, String targetLanguage) {
    widget.onChanged(
      sourceLanguage,
      targetLanguage,
    );
  }

  @override
  Widget build(BuildContext context) {
    IconThemeData iconThemeData = Theme.of(context).iconTheme;
    final DesignThemeData theme = DesignTheme.of(context);
    if (widget.translationMode == TranslationMode.auto) {
      return Container();
    }
    return Card(
      margin: const EdgeInsets.only(
        left: 12,
        right: 12,
        top: 0,
        bottom: 12,
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.zero,
            height: 40,
            child: Row(
              children: [
                Button(
                  variant: ButtonVariant.plain,
                  // padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Row(
                    children: [
                      LanguageLabel(
                        widget.sourceLanguage,
                        flagSize: 18,
                        flagBorderColor: widget.isShowSourceLanguageSelector
                            ? Theme.of(context).primaryColor
                            : null,
                        style: theme.typography.bodyMedium.copyWith(
                          color: widget.isShowSourceLanguageSelector
                              ? theme.colorScheme.primary
                              : null,
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.fastOutSlowIn,
                        transformAlignment: Alignment.center,
                        transform: Matrix4.rotationZ(
                          widget.isShowSourceLanguageSelector ? math.pi / 1 : 0,
                        ),
                        child: Container(
                          margin: EdgeInsets.zero,
                          child: Icon(
                            FluentIcons.chevron_down_20_regular,
                            size: 14,
                            color: widget.isShowSourceLanguageSelector
                                ? iconThemeData.color
                                : theme.typography.bodyMedium.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    widget.onToggleShowSourceLanguageSelector(
                      !widget.isShowSourceLanguageSelector,
                    );
                  },
                ),
                Button(
                  variant: ButtonVariant.plain,
                  // padding: EdgeInsets.zero,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.fastOutSlowIn,
                    transformAlignment: Alignment.center,
                    transform: Matrix4.rotationZ(
                      _isRotated ? math.pi / 1 : 0,
                    ),
                    child: Icon(
                      FluentIcons.arrow_swap_20_regular,
                      size: 20,
                      color: iconThemeData.color,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _isRotated = !_isRotated;
                    });
                    _handleChanged(
                      widget.targetLanguage,
                      widget.sourceLanguage,
                    );
                  },
                ),
                Button(
                  variant: ButtonVariant.plain,
                  // padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Row(
                    children: [
                      LanguageLabel(
                        widget.targetLanguage,
                        flagSize: 18,
                        flagBorderColor: widget.isShowTargetLanguageSelector
                            ? Theme.of(context).primaryColor
                            : null,
                        style: theme.typography.bodyMedium.copyWith(
                          color: widget.isShowTargetLanguageSelector
                              ? theme.colorScheme.primary
                              : null,
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.fastOutSlowIn,
                        transformAlignment: Alignment.center,
                        transform: Matrix4.rotationZ(
                          widget.isShowTargetLanguageSelector ? math.pi / 1 : 0,
                        ),
                        child: Container(
                          margin: EdgeInsets.zero,
                          child: Icon(
                            FluentIcons.chevron_down_20_regular,
                            size: 14,
                            color: widget.isShowTargetLanguageSelector
                                ? theme.colorScheme.primary
                                : theme.typography.bodyMedium.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    widget.onToggleShowTargetLanguageSelector(
                      !widget.isShowTargetLanguageSelector,
                    );
                  },
                ),
              ],
            ),
          ),
          if (widget.isShowSourceLanguageSelector ||
              widget.isShowTargetLanguageSelector)
            const Divider(),
          if (widget.isShowSourceLanguageSelector)
            AvailableLanguageSelector(
              value: widget.sourceLanguage,
              onChanged: (newLanguage) {
                _handleChanged(newLanguage, widget.targetLanguage);
              },
            ),
          if (widget.isShowTargetLanguageSelector)
            AvailableLanguageSelector(
              value: widget.targetLanguage,
              onChanged: (newLanguage) {
                _handleChanged(widget.sourceLanguage, newLanguage);
              },
            ),
        ],
      ),
    );
  }
}
