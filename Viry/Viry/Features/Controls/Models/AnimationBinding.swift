//
//  AnimationBinding.swift
//  Viry
//
//  Lightweight, codable representation of an animation discovered inside
//  a RealityKit `Entity`. Used both by `ARModelAsset` (catalog of available
//  animations) and by `ControlButton` (which animation the button triggers).
//

import Foundation

/// A reference to a single animation inside a loaded RealityKit entity.
struct AnimationBinding: Identifiable, Codable, Hashable {

    /// Animation identifier as reported by RealityKit, or a synthetic
    /// fallback like "Animation 1" when the source clip has no name.
    let id: String

    /// User-visible label. Equal to `id` unless overridden by the user.
    var displayName: String

    /// Length of the clip in seconds, captured at import time.
    var duration: TimeInterval

    init(id: String, displayName: String? = nil, duration: TimeInterval = 0) {
        self.id = id
        self.displayName = displayName ?? id
        self.duration = duration
    }
}
