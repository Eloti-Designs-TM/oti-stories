import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

linearProgress(progress) {
  return Container(
    height: 2.5,
    child: LinearProgressIndicator(
      value: progress,
      backgroundColor: Colors.black,
      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
    ),
  );
}

class ErrorPage extends StatefulWidget {
  int statusCodes;
  InAppWebViewController webView;
  bool loading;
  ErrorPage({this.statusCodes, this.webView, this.loading});
  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  bool onError = false;
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return widget.loading == true || onError == true
        ? Container(
            height: screenSize.height,
            width: screenSize.height,
            decoration: BoxDecoration(
             
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.signal_wifi_off,
                  size: 140,
                  color: Colors.red[300],
                ),
                SizedBox(height: 2),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: widget.statusCodes == 500
                            ? 'Internal Server Error'
                            : widget.statusCodes == -8
                                ? 'Check data bundles'
                                : 'Check internet connections',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          // fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: '!',
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.red,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () async {
                        // await widget.webView.loadUrl(
                        //     url: 'https://tinyurl.com/otistoriesforum');
                        setState(() {
                          onError = true;
                        });
                      },
                      child: Text('Retry'),
                    ),
                  ],
                ),
              ],
            ),
          )
        : Container();
  }
}
