import 'package:rxdart/rxdart.dart';
import 'package:quotage/resources/repository.dart';
import 'package:quotage/model/Quote.dart';

class QuoteBloc{
  final _repository = Repository();
  final _quoteFetcher = PublishSubject<Quotation>();

  Observable<Quotation> get allQuotes => _quoteFetcher.stream;

    
  fetchQuotes(List<String> labels) async {

   for (var i = 0; i < labels.length; i++) {
     Quotation quotesModel = await _repository.fetchAllQuotes(labels[i]);
    _quoteFetcher.sink.add(quotesModel);
   }
    
  }

  dispose() {
    _quoteFetcher.close();
  }

}


final bloc = QuoteBloc();