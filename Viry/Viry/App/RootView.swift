//
//  RootView.swift
//  Viry
//
//  Top-level view rendered inside the app's `WindowGroup`.
//
//  Currently a placeholder. Phase 2 will replace this with an `ARContainerView`
//  hosting the live camera feed, plus the controls overlay added in Phase 5.
//

import SwiftUI

struct RootView: View {

    @Environment(AppDependencies.self) private var dependencies

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "arkit")
                .font(.system(size: 72, weight: .light))
                .foregroundStyle(.tint)

            VStack(spacing: 8) {
                Text("Viry")
                    .font(.largeTitle.bold())
                Text("Augmented Reality model viewer")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }

            Text("Phase 1 scaffolding — AR scene lands in Phase 2")
                .font(.caption)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
                .padding(.top, 8)
        }
        .padding()
    }
}

#Preview {
    RootView()
        .environment(AppDependencies())
}
