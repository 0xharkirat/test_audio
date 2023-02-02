import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PageManager {
  final buttonNotifier = ValueNotifier<ButtonState>(ButtonState.paused);

  static const url = 'https://live.sgpc.net:8443/;nocache=889869audio_file.mp3';

  late AudioPlayer _audioPlayer;

  PageManager(){
    _init();
  }

  void _init() async {
    _audioPlayer = AudioPlayer();
    await _audioPlayer.setUrl(url);

    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering){
        buttonNotifier.value = ButtonState.loading;
      }
      else if (!isPlaying){
        buttonNotifier.value = ButtonState.paused;
      }
      else {
        buttonNotifier.value = ButtonState.playing;
      }
    });
  }

  void play(){
    _audioPlayer.play();
  }

  void pause(){
    _audioPlayer.pause();
  }

  void dispose(){
    _audioPlayer.dispose();
  }

}

enum ButtonState {
  paused, playing, loading
}