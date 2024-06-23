import 'package:biyi_app/states/settings.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:uni_platform/uni_platform.dart';

abstract mixin class ShortcutListener {
  void onShortcutKeyDownShowOrHide();
  void onShortcutKeyDownHide();
  void onShortcutKeyDownExtractFromScreenSelection();
  void onShortcutKeyDownExtractFromScreenCapture();
  void onShortcutKeyDownExtractFromClipboard();
  void onShortcutKeyDownTranslateInputContent();
  void onShortcutKeyDownSubmitWithMateEnter();
}

class ShortcutService {
  ShortcutService._();

  /// The shared instance of [ShortcutService].
  static final ShortcutService instance = ShortcutService._();

  ShortcutListener? _listener;

  void setListener(ShortcutListener? listener) {
    _listener = listener;
  }

  Future<void> start() async {
    final boundShortcuts = Settings.instance.boundShortcuts;

    // await hotKeyManager.unregisterAll();
    await hotKeyManager.register(
      boundShortcuts.inputSubmitWithMetaEnter,
      keyDownHandler: (_) {
        _listener?.onShortcutKeyDownSubmitWithMateEnter();
      },
    );
    await hotKeyManager.register(
      boundShortcuts.showOrHide,
      keyDownHandler: (_) {
        _listener?.onShortcutKeyDownShowOrHide();
      },
    );
    await hotKeyManager.register(
      boundShortcuts.hide,
      keyDownHandler: (_) {
        _listener?.onShortcutKeyDownHide();
      },
    );
    await hotKeyManager.register(
      boundShortcuts.extractFromScreenSelection,
      keyDownHandler: (_) {
        _listener?.onShortcutKeyDownExtractFromScreenSelection();
      },
    );
    if (!UniPlatform.isLinux) {
      await hotKeyManager.register(
        boundShortcuts.extractFromScreenCapture,
        keyDownHandler: (_) {
          _listener?.onShortcutKeyDownExtractFromScreenCapture();
        },
      );
    }
    await hotKeyManager.register(
      boundShortcuts.extractFromClipboard,
      keyDownHandler: (_) {
        _listener?.onShortcutKeyDownExtractFromClipboard();
      },
    );
    // if (!UniPlatform.isLinux) {
    //   await hotKeyManager.register(
    //     boundShortcuts.translateInputContent,
    //     keyDownHandler: (_) {
    //       _listener?.onShortcutKeyDownTranslateInputContent();
    //     },
    //   );
    // }
  }

  void stop() {
    hotKeyManager.unregisterAll();
  }
}
