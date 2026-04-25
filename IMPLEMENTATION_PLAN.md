# Viry — iOS Implementation Plan

> **Audience:** future Claude sessions and any human collaborator.
> **Purpose:** an ordered, executable plan to deliver the Viry iOS app end-to-end.
> **Reminder:** every artifact produced under this plan must be in **English** (code, identifiers, UI strings, comments, docs). See `CLAUDE.md`.

The plan is organized into **8 phases**, each with concrete steps, deliverables, and acceptance criteria. Phases are intended to be executed in order. Within a phase, steps may be parallelized when noted.

---

## How to use this plan (for Claude)

1. At the start of each session, **read `CLAUDE.md` and this file** before doing anything else.
2. Identify the lowest-numbered phase that is not yet `[x] DONE`.
3. Pick the next unchecked step inside that phase and work it to completion.
4. When a step is done, **update its checkbox in this file in the same change**, with a one-line note pointing to the relevant commit / file.
5. If the plan needs to change, **edit the plan first**, explain why in a short note under the phase, then proceed.
6. Never skip the acceptance criteria — they exist so we know a phase is actually done.

Status legend: `[ ]` not started · `[~]` in progress · `[x]` done

---

## Phase 0 — Repository & Tooling Setup

**Goal:** a clean repo with documentation, conventions, and project scaffolding so that real work can start.

- [x] 0.1 Initial brief committed (`project-description.md`).
- [x] 0.2 `CLAUDE.md` written with project rules, stack, architecture and English-only mandate.
- [x] 0.3 `IMPLEMENTATION_PLAN.md` (this file) committed.
- [x] 0.4 Add `.gitignore` for Xcode/Swift (`xcuserdata/`, `*.xcworkspace/xcuserdata/`, `DerivedData/`, `.DS_Store`, `*.xcscmblueprint`, `*.xccheckout`, `Pods/`, `.swiftpm/`).
- [x] 0.5 Replace placeholder `README.md` with a short English overview pointing to `CLAUDE.md` and this plan.
- [x] 0.6 Create an Xcode project: name `Viry`, bundle id `emoya.Viry`, interface **SwiftUI**, lifecycle **SwiftUI App**, language **Swift**, testing system **Swift Testing + XCTest UI**. Deployment target was set by Xcode 26 to **iOS 26.4** (default); the plan originally targeted iOS 16.0 — see Open Questions below for the decision still pending.
- [x] 0.7 Commit the freshly generated Xcode project. *(commit `eb2a1bf`)*
- [x] 0.8 Configure Info.plist via `INFOPLIST_KEY_*` build settings (modern auto-generated Info.plist): added `INFOPLIST_KEY_NSCameraUsageDescription` and `INFOPLIST_KEY_UIRequiredDeviceCapabilities = arkit` to both Debug and Release configurations of the app target.
- [ ] 0.9 Add a SwiftLint config (optional but recommended) — only if no extra dependency burden is introduced (use a Build Phase script or skip).

**Acceptance:** repo opens in Xcode 15+, builds the empty SwiftUI app on iOS 16 simulator, prompts for camera permission text in English on a device.

---

## Phase 1 — Skeleton Architecture (MVVM scaffolding)

**Goal:** the empty, well-organized folder structure described in `CLAUDE.md` exists and compiles.

- [x] 1.1 Create the top-level groups in Xcode: `App`, `Features/ARScene`, `Features/ModelLibrary`, `Features/Controls`, `Features/Audio`, `Core/Models`, `Core/Persistence`, `Core/Extensions`, `Core/Utilities`, `Resources`. *(Xcode 16 uses `PBXFileSystemSynchronizedRootGroup`, so on-disk folders are auto-discovered — no pbxproj edits needed.)*
- [x] 1.2 Add `App/ViryApp.swift` (moved from project root) and `App/AppDependencies.swift` — `@Observable @MainActor` container injected via `.environment(_:)`.
- [x] 1.3 Define empty protocols for each service so views/view models can depend on abstractions: `ModelLoading`, `AudioPlaying`, `ARCoordinating`.
- [x] 1.4 Define empty Codable model types (`ARModelAsset`, `ControlButton`, `AnimationBinding`, `AudioBinding`) with TODOs for fields filled in later phases.
- [x] 1.5 Add a `RootView` that just shows a placeholder "Viry" screen, wired into `ViryApp`.

**Acceptance:** project compiles, all files are in their target folders, no dead references.

---

## Phase 2 — AR Foundation: Camera + ARView + plane detection

**Goal:** open the app → see the live camera feed with ARKit world tracking + horizontal & vertical plane detection.

- [ ] 2.1 Implement `ARContainerView: UIViewRepresentable` that owns an `ARView`.
  - Configure `ARWorldTrackingConfiguration`.
  - Set `planeDetection = [.horizontal, .vertical]`.
  - Enable scene understanding (mesh / occlusion) only on capable devices, behind a feature flag.
