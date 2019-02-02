import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:quotage/bloc/quote_bloc.dart';
import 'package:quotage/model/Quote.dart';
import 'package:quotage/widgets/quotes_cardview.dart';

class QuoteList extends StatefulWidget {
  final List<String> labels;

  QuoteList({@required this.labels});
  @override
  _QuoteListState createState() => _QuoteListState();
}

class _QuoteListState extends State<QuoteList> {
  @override
  void initState() {
    super.initState();
    bloc.fetchQuotes(widget.labels);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.allQuotes,
      builder: (context, AsyncSnapshot<Quotation> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator());
          case ConnectionState.done:
            {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }else if (snapshot.hasData) {
                return buildList(snapshot);
              } 
            }
        }
      },
    );
  }

  Widget buildList(AsyncSnapshot<Quotation> snapshot) {
    String quote = snapshot.data.getQuote();
    String author = snapshot.data.author;
     
    return SizedBox.fromSize(
        size: Size.fromHeight(500.0),
        child: PageView.builder(
            itemCount: widget.labels.length,
            controller: PageController(viewportFraction: 0.9),
            itemBuilder: (context, index) {
              return QuoteCardView(quote, author);
            })) ;
  }
}
