class OpenAi {
  late String model;
  List<Choice> choice = [];
  OpenAi.fromJson(Map<String, dynamic> json) {
    model = json["model"];
    json["choices"].forEach((e) {
      choice.add(Choice.fromJson(e));
    });
  }
}

class Choice {
  late String text;
  Choice.fromJson(Map<String, dynamic> json) {
    text = json["text"];
  }
}
