import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FavIcon extends StatefulWidget {

  final String quote, author;
  FavIcon(this.quote, this.author);
  @override
  _FavIconState createState() => _FavIconState();
}

class _FavIconState extends State<FavIcon> {
  bool _active = false;

 Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    
    final path = await _localPath;
    return File('$path/quotes.txt');
  }

  Future<void> _saveQuote(String quote) async {
    // write the variable as a string to the file
      final file = await _localFile;
      // Write the file
      file.writeAsString("$quote");
  }
  void _handleTap() {
    
    _saveQuote("` ${widget.quote}.` - ${widget.author}\n");
    setState(() {
      _active = !_active;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.favorite),
      iconSize: 25.0,
      disabledColor: Theme.of(context).disabledColor,
      color: Colors.white70,
      splashColor: Colors.redAccent,
      onPressed: () => _handleTap()
    );
  }
}
