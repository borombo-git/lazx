import 'package:lazx/lazx.dart';

class ComputedDemoViewModel extends LazxViewModel {
  /// --- Full Name section ---
  final firstName = LazxData<String>('John');
  final lastName = LazxData<String>('Doe');

  late final fullName = LazxComputed<String>(
    sources: [firstName, lastName],
    compute: () => '${firstName.value} ${lastName.value}',
  );

  /// --- Price calculation section ---
  final price = LazxData<double>(9.99);
  final quantity = LazxData<int>(1);

  late final total = LazxComputed<double>(
    sources: [price, quantity],
    compute: () => price.value * quantity.value,
  );

  /// --- Form validation section ---
  final email = LazxData<String>('');
  final password = LazxData<String>('');
  final acceptedTerms = LazxData<bool>(false);

  late final isFormValid = LazxComputed<bool>(
    sources: [email, password, acceptedTerms],
    compute: () =>
        email.value.contains('@') &&
        password.value.length >= 6 &&
        acceptedTerms.value,
  );

  @override
  List<LazxDisposable> get props => [
        firstName,
        lastName,
        fullName,
        price,
        quantity,
        total,
        email,
        password,
        acceptedTerms,
        isFormValid,
      ];

  void updateFirstName(String value) => firstName.push(value);
  void updateLastName(String value) => lastName.push(value);

  void incrementQuantity() => quantity.push(quantity.value + 1);
  void decrementQuantity() {
    if (quantity.value > 0) quantity.push(quantity.value - 1);
  }

  void updateEmail(String value) => email.push(value);
  void updatePassword(String value) => password.push(value);
  void toggleTerms(bool? value) => acceptedTerms.push(value ?? false);
}
