# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Lazx is a lightweight Flutter state management library based on the MVVM design pattern. It provides reactive data containers with built-in state tracking (Initial/Loading/Success/Error) and widget builders for UI binding.

**Current version**: 1.1.5

## Common Commands

```bash
# Install dependencies
flutter pub get

# Run tests
flutter test

# Run tests with coverage
flutter test --coverage

# Static analysis
dart analyze --no-fatal-warnings

# Run a single test file
flutter test test/lazx_data_test.dart
```

## Architecture

### Core Data Layer

- **LazxData<T>** - Reactive data container with value + state (LxState). Primary class for UI-bound data
- **LazxObserver<T>** - Data-only container without state tracking. Used in managers/repositories
- **LazxState** - State-only container (no value). For operations that only need state signals

All reactive classes use RxDart BehaviorSubject internally.

### State Model (LxState)

Every LazxData operates with 4 states:
- `LxState.Initial` - Default state before any operation
- `LxState.Loading` - Active operation in progress
- `LxState.Success` - Operation completed successfully
- `LxState.Error` - Operation failed

### ViewModel Layer

- **LazxViewModel** - Base class for screen business logic. Holds LazxData instances
  - Must override `props` getter to declare all reactive properties for auto-disposal
  - `init()` called when view is created, `dispose()` called when view is destroyed

- **LazxManager** - Singleton base for app-wide state. Uses LazxObserver instead of LazxData
  - Connected to LazxApp lifecycle for proper disposal

### View Layer

- **LazxView<T extends LazxViewModel>** - Base screen widget
  - Override `getViewModel()` to provide ViewModel instance
  - Override `build(context, viewModel)` to build UI with ViewModel access
  - Uses Provider internally for ViewModel injection

- **LazxApp** - Root application widget that manages LazxManager lifecycle

### Widget Builders

| Builder | Purpose |
|---------|---------|
| `LazxBuilder<T>` | Rebuilds on value changes only (ignores state) |
| `LazxStateBuilder<T>` | Provides `initial/loading/success/error` builder functions |
| `LazxDataBuilder<T>` | Uses a `LazxStateWidget` for cleaner separation |
| `LazxMultiBuilder` | Listens to multiple LazxData streams simultaneously |

### Utility Classes

- **LxResponse<T>** - API response wrapper with `success`, `data`, `error` fields
- **LazxListener** - Non-UI callback listener for state changes (side effects)
- **ViewModelProvider** - Access ViewModel from child widgets: `viewModel<T>(context)`

## Project Structure

```
lib/
├── lazx.dart              # Main exports
└── src/
    ├── lazx_data.dart     # Core reactive data
    ├── lazx_observer.dart # State-less observer
    ├── lazx_state.dart    # Value-less state
    ├── lazx_view_model.dart
    ├── lazx_manager.dart
    ├── lazx_view.dart
    └── widget/            # All UI builders

test/                      # Comprehensive tests for all classes
demos/                     # 3 demo applications
```

## Commit Style

Use gitmoji prefixes:
- ✨ (`:sparkles:`) New features
- 🐛 (`:bug:`) Bug fixes
- 🔖 (`:bookmark:`) Version/release tags
- 📝 (`:memo:`) Documentation
- 🔧 (`:wrench:`) Configuration/build
- ♻️ (`:recycle:`) Refactoring

---

## v2 Roadmap

Based on field feedback from heavy production usage (BetterReads/Ottr: 52 Views, 23 Managers).

### v2.0 — Core DX & Robustness

#### Features

**1. Typed LazxMultiBuilder (LazxMultiBuilder2 through LazxMultiBuilder5)**
Eliminate `List<dynamic>` casts. Each variant is fully generic — `LazxMultiBuilder3<A, B, C>` gives
typed `(A?, B?, C?)` directly in the builder callback. The untyped `LazxMultiBuilder` stays for >5 streams.

**2. LazxExecutor mixin (opt-in execute pattern)**
Provides `execute<T>(Future<T> Function() task, {bool silent})` with automatic loading/error
management. Exposed as a mixin (`with LazxExecutor`) so it doesn't bloat ViewModels that don't need it.
Base `LazxViewModel` gains only `isDisposed` tracking — universally needed, zero opinion.

**3. Lifecycle hooks: onResume / onPause**
`LazxView`'s State mixes in `WidgetsBindingObserver` to forward app lifecycle events to the ViewModel.
Common need for refreshing data, reconnecting sockets, saving drafts on background.

#### Bug fixes & hardening (all done)

- ~~**4. Fix stream subscription leaks**~~ — Store subscriptions and cancel on dispose in
  `LazxStateBuilder`, `LazxDataBuilder`, `LazxWidget`
- ~~**5. Fix LazxObserverBuilder**~~ — Rewritten as StatefulWidget with proper subscription lifecycle
- ~~**6. Add dispose to LazxListener**~~ — Stores subscription, exposes `dispose()`
- ~~**7. Fix LazxApp WidgetsBindingObserver registration**~~ — Added `addObserver`/`removeObserver`
- ~~**8. Add mounted checks before setState**~~ — Added guard in `LazxDataBuilder`
- ~~**9. Unify API naming**~~ — `LazxObserver.observer` -> `.stream`, `.set()` -> `.push()`,
  new `LazxDisposable` base class, unified `props` type across VM and Manager
- ~~**10. Add reset() to LazxData**~~ — Resets value and state to initial

### v2.1 — Stream Operators & Computed

**11. Debounce / Throttle / Distinct on LazxData**
Expose RxDart stream operators via extension methods (`.debounced()`, `.throttled()`, `.distinct()`).
Returns a derived `LazxData` wrapping the transformed stream. Eliminates manual Timer boilerplate.

**12. LazxComputed — derived reactive values**
`LazxComputed<T>(sources: [...], compute: () => ...)` that auto-recomputes when any source changes.
Distinct by default (skips rebuild if computed value unchanged). Integrates into `props` for disposal.

**13. Testing helpers**
`await data.waitForState(LxState.Success)` and similar utilities to simplify async test assertions.
