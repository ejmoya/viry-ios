//
//  AudioBinding.swift
//  Viry
//
//  Metadata for a user-imported sound effect file.
//

import Foundation

/// An audio file the user has imported and may attach to one or more
/// `ControlButton`s. The actual file lives in `Documents/Audio/`.
struct AudioBinding: Identifiable, Codable, Hashable {

    let id: UUID
    var displayName: String
    var fileURL: URL
    var importedAt: Date

    init(
        id: UUID = UUID(),
        displayName: String,
        fileURL: URL,
        importedAt: Date = .now
    ) {
        self.id = id
        self.displayName = displayName
        self.fileURL = fileURL
        self.importedAt = importedAt
    }
}
