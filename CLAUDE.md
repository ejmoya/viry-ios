# CLAUDE.md

This file provides guidance to Claude (and future AI assistants) when working with the **Viry** iOS codebase.

---

## 1. Project Overview

**Viry** is a native iOS application that lets users import their own 3D models, render them in the real world through Augmented Reality, and build a dynamic UI of buttons that trigger model animations together with synchronized sound effects.

Core value proposition: turn any `.usdz` / `.reality` asset into an interactive AR experience without writing code.

---

## 2. Critical Development Rules

### 2.1 Language: English Only (non-negotiable)

Absolutely **everything** in this repository must be written in **English**:

- Source code (Swift files, types, functions, variables, constants)
- File names and folder names
- Comments and inline documentation
- Commit messages, branch names, PR titles
- User-facing UI strings (labels, buttons, alerts, errors)
- Asset names and identifiers
- Technical documentation (`README.md`, `CLAUDE.md`, ADRs, etc.)
- Any persisted data keys (UserDefaults, Core Data attributes, JSON keys)

The user (project owner) writes prompts in Spanish, but **every artifact produced for the project must be in English**. This is the single most important rule of the project.

### 2.2 No premature dependencies

Stick to Apple's first-party frameworks unless the user explicitly approves a third-party library. The whole project is designed around the native Apple stack.

---

## 3. Tech Stack

| Concern              | Technology                                                       |
| -------------------- | ---------------------------------------------------------------- |
| Platform             | iOS 17.0+ (native)                                               |
| Language             | Swift 5.9+                                                       |
| UI Framework         | SwiftUI                                                          |
| AR Tracking          | ARKit (World Tracking, plane detection — horizontal & vertical)  |
| 3D Rendering         | RealityKit (`ARView`, `Entity`, `AnchorEntity`, `AnimationResource`) |
| Audio                | RealityKit spatial audio (`AudioFileResource`) and/or AVFoundation |
| File Picking         | `UIDocumentPickerViewController` (wrapped via `UIViewControllerRepresentable`) |
| Persistence          | `FileManager` + app sandbox; metadata via `Codable` JSON or SwiftData (TBD) |
| Architecture         | MVVM (Model — ViewModel — View) with strict separation between SwiftUI views and AR session logic |
| Concurrency          | Swift Concurrency (`async/await`, `@MainActor`)                  |
| Min Xcode            | Xcode 15+                                                        |

---

## 4. Architecture (MVVM)

```
┌─────────────────────────────────────────────────────────────┐
│                          Views (SwiftUI)                    │
│  ContentView · ARContainerView · ControlOverlayView · …     │
└──────────────────┬──────────────────────────────────────────┘
                   │ binds to
                   ▼
┌─────────────────────────────────────────────────────────────┐
│                       ViewModels (@MainActor)               │
│  ARSessionViewModel · ModelLibraryViewModel · …             │
└──────────────────┬──────────────────────────────────────────┘
                   │ orchestrates
                   ▼
┌─────────────────────────────────────────────────────────────┐
│                           Services                          │
│  ModelLoader · AnimationCatalog · AudioPlayer · ARCoordinator│
└──────────────────┬──────────────────────────────────────────┘
                   │ produces / consumes
                   ▼
┌─────────────────────────────────────────────────────────────┐
│                            Models                           │
│  ARModelAsset · AnimationBinding · ControlButton · …        │
└─────────────────────────────────────────────────────────────┘
```

Key boundaries:

- **SwiftUI Views never touch ARKit/RealityKit directly.** They go through a ViewModel.
- The `ARView` is wrapped in a `UIViewRepresentable` (`ARContainerView`) that exposes a coordinator. The coordinator forwards taps and AR session events to the ViewModel.
- Long-lived AR state (the active `ARView`, anchors, loaded entities) lives in a service (e.g. `ARCoordinator`) injected into the ViewModel — not in SwiftUI `@State`.

---

## 5. Suggested Folder Layout

