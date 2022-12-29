const String tableKevin = 'kevin';

class KevinFields {
  static final List<String> values = [
    minionId,
    kevinId,
    accountNumber,
    bankName
  ];
  static const String kevinId = 'kevinId';
  static const String minionId = 'minionId';
  static const String accountNumber = 'accountNumber';
  static const String bankName = 'bankName';
}

class Kevin {
  final int? kevinId;
  final int minionId;
  final String accountNumber;
  final String bankName;

  const Kevin({
    this.kevinId,
    required this.minionId,
    required this.accountNumber,
    required this.bankName,
  });

  Kevin copy({
    int? kevinId,
    int? minionId,
    String? accountNumber,
    String? bankName,
  }) =>
      Kevin(
        kevinId: kevinId ?? this.kevinId,
        minionId: minionId ?? this.minionId,
        accountNumber: accountNumber ?? this.accountNumber,
        bankName: bankName ?? this.bankName,
      );

  static Kevin fromJson(Map<String, Object?> json) => Kevin(
      kevinId: json[KevinFields.kevinId] as int,
      minionId: json[KevinFields.minionId] as int,
      accountNumber: json[KevinFields.accountNumber] as String,
      bankName: json[KevinFields.bankName] as String);

  Map<String, Object?> toJson() => {
        KevinFields.kevinId: kevinId,
        KevinFields.minionId: minionId,
        KevinFields.accountNumber: accountNumber,
        KevinFields.bankName: bankName,
      };
}
