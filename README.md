📦 ProgressIndicatorKit

ProgressIndicatorKit is a lightweight Swift package that provides a customizable SwiftUI-based progress indicator with optional background audio and dynamic progress messages — ideal for showing task progress in an elegant, accessible way.


✨ Features

✅ Fully SwiftUI-based, supports iOS 15+

🔊 Optional background audio playback during progress

💬 Dependency-injected dynamic progress messages

🌀 Smooth animations powered by withAnimation and TimelineView

♿ Accessibility-friendly: VoiceOver announcements supported

🧩 Easily integrable into existing UIKit or SwiftUI projects


🛠 Installation

Add it through Swift Package Manager:

.package(url: "https://github.com/iossparkling/ProgressIndicatorKit.git", from: "1.0.0")


Then import it in your Swift code:

import ProgressIndicatorKit

🧰 Usage Example

    @State private var isLoading = true

    var body: some View {
        VStack {
            if isLoading {
                ProgressIndicatorView(
                    messageProvider: DefaultProgressMessageProvider(),
                    showBackgroundAudio: true
                )
            } else {
                Text("Loaded!")
            }
        }
    }


🧩 Components Overview

ProgressIndicatorView	- The main SwiftUI view showing the animated progress indicator.

ProgressIndicatorWrapper	- A helper container that can overlay any existing SwiftUI view.

ProgressMessageProvider	- Protocol for injecting dynamic status messages.

BackgroundAudioPlayer	- Service that handles optional looping audio playback.

Color+Hex	- Utility extension for color initialization.


🎧 Background Audio

To include audio playback, ensure your target has:

A valid .mp3 resource included (e.g. background.mp3)

The service BackgroundAudioPlayer initialized correctly.

Example:

let audioPlayer = BackgroundAudioPlayer.shared
audioPlayer.play()


🏷 Versioning

ProgressIndicatorKit follows semantic versioning (e.g. MAJOR.MINOR.PATCH).


🧑‍💻 Author

Developed by Deltrin Sam

Part of the Sparkling Apps suite.


📄 License

This project is licensed under the MIT License.
