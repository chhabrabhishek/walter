const String tableSaul = 'saul';

class SaulFields {
  static final List<String> values = [
    saulId,
    kevinId,
    amount,
    isDebited,
    dateOfTransaction
  ];
  static const String saulId = 'saulId';
  static const String kevinId = 'kevinId';
  static const String amount = 'amount';
  static const String isDebited = 'isDebited';
  static const String dateOfTransaction = 'dateOfTransaction';
}

class Saul {
  final int? saulId;
  final int kevinId;
  final int amount;
  final int isDebited;
  final String dateOfTransaction;

  const Saul({
    this.saulId,
    required this.kevinId,
    required this.amount,
    required this.isDebited,
    required this.dateOfTransaction,
  });

  Saul copy({
    int? saulId,
    int? kevinId,
    int? amount,
    int? isDebited,
    String? dateOfTransaction,
  }) =>
      Saul(
        saulId: saulId ?? this.saulId,
        kevinId: kevinId ?? this.kevinId,
        amount: amount ?? this.amount,
        isDebited: isDebited ?? this.isDebited,
        dateOfTransaction: dateOfTransaction ?? this.dateOfTransaction,
      );

  static Saul fromJson(Map<String, Object?> json) => Saul(
      saulId: json[SaulFields.saulId] as int,
      kevinId: json[SaulFields.kevinId] as int,
      amount: json[SaulFields.amount] as int,
      isDebited: json[SaulFields.isDebited] as int,
      dateOfTransaction: json[SaulFields.dateOfTransaction] as String);

  Map<String, Object?> toJson() => {
        SaulFields.saulId: saulId,
        SaulFields.kevinId: kevinId,
        SaulFields.amount: amount,
        SaulFields.isDebited: isDebited,
        SaulFields.dateOfTransaction: dateOfTransaction,
      };
}
