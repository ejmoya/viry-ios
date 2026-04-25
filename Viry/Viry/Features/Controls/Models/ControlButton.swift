//
//  ControlButton.swift
//  Viry
//
//  A user-defined floating button that, when tapped while a model is anchored
//  in the AR scene, plays the bound animation and (optionally) the bound audio.
//

import CoreGraphics
import Foundation

/// One entry in the user's per-model control panel.
struct ControlButton: Identifiable, Codable, Hashable {

    let id: UUID

    /// Which `ARModelAsset` this button belongs to.
    var modelAssetId: UUID

    /// User-provided label shown on the button (English-only per project policy).
    var title: String

    /// `AnimationBinding.id` of the animation to play. Must reference an entry
    /// in the owning model's `animations` array.
    var animationId: String

    /// Optional `AudioBinding.id` for a sound effect played alongside the
    /// animation. Nil means animation-only.
    var audioBindingId: UUID?

    /// Optional custom position on screen, set when the user drags the button
    /// in edit mode. Nil means "use the default layout".
    var position: CGPoint?

    init(
        id: UUID = UUID(),
        modelAssetId: UUID,
        title: String,
        animationId: String,
        audioBindingId: UUID? = nil,
        position: CGPoint? = nil
    ) {
        self.id = id
        self.modelAssetId = modelAssetId
        self.title = title
        self.animationId = animationId
        self.audioBindingId = audioBindingId
        self.position = position
    }
}