- [ ] 2.2 Implement `ARSessionViewModel: ObservableObject` exposing `@Published` state for tracking quality, surface-found, and errors.
- [ ] 2.3 Implement an `ARCoordinator` (NSObject) that conforms to `ARSessionDelegate` and forwards relevant events to the ViewModel via Combine or `async` streams.
- [ ] 2.4 Add a minimal HUD overlay (SwiftUI) that shows tracking state ("Move your phone slowly", "Surface found", etc.), all strings in English.
- [ ] 2.5 Handle camera permission states explicitly: not-determined, denied, restricted, authorized. Show a friendly English message + "Open Settings" button when denied.
- [ ] 2.6 Add a small visual indicator (debug-only, gated by `#if DEBUG`) for detected planes.

**Acceptance:** on a real device, opening the app asks for camera permission once, then shows the camera feed. The HUD reports tracking state and confirms when a plane is found. Works in portrait, no crashes when backgrounding/foregrounding.

> ⚠️ AR cannot run on the iOS Simulator. Acceptance must be validated on a real iOS device.

---

## Phase 3 — Model Import (Document Picker → RealityKit Entity)

**Goal:** the user can pick a `.usdz` or `.reality` file from Files / iCloud Drive, and the app imports it into local app storage and parses its animations.

- [ ] 3.1 Wrap `UIDocumentPickerViewController` in `DocumentPickerView: UIViewControllerRepresentable`. Allowed UTIs: `usdz` (`com.pixar.universal-scene-description-mobile`) and `realityFile` (`com.apple.reality`).
- [ ] 3.2 Implement `ModelLoader` service:
  - Copies the picked file into the app's `Documents/Models/` directory.
  - Returns an `ARModelAsset` (id, displayName, fileURL, importedAt).
  - Loads the entity via `Entity.loadAsync(contentsOf:)` (or `ModelEntity.loadAsync`) and inspects `availableAnimations`.
- [ ] 3.3 Define `AnimationDescriptor` (id, name, duration) extracted from each `AnimationResource`. If an animation has no name, fall back to "Animation 1", "Animation 2", … in English.
- [ ] 3.4 Build `ModelLibraryViewModel` exposing the list of imported `ARModelAsset` items + actions: `import()`, `delete(_:)`, `select(_:)`.
- [ ] 3.5 Build `ModelLibraryView` (SwiftUI list) with rows showing model name, thumbnail (use a default 3D-cube SF Symbol for v1), and detected animation count.
- [ ] 3.6 Persist the asset library: write a JSON index at `Documents/Models/library.json` describing each imported asset.

**Acceptance:** import a sample `.usdz` (e.g. an animated cat). It appears in the library with the correct number of animations listed. Restarting the app preserves the library.

---

## Phase 4 — AR Placement (tap-to-anchor)

**Goal:** select a model from the library, tap a real-world surface, and see the model anchored there at real-world scale.

- [ ] 4.1 Add a "Place" mode to `ARSessionViewModel` with state machine: `idle → searching → readyToPlace → placed`.
- [ ] 4.2 Add a tap gesture (`UITapGestureRecognizer` on the `ARView`) handled by the coordinator.
- [ ] 4.3 On tap, perform a raycast: `arView.raycast(from:allowing:.estimatedPlane, alignment:.any)`. Use the first result to create an `AnchorEntity(world: result.worldTransform)`.
- [ ] 4.4 Clone the loaded `Entity` (`entity.clone(recursive: true)`) and add it to the anchor. Add the anchor to the scene.
- [ ] 4.5 Provide visual feedback: a subtle "ground reticle" (a thin disc) that follows the reticle while in `readyToPlace`, hidden afterwards.
- [ ] 4.6 Provide controls to: re-place (remove current anchor and re-enter placement), reset session, switch active model.
- [ ] 4.7 Apply sensible default scale — if the model is huge, normalize bounds to ~30 cm largest dimension. Make this configurable per asset later.

**Acceptance:** on a real device, the user can pick a model, see a reticle on detected surfaces, tap to drop the model in the world. The model stays anchored as the user walks around.

---

## Phase 5 — Dynamic Control UI

**Goal:** the user can create, edit and delete floating SwiftUI buttons that are bound to specific animations of the active model.

- [ ] 5.1 Define the persisted model `ControlButton`:
  ```
  id: UUID
  modelAssetId: UUID            // which ARModelAsset it belongs to
  title: String                 // user-provided label, English
  animationId: String           // matches AnimationDescriptor.id
  audioBindingId: UUID?         // filled in Phase 6
  position: CGPoint?            // optional custom position on screen
  ```
- [ ] 5.2 Build `ControlsViewModel`: loads/saves the control set per model from `library.json` (or a sibling `controls.json`).
- [ ] 5.3 Build `ControlOverlayView`: a SwiftUI overlay above `ARContainerView` rendering the user's buttons. Default layout: bottom-anchored horizontal scroll. Optional drag-to-reposition gesture in edit mode.
- [ ] 5.4 Build `ControlEditorView`:
  - List existing buttons.
  - Add a button: enter title (English) + pick one of the model's available animations from a `Picker`.
  - Edit / delete a button.
