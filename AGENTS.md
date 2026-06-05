# AGENTS.md

## Project Overview

`swiftBase` is a pure Swift utility package for shared macOS and iOS app development.

The package is intended to provide small, native, dependency-free building blocks for common app work:

- networking helpers
- DNS-over-HTTPS helpers
- SwiftUI UI helpers
- lightweight view models
- cache and storage helpers
- Foundation extensions
- app group helpers

The package should remain easy to import from both macOS and iOS targets.

## Design Principles

- Keep the package pure Swift and Apple-native. Do not add third-party dependencies unless the project owner explicitly approves it.
- Keep APIs small, practical, and easy to call from app code.
- Prefer simple namespace enums such as `myNet`, `myUI`, `myVM`, `myDOH`, and `myApp` for grouped utility APIs.
- Preserve existing public APIs unless a breaking change is explicitly approved.
- Favor compatibility over aggressive refactors. This package is a reusable base layer, so small public changes can affect many apps.
- Use Swift concurrency and actors where they simplify shared mutable state.
- Keep UI helpers SwiftUI-first when the API is meant to be shared by macOS and iOS.
- 所有代码注释、文档说明、开发说明都使用中文描述。
- 新增函数必须添加清晰的中文注释，说明函数用途、关键参数或重要行为。

## Platform Rules

`swiftBase` supports macOS and iOS.

Code that is available on both platforms may be exposed normally.

iOS-only APIs must not be visible when the package is compiled for macOS. They should be wrapped with platform checks such as:

```swift
#if os(iOS)
...
#endif
```

Do not provide macOS no-op shims for iOS-only APIs unless the project owner explicitly asks for that behavior. The preferred behavior is:

- iOS target: iOS-only API exists and can be called.
- macOS target: iOS-only API does not exist and cannot be referenced.

Examples of iOS-only areas:

- UIKit keyboard control
- UIKit haptic feedback
- APIs based on `UIApplication`, `UIResponder`, or `UIImpactFeedbackGenerator`

SwiftUI components such as loading views, toast views, sheet links, and navigation links should remain cross-platform when possible.

## App Group Notes

`myApp` contains App Group helpers.

App Groups are not inherently iOS-only. macOS apps can use them when the app has the proper sandbox and entitlement configuration.

However, App Group APIs may fail at runtime in command line tools, SwiftPM tests, or macOS apps without the required entitlements. Treat this as an environment and entitlement constraint, not a macOS compile-time incompatibility.

## Testing Principles

- Default tests should be deterministic and should not require public network access.
- Real network tests, DNS-over-HTTPS tests, or tests against production services should be treated as integration tests.
- Prefer pure unit tests for encoding, decoding, response parsing, cryptography round trips, date formatting, and cache behavior.
- When changing platform-specific code, verify macOS compilation with `swift test`.
- When changing iOS-only code, verify from an iOS target or simulator build when available.

## Development Workflow For AI Agents

Before editing code:

1. Read the relevant source files.
2. Identify whether the change affects public API.
3. If the change modifies package behavior or public API, list the planned changes and wait for user confirmation.

When editing code:

- Keep changes scoped to the confirmed task.
- Do not rewrite unrelated modules.
- Do not remove user changes.
- Prefer `apply_patch` for manual edits.
- Keep comments concise and useful.

After editing code:

- Run the smallest useful verification command.
- Report any test or build failures clearly.
- Distinguish code failures from environment or network failures.
