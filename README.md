# ProgressIndicatorKit

A lightweight Swift package with a SwiftUI progress indicator: three bouncing dots, rotating status messages, and optional looping background audio.

## Features

- SwiftUI, iOS 15+
- Rotating status messages supplied through the `ProgressMessageProvider` protocol
- Optional looping sound, played off the main thread, bundled with the package
- Accessibility: VoiceOver label and message announcements, Reduce Motion, Low Power Mode, Dynamic Type
- Easy to use from SwiftUI or from UIKit through `UIHostingController`

## Installation

Add it with Swift Package Manager:

```swift
.package(url: "https://github.com/iossparkling/ProgressIndicatorKit.git", from: "1.1.0")
```

Then import it:

```swift
import ProgressIndicatorKit
```

## Usage

### Indicator only

```swift
struct ContentView: View {
    @State private var isLoading = true

    var body: some View {
        if isLoading {
            ProgressIndicatorView(
                messageProvider: DefaultProgressMessageProvider(
                    messages: ["Loading...", "Still working...", "Almost there..."]
                )
            )
        } else {
            Text("Loaded!")
        }
    }
}
```

`DefaultProgressMessageProvider()` with no arguments uses a short built-in list. An empty list is fine; the dots are shown without text.

### Indicator with sound

`ProgressIndicatorWrapper` plays a looping sound while it is on screen. Create the player once and keep it alive, for example in a view model, and pass it in:

```swift
final class LoadingViewModel: ObservableObject {
    let audioPlayer = BackgroundAudioPlayer()
}

struct LoadingView: View {
    @StateObject private var viewModel = LoadingViewModel()

    var body: some View {
        ProgressIndicatorWrapper(
            messageProvider: DefaultProgressMessageProvider(),
            audioPlayer: viewModel.audioPlayer,
            shouldPlayAudio: true
        )
    }
}
```

`audioURL` defaults to the sound bundled with the package (`ProgressIndicatorAudio.defaultURL`). Pass your own URL to use a different file. Changing `shouldPlayAudio` while the view is showing starts or stops the sound right away.

## Components

| Type | Purpose |
| --- | --- |
| `ProgressIndicatorView` | The animated dots and rotating message. |
| `ProgressIndicatorWrapper` | The indicator plus audio that follows the view's visibility. |
| `ProgressMessageProvider` | Protocol for supplying messages. |
| `DefaultProgressMessageProvider` | A fixed list of messages, with built-in defaults. |
| `BackgroundAudioPlayable` | Protocol for the audio player. Inject your own, or a mock in tests. |
| `BackgroundAudioPlayer` | Looping audio player built on `AVAudioPlayer`. |
| `ProgressIndicatorAudio` | Gives the URL of the bundled sound. |
| `Color(hex:)` | Creates a color from a hex string. |

## Background audio

`BackgroundAudioPlayer` does all audio-session and player work on a private serial queue, never on the main thread, so `play` and `stop` run in the order they were called. It also:

- mixes with other apps' audio by default, so music or a podcast keeps playing
- gives the audio session back on `stop()`, so other apps' audio can resume
- resumes after interruptions such as phone calls, and pauses when headphones are unplugged
- replaces the current sound if `play(from:)` is called again, instead of stacking players

To respect the silent switch, or to change mixing, choose the category yourself:

```swift
let player = BackgroundAudioPlayer(category: .ambient, options: [])
```

## Accessibility

- VoiceOver reads the current message, and announces each new one while VoiceOver is running.
- With Reduce Motion or Low Power Mode on, the dots stop hopping and only change color.
- Message text uses `.footnote`, so it follows Dynamic Type.

## Versioning

ProgressIndicatorKit follows semantic versioning. See [CHANGELOG.md](CHANGELOG.md).

## Author

Developed by Deltrin Sam. Part of the Sparkling Apps suite.

## License

This project is licensed under the MIT License.
