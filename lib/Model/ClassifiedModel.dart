class ClassifiedModel {
  final int id;
  final String name;

  ClassifiedModel({
    this.id,
    this.name,
  });

  factory ClassifiedModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return ClassifiedModel(
      id: json["businessId"],
      name: json["businessType"],
    );
  }

  static List<ClassifiedModel> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => ClassifiedModel.fromJson(item)).toList();
  }

  @override
  String toString() => name;

  @override
  operator ==(o) => o is ClassifiedModel && o.id == id;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}

class Classifield {
  final String name;
  final int phonenumber;
  final String businesstype;
  final String imageName;

  Classifield({this.name, this.phonenumber, this.businesstype, this.imageName});

  factory Classifield.fromJson(Map<String, dynamic> parsedJson) {
    return Classifield(
        name: parsedJson['userName'],
        phonenumber: parsedJson['phoneNumber'],
        businesstype: parsedJson['businessType'],
        imageName: parsedJson['endpoint']);
  }
}
