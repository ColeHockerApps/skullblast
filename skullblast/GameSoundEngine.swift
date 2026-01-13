import AVFoundation
import Combine
import Foundation

@MainActor
final class GameSoundEngine: ObservableObject {

    @Published var isEnabled: Bool = true
    @Published var musicEnabled: Bool = true
    @Published var musicVolume: Float = 0.55
    @Published var sfxVolume: Float = 0.9

    private var sfxPlayers: [String: AVAudioPlayer] = [:]
    private var musicPlayer: AVAudioPlayer?

    private var session: AVAudioSession { AVAudioSession.sharedInstance() }

    init() {
        configureSession()
    }

    func configureSession() {
        do {
            try session.setCategory(.ambient, mode: .default, options: [.mixWithOthers])
            try session.setActive(true, options: [])
        } catch {
            // Intentionally silent: keep app stable even if audio session fails.
        }
    }

    func preloadSFX(names: [String], ext: String = "mp3") {
        for n in names {
            _ = loadSFX(name: n, ext: ext)
        }
    }

    func playSFX(_ name: String, ext: String = "mp3", volume: Float? = nil) {
        guard isEnabled else { return }

        let player = loadSFX(name: name, ext: ext)
        player?.currentTime = 0
        player?.volume = clamp(volume ?? sfxVolume)
        player?.prepareToPlay()
        player?.play()
    }

    func setMusic(resource name: String, ext: String = "mp3", loop: Bool = true) {
        stopMusic()

        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
            return
        }

        do {
            let p = try AVAudioPlayer(contentsOf: url)
            p.numberOfLoops = loop ? -1 : 0
            p.volume = clamp(musicVolume)
            p.prepareToPlay()
            musicPlayer = p
        } catch {
            musicPlayer = nil
        }
    }

    func playMusic() {
        guard musicEnabled else { return }
        guard let p = musicPlayer else { return }
        p.volume = clamp(musicVolume)
        if p.isPlaying == false {
            p.play()
        }
    }

    func stopMusic() {
        musicPlayer?.stop()
        musicPlayer = nil
    }

    func pauseMusic() {
        musicPlayer?.pause()
    }

    func updateVolumes(music: Float? = nil, sfx: Float? = nil) {
        if let music {
            musicVolume = clamp(music)
            musicPlayer?.volume = clamp(musicVolume)
        }
        if let sfx {
            sfxVolume = clamp(sfx)
        }
    }

    func setEnabled(_ value: Bool) {
        isEnabled = value
        if value == false {
            pauseMusic()
        }
    }

    func setMusicEnabled(_ value: Bool) {
        musicEnabled = value
        if value {
            playMusic()
        } else {
            pauseMusic()
        }
    }

    private func loadSFX(name: String, ext: String) -> AVAudioPlayer? {
        if let existing = sfxPlayers[name] {
            return existing
        }

        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
            return nil
        }

        do {
            let p = try AVAudioPlayer(contentsOf: url)
            p.volume = clamp(sfxVolume)
            p.prepareToPlay()
            sfxPlayers[name] = p
            return p
        } catch {
            return nil
        }
    }

    private func clamp(_ v: Float) -> Float {
        min(1.0, max(0.0, v))
    }
}
