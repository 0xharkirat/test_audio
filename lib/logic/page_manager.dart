import 'package:flutter/foundation.dart';
import 'package:test_audio/notifiers/play_button_notifier.dart';
import 'package:test_audio/notifiers/progress_notifier.dart';
import 'package:test_audio/services/playlist_repository.dart';

class PageManager {
  // Listeners: Updates going to the UI
  final currentSongTitleNotifier = ValueNotifier<String>('');
  final playlistNotifier = ValueNotifier<List<String>>([]);
  final progressNotifier = ProgressNotifier();
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final playButtonNotifier = PlayButtonNotifier();
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);

  // Events: Calls coming from the UI
  void init() {}
  void play() {}
  void pause() {}
  void seek(Duration position) {}
  void dispose() {}
}