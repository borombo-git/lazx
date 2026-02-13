import '../lazx.dart';

/// [LazxViewModel] represents the base class to extends for your viewModels
///
/// A [LazxViewModel] will mainly help you to handle easily your [LazxData]
/// It can also be used without any [LazxData] as a classic viewModel to integrate in your app
abstract class LazxViewModel {
  /// Represents the list of reactive properties in your viewModel
  ///
  /// This variable is used to handle the lifecycle of your data as your viewModel
  /// is tied to the lifecycle of your Widget.
  /// Accepts any Lazx reactive type ([LazxData], [LazxState], [LazxObserver]).
  List<LazxDisposable> get props;

  /// Can be override to initialise some calls or variables
  void init() {}

  /// Can be override to finish some calls/listeners
  /// It's also used to dispose all the [LazxData]
  void dispose() {
    props.forEach((value) => value.dispose());
  }
}
