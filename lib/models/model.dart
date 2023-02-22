class Model {
  List<Data> data = [];
  Model.fromJson(Map<String, dynamic> json) {
    json["data"].forEach((e) {
      data.add(Data.fromJson(e));
    });
  }
}

class Data {
  late String id;
  Data.fromJson(Map<String, dynamic> json) {
    id = json["id"];
  }
}
