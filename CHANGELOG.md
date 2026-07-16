## [2.2.0]

### New features

* **LazxSubscriptions mixin** (on `LazxViewModel` and `LazxManager`): `listenTo(stream, onData)` registers a stream subscription that is automatically cancelled on `dispose()` — replaces the hand-written `StreamSubscription` field + `dispose()` override per listener. `cancelSubscriptions()` is exposed for manual control, and `listenTo` returns the subscription for early cancellation.

## [2.1.0]

### New features

* **Stream Operators**: Extension methods on `LazxData` that return read-only derived data
  * `debounced(Duration)` — emits value only after a pause in updates (search fields, form validation)
  * `throttled(Duration)` — limits emission rate (scroll events, rapid taps)
  * `distinct([equals])` — skips consecutive duplicate values, with optional custom comparator
* **LazxDerivedData**: Read-only `LazxData` subclass backing the stream operators. Works as a drop-in replacement in all Lazx builders. Calling `push()`, `setState()`, or `reset()` throws `UnsupportedError`
* **LazxComputed**: Derived reactive values that auto-recompute when any source changes. Supports mixed source types (`LazxData`, `LazxObserver`, `LazxState`), aggregates state with Error > Loading > Success > Initial priority, and is distinct by default (skips rebuild if computed value unchanged)
* **Chaining**: Operators can be chained (e.g. `query.debounced(...).distinct()`)
* **Testing Helpers** (`package:lazx/lazx_testing.dart`): Extension methods for async test assertions
  * `waitForState(LxState)` — completes when the target state is observed
  * `expectStateSequence(List<LxState>)` — strict ordered state sequence check
  * `waitForValue(T)` — completes when the target value is observed
  * `expectEmits(List<T>)` — verifies a sequence of emitted values

## [2.0.0]

### Breaking changes

* **LazxObserver**: `observer` getter renamed to `stream` (aligns with `LazxData.stream`)
* **LazxObserver**: `set()` renamed to `push()` (aligns with `LazxData.push()`)
* **LazxDisposable**: New base class for all Lazx reactive types — both `LazxObservable` and `LazxObserver` implement it
* **LazxViewModel.props**: Type changed from `List<LazxObservable>` to `List<LazxDisposable>` — can now hold any Lazx reactive type
* **LazxManager.props**: Type changed from `List<LazxObserver>` to `List<LazxDisposable>` — unified with ViewModel

### New features

* **LazxData.reset()**: Restores value and state to their initial values
* **Lifecycle hooks**: `LazxViewModel.onResume()` and `onPause()` — automatically called when the app goes to foreground/background via `LazxView`'s `WidgetsBindingObserver`
* **LazxViewModel.isDisposed**: Tracks whether the ViewModel has been disposed — useful to guard async callbacks
* **LazxExecutor mixin**: Opt-in `execute<T>(task, {silent})` with automatic `isLoading`/`error` management. Add `with LazxExecutor` and spread `...executorProps` into your props list
* **Typed LazxMultiBuilder**: `LazxMultiBuilder2` through `LazxMultiBuilder5` — type-safe variants that provide typed values directly in the builder callback instead of `List<dynamic>`

### Bug fixes

* **LazxStateBuilder, LazxDataBuilder, LazxWidget**: Fix stream subscription leaks — subscriptions are now stored and canceled on dispose
* **LazxDataBuilder**: Add missing `mounted` guard before `setState()`
* **LazxObserverBuilder**: Rewrite as StatefulWidget — was previously calling `.listen()` inside `build()`, leaking a new subscription on every rebuild
* **LazxListener**: Add `dispose()` method to cancel the stream subscription
* **LazxApp**: Register `WidgetsBindingObserver` with `addObserver`/`removeObserver` — lifecycle callbacks (including manager disposal on app detach) were previously dead code

## [1.1.6]

* Update SDK constraint to >=3.5.0 <4.0.0
* Update Flutter constraint to >=3.24.0
* Update provider to ^6.1.5
* Remove explicit meta dependency (use Flutter SDK's version)
* Update demo projects SDK constraints

## [1.1.5]

* Upgrade all libs versions
* Add a new widget: LazxMultiBuilder
* Upgrade & Update demos with the new widget
* Update README with the new components

## [1.1.4]

* Upgrade all libs versions + Demos

## [1.1.3]

* Upgrade all libs versions

## [1.1.2]

* Downgrade version of rxdart to support graphql lib

## [1.1.1]

* Update README with the new components
* Add link for the new demo, Lazx Weather

## [1.1.0]

* Add Lazx App Widget + Tests
* Add Lazx Listener + Tests
* Add Lazx State + Tests
* Add Lazx Observer + Tests
* Add Lazx Response + Tests
* Add Lazx Observable

## [1.0.1]

* Add example main.dart + demos folder

## [1.0.0]

* Initial release