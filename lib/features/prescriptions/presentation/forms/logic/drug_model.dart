class DrugModel {
  final String name;
  final String type;

  const DrugModel({required this.name, required this.type});

  factory DrugModel.fromJson(Map<String, dynamic> json) {
    return DrugModel(
      name: json['name'] as String,
      type: json['type'] as String,
    );
  }

  @override
  String toString() => 'DrugModel(name: $name, type: $type)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DrugModel && other.name == name && other.type == type);

  @override
  int get hashCode => Object.hash(name, type);
}