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
