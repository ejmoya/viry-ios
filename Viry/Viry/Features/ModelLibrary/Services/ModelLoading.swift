//
//  ModelLoading.swift
//  Viry
//
//  Service abstraction for importing 3D model files into the app sandbox
//  and for inspecting their animations.
//

import Foundation

/// Loads `.usdz` / `.reality` files into the app's model library.
///
/// Implementations are responsible for:
/// 1. Copying the picked file into `Documents/Models/`.
/// 2. Loading it as a RealityKit entity asynchronously.
/// 3. Extracting `availableAnimations` and producing `AnimationBinding`s.
/// 4. Persisting the resulting `ARModelAsset` in the library index.
protocol ModelLoading: AnyObject {

    /// Imports a model from the given `URL` (typically returned by the document
    /// picker) and returns the persisted asset.
    func importModel(from url: URL) async throws -> ARModelAsset

    /// Removes the asset from the library and deletes its file from disk.
    func deleteModel(_ asset: ARModelAsset) throws

    /// All currently imported assets, sorted however the implementation prefers.
    func loadLibrary() throws -> [ARModelAsset]
}
