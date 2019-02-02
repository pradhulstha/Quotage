import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quotage/model/Quote.dart';

class QuotesApi{

  Future<Quotation> getJson(String category) async {
    String apiUrl = "https://theysaidso.p.mashape.com/quote?category=" +
        category;

    Map mapData;


    http.Response response = await http.get(
        Uri.encodeFull(apiUrl),
        headers: {
          "X-Mashape-Key": "zEDYXVmTi0mshCxGDdk1Tnpqhbclp1DK97Pjsn3g19fYBz4mhY",
          "Accept": "application/json"
        }
    );

    if (response.statusCode == 200) {
      Map data = json.decode(response.body);
      mapData = data['contents'];
      return Quotation.fromJson(mapData);

    }

    else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }
}


QuotesApi quoteApi = QuotesApi();