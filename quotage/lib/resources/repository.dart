import 'dart:async';
import 'quote_provider_api.dart';
import 'package:quotage/model/Quote.dart';


class Repository{

  final quotesApiProvider = QuotesApi();

  Future<Quotation> fetchAllQuotes(String category) => 
      quotesApiProvider.getJson(category);


}