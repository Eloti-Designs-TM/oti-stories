
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({
    Key key,
    @required this.webView}) :super(key: key);

final InAppWebViewController webView; 

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
    
                 FlatButton(
                  child: Text(
                    'Go Back |',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  textColor: Colors.white,
                  color: Colors.black,
                  onPressed: () {
                    webView.goBack();
                  },
                ),
                   FlatButton(
                  child: Text(
                    'Go Forward |',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  textColor: Colors.white,
                  color: Colors.black,
                  onPressed: () {
                    webView.goForward();
                  },
                ),
              
         
          
        ],
      ),
    );
  }
}