- [ ] 5.5 Add an "Edit" toggle to switch between play mode (buttons trigger animations) and edit mode (long-press to drag, tap opens editor).
- [ ] 5.6 Validate: cannot save a button with empty title, must reference a valid `animationId`, prevent duplicate titles per model (warn, don't block).

**Acceptance:** user can add a button "Jump", choose any detected animation, see the button on the AR overlay, and persist it across launches.

---

## Phase 6 — Animation + Audio Playback

**Goal:** tapping a control button plays the bound animation on the model and a synchronized sound effect.

- [ ] 6.1 Animation playback service: given an `Entity` and an `animationId`, look up the `AnimationResource` and call `entity.playAnimation(_, transitionDuration:0.1, startsPaused:false)`. Handle missing animations gracefully (toast in English).
- [ ] 6.2 Audio import: extend the document picker to allow audio types (`public.audio` — `mp3`, `wav`, `m4a`, `caf`). Copy into `Documents/Audio/` and create `AudioBinding(id, fileURL, displayName)`.
- [ ] 6.3 Audio attachment: extend `ControlEditorView` so each button can optionally pick an `AudioBinding`.
- [ ] 6.4 Implement `AudioPlayer` service with two backends behind the same protocol:
  - **AVFoundation** (`AVAudioPlayer`) — simple, non-spatial.
  - **RealityKit spatial** (`AudioFileResource` + `entity.playAudio(_)`) — positioned at the entity.
  - Default to spatial; fall back to AVFoundation if the file fails to load as `AudioFileResource`.
- [ ] 6.5 Sync animation + audio: trigger both in the same call site (same dispatch frame). Document any observed offset and add a per-button `audioOffset: TimeInterval` if needed.
- [ ] 6.6 Configure `AVAudioSession` (`.playback`, `.default`, mixWithOthers as appropriate).

**Acceptance:** tapping "Jump" on the cat model in AR plays the jump animation and plays the chosen sound at the same time. Multiple rapid taps don't crash; concurrent sounds either layer or interrupt depending on a documented policy.

---

## Phase 7 — Polish, Edge Cases, and QA

**Goal:** the app is presentable end-to-end and resilient to common failures.

- [ ] 7.1 Empty states (no models imported, no animations detected, no controls created) — all in English, with a clear primary action button.
- [ ] 7.2 Error handling: corrupt/unsupported file, raycast failure, missing camera permission, low-memory warnings.
- [ ] 7.3 Localization scaffolding: even if only English is shipped, route every user-facing string through `LocalizedStringKey` / `String(localized:)` so future localization is cheap. The English `Localizable.strings` file is the source of truth.
- [ ] 7.4 Accessibility: VoiceOver labels on controls, Dynamic Type for text, sufficient contrast for HUD.
- [ ] 7.5 Performance pass: limit anchored models to 1 at a time in v1, cap animation concurrency, monitor `ARView` frame rate.
- [ ] 7.6 App icon, launch screen, default tinting.
- [ ] 7.7 Manual test pass on a real device against the user-flow checklist (see Section "Definition of Done").
- [ ] 7.8 (Optional) Unit tests for pure types: `ModelLoader` parsing logic, persistence round-trip, `AnimationDescriptor` mapping.

**Acceptance:** all items in the user flow checklist below pass on a real device.

---

## Phase 8 — Release Prep (optional but recommended)

- [ ] 8.1 Bump bundle version & build number; tag a release commit.
- [ ] 8.2 Write release notes (English).
- [ ] 8.3 Capture demo screen recordings.
- [ ] 8.4 Distribute via TestFlight to selected testers.

---

## Definition of Done — User-Flow Checklist

These mirror the brief in `project-description.md`. Each must pass on a real device.

1. Launch Viry on a real iPhone → camera permission requested in English → granted.
2. From an empty library, import an animated `.usdz` (e.g. cat) from the Files app.
3. The model appears in the library with the correct list of detected animations.
4. Select the model → enter AR → move the phone → see plane detection feedback.
5. Tap a real-world surface → the model is anchored in the world at a sensible scale.
6. Open the controls editor → add a button "Jump" → bind it to the jump animation → attach an audio file.
7. Return to AR → tap "Jump" → animation plays smoothly **and** sound plays simultaneously.
8. Background the app and reopen → library and controls are preserved.

---

## Open Questions (decide before starting Phase 3)

- **Deployment target:** ✅ Resolved on 2026-04-24. Lowered from Xcode's default 26.4 to **iOS 17.0** after a "iOS version doesn't match deployment target" error appeared running on iPhone 15 Pro (on iOS 26.3.1). iOS 17.0 covers iPhone XS+ (2018), unlocks SwiftData & Observation, and avoids forcing users to be on the absolute latest iOS.
- Persistence: stay with JSON files or move to **SwiftData** once ready? Default: JSON for v1, revisit at end of Phase 5.
- Bundle id is `emoya.Viry` (set during Phase 0.6). Team `6U4LAWYAFL` is configured.
- Do we ship a sample `.usdz` inside the app for first-run delight? Default: yes, ship one royalty-free sample.

These are not blockers for Phases 0–2.

---

## Change Log

- 2026-04-24 — Plan created (Phases 0–8 drafted).
