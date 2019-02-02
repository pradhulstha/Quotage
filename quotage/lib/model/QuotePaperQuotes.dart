class QuotationPaper {
  String quote;
  String author;
  int likes;
  Uri image;
  int pk;
  List<String> categories;

  QuotationPaper({this.quote, this.author, this.likes, this.image, this.pk, this.categories});

  factory QuotationPaper.fromJson(Map<String, dynamic> parsedJson) {
    var categoryFromJson  = parsedJson['tags'];

    List<String> catList = categoryFromJson.cast<String>();

    return QuotationPaper(
      quote: parsedJson['quote'] as String,
      author: parsedJson['author'] as String,
      likes: parsedJson['likes'] as int,
      categories: catList,
      pk: parsedJson['pk'] as int,
      image: parsedJson['image'],
    );
  }
}

