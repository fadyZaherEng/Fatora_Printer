class Fatora {
  int? id;
  String name;
  int age;

  Fatora({this.id, required this.name, required this.age});

  // Convert a Fatora object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  // Convert a Map object into a Fatora object
  factory Fatora.fromMap(Map<String, dynamic> map) {
    return Fatora(
      id: map['id'],
      name: map['name'],
      age: map['age'],
    );
  }
}