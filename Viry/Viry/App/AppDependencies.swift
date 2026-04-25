//
//  AppDependencies.swift
//  Viry
//
//  Application-wide service container.
//
//  Instantiated once at app launch and injected into the SwiftUI environment.
//  All long-lived services (AR coordinator, model loader, audio player) will
//  live here so SwiftUI views can resolve them through `@Environment` without
//  needing to thread them down manually.
//

import Foundation
import Observation

/// Application-wide dependency container.
///
/// Currently empty. Concrete services will be wired here as each phase lands:
/// - Phase 2: `ARCoordinating`
/// - Phase 3: `ModelLoading`
/// - Phase 6: `AudioPlaying`
@Observable
@MainActor
final class AppDependencies {

    init() {
        // TODO(Phase 2+): instantiate concrete services and assign them here.
    }
}
