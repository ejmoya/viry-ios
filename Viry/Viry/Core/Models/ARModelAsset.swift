//
//  ARModelAsset.swift
//  Viry
//
//  Metadata for a 3D model that has been imported into the app's sandbox.
//  Persisted as part of the user's model library.
//

import Foundation

/// A 3D model asset (`.usdz` or `.reality`) that the user has imported.
///
/// The actual file lives in the app's `Documents/Models/` directory. This
/// struct only carries metadata — load the entity at runtime through
/// `ModelLoading`.
struct ARModelAsset: Identifiable, Codable, Hashable {

    /// Stable, app-generated identifier. Survives renames of the file on disk.
    let id: UUID

    /// User-visible name. Defaults to the file's basename on import.
    var displayName: String

    /// Bookmark-style URL pointing into the app sandbox.
    var fileURL: URL

    /// When the user imported this model.
    var importedAt: Date

    /// Animations detected inside the model's RealityKit entity at import time.
    /// Refreshed if the source file is reloaded.
    var animations: [AnimationBinding]

    init(
        id: UUID = UUID(),
        displayName: String,
        fileURL: URL,
        importedAt: Date = .now,
        animations: [AnimationBinding] = []
    ) {
        self.id = id
        self.displayName = displayName
        self.fileURL = fileURL
        self.importedAt = importedAt
        self.animations = animations
    }
}
