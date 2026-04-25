//
//  AudioPlaying.swift
//  Viry
//
//  Service abstraction for playing audio files attached to control buttons.
//

import Foundation

/// Plays sound effects bound to user-defined control buttons.
///
/// Concrete implementations may use `AVAudioPlayer` for simple non-spatial
/// playback or RealityKit's `AudioFileResource` + `entity.playAudio(_:)` for
/// audio anchored to the 3D model in the AR scene.
protocol AudioPlaying: AnyObject {

    /// Starts playback of the given audio binding. Returns immediately;
    /// playback continues asynchronously.
    func play(_ binding: AudioBinding) async throws

    /// Stops every currently active sound.
    func stopAll()
}
