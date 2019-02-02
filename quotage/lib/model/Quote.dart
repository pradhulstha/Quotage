class Quotation {
  String quote;
  String author;
  String id;
  List<String> categories;

  Quotation({this.quote, this.author, this.id, this.categories});

  factory Quotation.fromJson(Map<String, dynamic> parsedJson) {
    var categoryFromJson  = parsedJson['categories'];
    //print(streetsFromJson.runtimeType);
    // List<String> streetsList = new List<String>.from(streetsFromJson);
    List<String> catList = categoryFromJson.cast<String>();

    return new Quotation(
      quote: parsedJson['quote'],
      author: parsedJson['author'],
      id: parsedJson['id'],
      categories: catList,
    );
  }


  String getQuote(){
    return quote;
  }
}