```
Viry/
├── Viry.xcodeproj
├── Viry/
│   ├── App/
│   │   ├── ViryApp.swift
│   │   └── AppDependencies.swift
│   ├── Features/
│   │   ├── ARScene/
│   │   │   ├── Views/         (ARContainerView, ARSceneView)
│   │   │   ├── ViewModels/    (ARSessionViewModel)
│   │   │   └── Services/      (ARCoordinator, RaycastService)
│   │   ├── ModelLibrary/
│   │   │   ├── Views/
│   │   │   ├── ViewModels/
│   │   │   └── Services/      (ModelLoader, DocumentPicker)
│   │   ├── Controls/
│   │   │   ├── Views/         (ControlOverlayView, ControlEditorView)
│   │   │   ├── ViewModels/    (ControlsViewModel)
│   │   │   └── Models/        (ControlButton, AnimationBinding)
│   │   └── Audio/
│   │       └── Services/      (AudioPlayer, AudioLibrary)
│   ├── Core/
│   │   ├── Models/            (ARModelAsset, …)
│   │   ├── Persistence/       (AssetStore, ConfigStore)
│   │   ├── Extensions/
│   │   └── Utilities/
│   └── Resources/
│       ├── Assets.xcassets
│       ├── SampleModels/      (e.g. cat.usdz for testing)
│       └── Localizable.strings (English source of truth)
└── ViryTests/
```

---

## 6. Required Capabilities & Info.plist Keys

- `NSCameraUsageDescription` — required for ARKit. Copy in English, e.g. *"Viry uses the camera to place 3D models in your real environment."*
- `NSMicrophoneUsageDescription` — only if microphone is ever used (likely no).
- `UIRequiredDeviceCapabilities`: include `arkit`.
- `UISupportedInterfaceOrientations` — start with portrait; AR works in others, but design for portrait first.
- `UIFileSharingEnabled` / `LSSupportsOpeningDocumentsInPlace` if we expose imported assets via the Files app (TBD).

---

## 7. Naming Conventions

- **Types:** `UpperCamelCase` (`ARSessionViewModel`, `ControlButton`).
- **Functions / properties:** `lowerCamelCase` (`loadModel(from:)`, `availableAnimations`).
- **Files:** match the primary type they declare (`ARSessionViewModel.swift`).
- **SwiftUI views:** suffix with `View` (`ControlOverlayView`).
- **ViewModels:** suffix with `ViewModel`.
- **Services:** noun describing the responsibility (`ModelLoader`, `AudioPlayer`).
- **Acronyms:** keep `AR`, `URL`, `ID` uppercase (`arViewModel` is fine for a parameter, but the type is `ARSessionViewModel`).

---

## 8. Working Agreements for Claude

When asked to make changes, Claude should:

1. **Re-read this file and `IMPLEMENTATION_PLAN.md`** at the start of each session.
2. **Default to English** for everything written into the repo, even if the user's prompt is in Spanish.
3. **Respect the MVVM split** — never embed RealityKit code directly inside a SwiftUI `View`'s body.
4. **Keep ARKit/RealityKit isolated** behind a service that can be unit-tested or mocked.
5. **Follow the implementation plan in order.** If a step needs to change, update the plan first and explain why.
6. **Test on-device assumptions explicitly** — call out anything that requires a real device (AR cannot run in the iOS Simulator).
7. **Do not introduce third-party dependencies** without explicit approval.
8. **Prefer small, reviewable diffs** over large rewrites. Provide brief PR-style summaries.

---

## 9. Out of Scope (for the iOS phase)

- Backend / cloud sync of models or configurations.
- Marketplace or sharing flows.
- Android or visionOS targets.
- Generative 3D (creating models from prompts).
- Multi-user collaborative AR.

These may come in later phases but should not influence the iOS phase architecture.

---

## 10. Glossary

- **`ARView`** — RealityKit view that hosts the AR session and renders entities.
- **`Entity`** — a node in the RealityKit scene graph; a loaded `.usdz` becomes an `Entity`.
- **`AnchorEntity`** — an entity that anchors child entities to a real-world position.
- **`AnimationResource`** — a playable animation clip extracted from a model's `availableAnimations`.
- **Raycast** — projecting a ray from a screen point into the AR world to find a real-world surface to place an anchor on.
- **Control button** — a user-defined SwiftUI button that, when tapped, plays a chosen animation + audio on the active model.

---

## 11. References

- See `project-description.md` for the original (Spanish) project brief.
- See `IMPLEMENTATION_PLAN.md` for the ordered, step-by-step delivery plan.
