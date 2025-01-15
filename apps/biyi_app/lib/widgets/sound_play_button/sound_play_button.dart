import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:biyi_app/utils/global_audio_player.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:reflect_ui/reflect_ui.dart';

const _kIconSize = 16.0;

class SoundPlayButton extends StatefulWidget {
  const SoundPlayButton({
    super.key,
    required this.audioUrl,
  });

  final String audioUrl;

  @override
  State<SoundPlayButton> createState() => _SoundPlayButtonState();
}

class _SoundPlayButtonState extends State<SoundPlayButton>
    with AudioPlayerListener {
  bool _playing = false;
  int _playingAnimImageIndex = 0;
  Timer? _playingAnimTimer;

  UrlSource? _audioSource;

  @override
  void initState() {
    globalAudioPlayer.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    globalAudioPlayer.removeListener(this);
    _stopPlayingAnimTimer();
    super.dispose();
  }

  void _startPlayingAnimTimer() {
    _stopPlayingAnimTimer();
    _playingAnimTimer = Timer.periodic(
      const Duration(milliseconds: 300),
      (Timer timer) {
        int nextIndex = _playingAnimImageIndex - 1;
        if (nextIndex < 0) {
          nextIndex = 2;
        }
        _playingAnimImageIndex = nextIndex;
        setState(() {});
      },
    );
    _playingAnimImageIndex = 2;
    if (mounted) setState(() {});
  }

  void _stopPlayingAnimTimer() {
    if (_playingAnimTimer != null && _playingAnimTimer!.isActive) {
      _playingAnimTimer?.cancel();
    }
    _playing = false;
    _playingAnimTimer = null;
    _playingAnimImageIndex = 0;
  }

  Future<void> _handleClickPlay() async {
    _audioSource ??= UrlSource(widget.audioUrl);
    await globalAudioPlayer.play(_audioSource!);
    _startPlayingAnimTimer();
  }

  Future<void> _handleClickStop() async {
    await globalAudioPlayer.stop();
    _stopPlayingAnimTimer();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: Button(
        variant: ButtonVariant.muted,
        // padding: EdgeInsets.zero,
        child: Center(
          child: IndexedStack(
            index: _playingAnimImageIndex,
            alignment: Alignment.center,
            children: const <Widget>[
              SizedBox(
                width: _kIconSize,
                height: _kIconSize,
                child: Icon(
                  FluentIcons.speaker_2_20_regular,
                  size: _kIconSize,
                ),
              ),
              SizedBox(
                width: _kIconSize,
                height: _kIconSize,
                child: Icon(
                  FluentIcons.speaker_1_20_regular,
                  size: _kIconSize,
                ),
              ),
              SizedBox(
                width: _kIconSize,
                height: _kIconSize,
                child: Icon(
                  FluentIcons.speaker_0_20_regular,
                  size: _kIconSize,
                ),
              ),
            ],
          ),
        ),
        onPressed: () {
          if (!_playing) {
            _handleClickPlay();
          } else {
            _handleClickStop();
          }
        },
      ),
    );
  }

  @override
  void onPlayerStateChanged(PlayerState state) {
    if (_audioSource?.url != globalAudioPlayer.source?.url) {
      _stopPlayingAnimTimer();
      if (mounted) setState(() {});
      return;
    }

    _playing = state == PlayerState.playing;

    if (_playing && !(_playingAnimTimer?.isActive ?? false)) {
      _startPlayingAnimTimer();
    } else if (!_playing && (_playingAnimTimer?.isActive ?? false)) {
      _stopPlayingAnimTimer();
    }
    if (mounted) setState(() {});
  }
}
