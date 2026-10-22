# Changelog

## 1.1.0

### Fixed
- Audio session and player calls no longer run on the main thread. This removes the
  "This method can lead to UI unresponsiveness if called on the main thread" warning.
- A `stop()` that arrived right after `play(from:)` could be lost, leaving the sound looping.
  Both now run in order on one serial queue.
- Calling `play(from:)` twice no longer stacks two players.
- `ProgressIndicatorView` no longer crashes when the provider returns no messages.
- `ProgressIndicatorWrapper` now reacts when `shouldPlayAudio` changes while it is on screen.
- The animation loop is now cancelled when the view disappears.
- `background.mp3` is now declared as a package resource, so it is actually bundled.

### Changed
- `BackgroundAudioPlayer` mixes with other apps' audio by default (`.playback` with `.mixWithOthers`).
  Previously it interrupted them. Pass `category:` and `options:` to the initializer to change this.
- `BackgroundAudioPlayer.stop()` deactivates the audio session so other apps' audio can resume.
- `DefaultProgressMessageProvider` is now `final`.
- `print` calls were replaced with `os.Logger`.

### Added
- `ProgressIndicatorAudio.defaultURL` for the bundled sound. `ProgressIndicatorWrapper`'s
  `audioURL` now defaults to it.
- `DefaultProgressMessageProvider()` now works without arguments.
- Interruption handling (resumes after phone calls) and pause on headphone unplug.
- Accessibility: VoiceOver label and message announcements, Reduce Motion and Low Power Mode support.
- Tests for message rotation, hex colors, playback control and the bundled resource.
- `.gitignore`, so `.DS_Store` and `xcuserdata` are no longer committed.

### Documentation
- README rewritten to match the actual API.
