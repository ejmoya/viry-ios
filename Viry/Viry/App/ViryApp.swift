//
//  ViryApp.swift
//  Viry
//
//  App entry point. Owns `AppDependencies` and injects them into the
//  SwiftUI environment so views and view models can resolve services.
//

import SwiftUI

@main
struct ViryApp: App {

    @State private var dependencies = AppDependencies()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(dependencies)
        }
    }
}
