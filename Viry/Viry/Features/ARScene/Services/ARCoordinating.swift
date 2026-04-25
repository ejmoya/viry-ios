//
//  ARCoordinating.swift
//  Viry
//
//  Service abstraction that owns the long-lived ARKit / RealityKit session.
//

import CoreGraphics
import Foundation

/// Orchestrates the AR scene: holds the active `ARView`, manages anchors, and
/// exposes high-level commands to the view model layer.
///
/// SwiftUI views never call this directly — they go through
/// `ARSessionViewModel`, which in turn talks to the coordinator. This keeps
/// ARKit / RealityKit imports out of the view layer entirely.
protocol ARCoordinating: AnyObject {

    /// Anchors a model in the scene at the surface hit by a raycast cast
    /// from the given screen point.
    func place(_ asset: ARModelAsset, at screenPoint: CGPoint) async throws

    /// Triggers an animation on the currently placed model and optionally an
    /// associated sound effect, sourced from a control button.
    func trigger(_ button: ControlButton) async throws

    /// Removes every anchor from the scene. The session itself keeps running.
    func clearScene()
}
