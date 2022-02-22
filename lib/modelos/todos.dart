class Todo{

  Todo({required this.title, required this.dateTime});

  Todo.fromJson(Map<String, dynamic> json)//lendo arquivo json
    : title = json['title'],
      dateTime = DateTime.parse(json['datetime']);//convertido para um objeto data

  String title;
  DateTime dateTime;

  Map<String, dynamic>toJson(){
    return {
        'title': title,
        'datetime': dateTime.toIso8601String(),//convertendo data para string 
    };
  }
}