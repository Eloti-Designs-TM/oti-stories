import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:connectivity/connectivity.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:otistories/views/widget/commons.dart';
import 'package:otistories/widgets/bottom_nav.dart';
import 'package:otistories/widgets/drawer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class HomeView extends StatefulWidget {
  static const routeName = '/webpage';

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  var uuid = Uuid();

  StreamSubscription<ConnectivityResult> subscription;

  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  InAppWebViewController webView;
  ContextMenu contextMenu = ContextMenu();
  var menu = ContextMenu().menuItems;
  String url = "";
  double progress = 0;
  int statusCodes;

  bool loadError = false;

  //-----------------
  bool downloading = false;
  var progressString = "";

  final snackbar = SnackBar(
      content:
          Text('Download Completed', style: TextStyle(color: Colors.white)));

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none && webView != null) {
        print("reload");
        print("reload");
        loadError = false;
        webView.reload();
      }
    });
    subscription.cancel();

    contextMenu = ContextMenu(onCreateContextMenu: (hitTestResult) async {
      print("onCreateContextMenu");
      print(hitTestResult.extra);

      print(await webView.getSelectedText());

      if (hitTestResult.extra == null) {
        print(hitTestResult.extra);
      } else if (hitTestResult.extra.contains('.jpg') ||
          hitTestResult.extra.contains('.png')) {
        await downloadFile(hitTestResult.extra);
        _scaffoldkey.currentState.showSnackBar(snackbar);
      }
    }, onHideContextMenu: () {
      print("onHideContextMenu");
    }, onContextMenuActionItemClicked: (contextMenuItemClicked) {
      var id = (Platform.isAndroid)
          ? contextMenuItemClicked.androidId
          : contextMenuItemClicked.iosId;
      print("onContextMenuActionItemClicked: " +
          id.toString() +
          " " +
          contextMenuItemClicked.title);
    });

    menu = [
      ContextMenuItem(
          androidId: 1,
          iosId: "1",
          title: "Special",
          action: () async {
            print("Menu item Special clicked!");
          })
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> downloadFile(String url) async {
    Dio dio = Dio();
    Directory downloadsDirectory;

    try {
      await Permission.storage.request();
      downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;

      // var dir = await getApplicationDocumentsDirectory();

      print("${downloadsDirectory.path}");
      print(downloadsDirectory.create());
      if (url.contains('https://docs.google.com/')) {
        print('Can launch');
        if (await canLaunch(url)) {
          // Launch the App
          await launch(url);
        }
      } else if (url.contains('.mp4')) {
        await dio.download(url,
            "${downloadsDirectory.path}/otistories/${uuid.v4()}otistories.mp4",
            onReceiveProgress: (recieve, total) {
          print("Recieve: $recieve , Total: $total");
          setState(() {
            downloading = true;
            progressString = ((recieve / total) * 100).toStringAsFixed(0) + "%";
          });
        });
      } else if (url.contains('.mp3')) {
        await dio.download(url,
            "${downloadsDirectory.path}/otistories/${uuid.v4()}otistories.mp3",
            onReceiveProgress: (recieve, total) {
          setState(() {
            downloading = true;
            progressString = ((recieve / total) * 100).toStringAsFixed(0) + "%";
          });
        });
      } else if (url.contains('.jpg') || url.contains('.png')) {
        await dio.download(url,
            "${downloadsDirectory.path}/otistories/${uuid.v4()}otistories.jpg",
            onReceiveProgress: (recieve, total) {
          setState(() {
            downloading = true;
            progressString = ((recieve / total) * 100).toStringAsFixed(0) + "%";
          });
        });
      }
    } catch (e) {
      print(e);
    }

    setState(() {
      downloading = false;
      progressString = "Completed";
    });
    print("Download completed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text("Oti Stories"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => webView.reload(),
        backgroundColor: Colors.black,
        child: Icon(Icons.refresh),
      ),
      drawer: SafeArea(
        child: DrawerBar(),
      ),
      bottomNavigationBar: BottomNav(webView: webView),
      body: SafeArea(
        child: Container(
          color: Colors.purple[100].withOpacity(.3),
          child: _webviewBody(context),
        ),
      ),
    );
  }

  _webviewBody(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            // _homeButton(),
            progress < 1.0 ? linearProgress(progress) : SizedBox(height: 0),
            Flexible(
              child: Container(
                child: InAppWebView(
                  initialUrl: 'https://tinyurl.com/otistoriesforum',
                  contextMenu: contextMenu,
                  initialHeaders: {},
                  initialOptions: InAppWebViewGroupOptions(
                      android: AndroidInAppWebViewOptions(
                        allowFileAccess: true,
                        loadsImagesAutomatically: true,
                        allowFileAccessFromFileURLs: true,
                        allowContentAccess: true,
                        allowUniversalAccessFromFileURLs: true,
                        geolocationEnabled: true,
                      ),
                      crossPlatform: InAppWebViewOptions(
                          debuggingEnabled: true,
                          useOnLoadResource: true,
                          useOnDownloadStart: true,
                          disableHorizontalScroll: true,
                          transparentBackground: true,
                          useShouldOverrideUrlLoading: true
                          // disableVerticalScroll: true,
                          )),
                  shouldOverrideUrlLoading: (controller, request) async {
                    var url = request.url;
                    var uri = Uri.parse(url);

                    if (![
                      "http",
                      "https",
                      "file",
                      "chrome",
                      "data",
                      "javascript",
                      "about"
                    ].contains(uri.scheme)) {
                      if (await canLaunch(url)) {
                        // Launch the App
                        await launch(
                          url,
                        );
                        // and cancel the request
                        return ShouldOverrideUrlLoadingAction.CANCEL;
                      }
                    }

                    return ShouldOverrideUrlLoadingAction.ALLOW;
                  },
                  onWebViewCreated: (InAppWebViewController controller) {
                    webView = controller;
                  },
                  onLoadStart:
                      (InAppWebViewController controller, String url) async {
                    setState(() {
                      this.url = url;
                    });
                  },
                  onLoadStop:
                      (InAppWebViewController controller, String url) async {
                    setState(() {
                      this.url = url;
                    });
                  },
                  onProgressChanged:
                      (InAppWebViewController controller, int progress) {
                    setState(() {
                      this.progress = progress / 100;
                    });
                  },
                  onLoadError: (InAppWebViewController controller, String url,
                      int code, String message) async {
                    print("error $url: $code, $message");
                    print("error $url: $code, $message ");
                    setState(() {
                      statusCodes = code;
                      loadError = true;
                    });
                  },
                  onLoadHttpError: (InAppWebViewController controller,
                      String url, int statusCode, String description) async {
                    setState(() {
                      loadError = true;
                      statusCodes = statusCode;
                    });

                    print("HTTP error $url: $statusCode, $description");
                  },
                  onDownloadStart:
                      (InAppWebViewController controller, String url) async {
                    // print("${controller.getUrl().toString()}");s
                    print(url);

                    await downloadFile(url);
                    _scaffoldkey.currentState.showSnackBar(snackbar);
                  },
                ),
              ),
            ),
          ],
        ),
        loadError
            ? Container(
                height: double.infinity,
                width: double.infinity,
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
                            text: statusCodes == 500
                                ? 'Internal Server Error'
                                : statusCodes == -8
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
                            await webView.loadUrl(
                                url: 'https://tinyurl.com/otistoriesforum');
                            if (progress < 1.0) {
                            } else {
                              setState(() {
                                loadError = false;
                              });
                            }
                          },
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : Container(),
        downloading ? showDownloading() : Text(''),
      ],
    );
  }

  showDownloading() {
    return Center(
      child: Container(
        height: 120.0,
        width: 200.0,
        child: Card(
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Downloading File: $progressString",
                style: TextStyle(
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
