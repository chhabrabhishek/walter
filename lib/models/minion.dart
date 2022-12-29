const String tableMinions = 'minions';

class MinionsFields {
  static final List<String> values = [
    minionId,
    name,
    phonenumber,
  ];
  static const String minionId = 'minionId';
  static const String name = 'name';
  static const String phonenumber = 'phonenumber';
}

class Minion {
  final int? minionId;
  final String name;
  final String phonenumber;

  const Minion({
    this.minionId,
    required this.name,
    required this.phonenumber,
  });

  Minion copy({
    int? minionId,
    String? name,
    String? phonenumber,
  }) =>
      Minion(
        minionId: minionId ?? this.minionId,
        name: name ?? this.name,
        phonenumber: phonenumber ?? this.phonenumber,
      );

  static Minion fromJson(Map<String, Object?> json) => Minion(
      minionId: json[MinionsFields.minionId] as int,
      name: json[MinionsFields.name] as String,
      phonenumber: json[MinionsFields.phonenumber] as String);

  Map<String, Object?> toJson() => {
        MinionsFields.minionId: minionId,
        MinionsFields.name: name,
        MinionsFields.phonenumber: phonenumber,
      };
}
