//
//  BackgroundAudioPlayer.swift
//  ProgressIndicatorKit
//
//  Created by Deltrin Sam on 10/07/25.
//

import AVFoundation
import os

/// Loops an audio file. Everything that touches the audio session or the
/// player runs on one private serial queue, never on the main thread:
/// `setActive`, `AVAudioPlayer(data:)`, `prepareToPlay()` and `play()` all
/// wait on the system audio service, and iOS logs "This method can lead to
/// UI unresponsiveness if called on the main thread" when they run there.
///
/// By default the sound mixes with other apps' audio instead of interrupting
/// it, and `stop()` hands the audio session back so other apps can resume.
public final class BackgroundAudioPlayer: BackgroundAudioPlayable, @unchecked Sendable {

    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "ProgressIndicatorKit",
        category: "BackgroundAudio"
    )

    /// Serial, so `play` and `stop` always run in the order they were called.
    private let queue = DispatchQueue(
        label: "ProgressIndicatorKit.BackgroundAudioPlayer",
        qos: .userInitiated
    )

    private let category: AVAudioSession.Category
    private let categoryOptions: AVAudioSession.CategoryOptions

    // Everything below is only read or written on `queue`.
    private var player: AVAudioPlayer?
    private var isSessionActive = false
    private var observers: [NSObjectProtocol] = []

    /// - Parameters:
    ///   - category: Audio session category. Use `.ambient` if the sound should
    ///     respect the silent switch.
    ///   - options: Category options. The default mixes with other apps' audio.
    public init(
        category: AVAudioSession.Category = .playback,
        options: AVAudioSession.CategoryOptions = [.mixWithOthers]
    ) {
        self.category = category
        self.categoryOptions = options
    }

    deinit {
        for observer in observers {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    public func play(from url: URL) {
        queue.async { [weak self] in
            guard let self else { return }

            do {
                // Read into memory so the sound keeps playing even if the
                // file is moved or deleted afterwards. Done before touching
                // the session, so a bad file never activates it.
                let audioData = try Data(contentsOf: url)
                let newPlayer = try AVAudioPlayer(data: audioData)
                newPlayer.numberOfLoops = -1

                let session = AVAudioSession.sharedInstance()
                try session.setCategory(self.category, options: self.categoryOptions)
                try session.setActive(true)
                self.isSessionActive = true

                newPlayer.prepareToPlay()

                // A second play() replaces the first instead of stacking.
                self.player?.stop()
                self.player = newPlayer
                self.startObservingIfNeeded()
                newPlayer.play()

                Self.logger.debug("audio playback started")
            } catch {
                Self.logger.error("audio playback failed: \(error.localizedDescription, privacy: .public)")
                if self.player == nil {
                    self.deactivateSession()
                }
            }
        }
    }

    public func stop() {
        queue.async { [weak self] in
            guard let self else { return }

            self.player?.stop()
            self.player = nil
            self.stopObserving()
            self.deactivateSession()
        }
    }

    // MARK: - Session

    /// Lets other apps' audio resume. Does nothing if this player never activated the session.
    private func deactivateSession() {
        guard isSessionActive else { return }
        isSessionActive = false

        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            Self.logger.debug("audio session deactivation failed: \(error.localizedDescription, privacy: .public)")
        }
    }

    // MARK: - Interruptions and route changes

    private func startObservingIfNeeded() {
        guard observers.isEmpty else { return }

        let center = NotificationCenter.default
        let session = AVAudioSession.sharedInstance()

        // Values are pulled out of the notification before hopping to `queue`
        // so no non-Sendable `Notification` crosses threads.
        let interruption = center.addObserver(
            forName: AVAudioSession.interruptionNotification,
            object: session,
            queue: nil
        ) { [weak self] notification in
            guard let self else { return }
            let typeRaw = notification.userInfo?[AVAudioSessionInterruptionTypeKey] as? UInt
            let optionsRaw = notification.userInfo?[AVAudioSessionInterruptionOptionKey] as? UInt
            self.queue.async { [weak self] in
                self?.handleInterruption(typeRaw: typeRaw, optionsRaw: optionsRaw)
            }
        }

        let routeChange = center.addObserver(
            forName: AVAudioSession.routeChangeNotification,
            object: session,
            queue: nil
        ) { [weak self] notification in
            guard let self else { return }
            let reasonRaw = notification.userInfo?[AVAudioSessionRouteChangeReasonKey] as? UInt
            self.queue.async { [weak self] in
                self?.handleRouteChange(reasonRaw: reasonRaw)
            }
        }

        observers = [interruption, routeChange]
    }

    private func stopObserving() {
        for observer in observers {
            NotificationCenter.default.removeObserver(observer)
        }
        observers.removeAll()
    }

    /// Runs on `queue`. The system pauses the player when an interruption
    /// begins; this resumes it when the interruption ends and the system says it should.
    private func handleInterruption(typeRaw: UInt?, optionsRaw: UInt?) {
        guard let typeRaw,
              AVAudioSession.InterruptionType(rawValue: typeRaw) == .ended,
              let player else { return }

        let options = AVAudioSession.InterruptionOptions(rawValue: optionsRaw ?? 0)
        guard options.contains(.shouldResume) else { return }

        do {
            try AVAudioSession.sharedInstance().setActive(true)
            player.play()
        } catch {
            Self.logger.error("audio resume failed: \(error.localizedDescription, privacy: .public)")
        }
    }

    /// Runs on `queue`. Pauses when headphones or another output are unplugged,
    /// so the sound does not suddenly come out of the speaker.
    private func handleRouteChange(reasonRaw: UInt?) {
        guard let reasonRaw,
              AVAudioSession.RouteChangeReason(rawValue: reasonRaw) == .oldDeviceUnavailable else { return }

        player?.pause()
    }
}
