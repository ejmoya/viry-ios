# Viry

**Viry** is a native iOS app that turns any `.usdz` or `.reality` 3D model into an interactive Augmented Reality experience. Users import a model, anchor it in their real-world environment through the camera, and build a dynamic UI of floating buttons that trigger model animations with synchronized sound effects — no code required.

## Status

Early development — see [`IMPLEMENTATION_PLAN.md`](./IMPLEMENTATION_PLAN.md) for the phased delivery plan.

## Tech Stack

- **Platform:** iOS 17.0+ (native)
- **Language:** Swift 5.9+
- **UI:** SwiftUI
- **AR / 3D:** ARKit + RealityKit
- **Architecture:** MVVM
- **Tooling:** Xcode 15+

No third-party dependencies.

## Requirements

- A real iOS device (ARKit does **not** run in the Simulator). Tested on iPhone 15 Pro.
- Xcode 15 or newer, macOS Ventura or newer.
- An Apple ID added to Xcode for code signing (free tier is enough for on-device testing).

## Getting Started

1. Clone the repo.
2. Open `Viry.xcodeproj` (or `Viry/Viry.xcodeproj` depending on layout) in Xcode.
3. Select your connected iPhone as the run destination.
4. Press ⌘R. On first install, trust the developer certificate on the device under `Settings → General → VPN & Device Management`.

## Documentation

- [`CLAUDE.md`](./CLAUDE.md) — project rules, architecture, conventions, and working agreements (the source of truth).
- [`IMPLEMENTATION_PLAN.md`](./IMPLEMENTATION_PLAN.md) — ordered, phased implementation plan with acceptance criteria.
- [`project-description.md`](./project-description.md) — original project brief.

## Language Policy

All source code, identifiers, comments, UI strings, and documentation in this repository are written in **English**. See `CLAUDE.md §2.1` for the full policy.
