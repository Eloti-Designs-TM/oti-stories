import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerBar extends StatefulWidget {
  @override
  _DrawerBarState createState() => _DrawerBarState();
}

class _DrawerBarState extends State<DrawerBar> {
  String _openAppStore =
      'https://play.google.com/store/apps/details?id=com.otistories.otistories';

  String _launchWhatsappUrl =
      'whatsapp://send/?phone=2347035524042&text=Hello....%20am%20I%20on%20to%20Oti%20Stories%3F';

  String _launchBroswerUrl = 'https://otistories.com/prayer-buzz/';

  _launchLink(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
    } else {
      throw 'could not launch $_launchBroswerUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 150),
                child: Container(
                  padding: EdgeInsets.all(1),
                  height: 150,
                  child: Image.asset(
                    'assets/drawerimage.png',
                    colorBlendMode: BlendMode.color,
                    height: double.infinity,
                    width: 200,
                  ),
                ),
              ),
            ],
          ),
          Divider(color: Colors.grey),
          ListTile(
            title: Text('About Us'),
            trailing: Icon(Icons.bookmark),
            onTap: () {
              showDialog(
                context: context,
                child: SimpleDialog(
                  titlePadding: EdgeInsets.all(10),
                  contentPadding: EdgeInsets.all(15),
                  title: Text(
                    'ABOUT US',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: [
                    Text(
                      """Hello! Welcome to Oti stories…

Oti stories was founded On the 12th of October 2016.

Oti Stories is a faith based platform, full of powerful and spirit filled stories, prayers,  declarations and posts,  that would cause a turn around in your  life 

We are committed to praying  with you everyday and guiding you to live victoriously and successfully 

Kindly follow up on our posts daily...""",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            title: Text('Connect with us on whatsapp'),
            trailing: Icon(Icons.touch_app),
            onTap: () {
              _launchLink(_launchWhatsappUrl);
            },
          ),
          ListTile(
            title: Text('Share App'),
            trailing: Icon(Icons.share),
            onTap: () {
              setState(() {
                Share.share(
                    'Hello,  kindly download the Oti Stories App. It would ignite your prayer life & help you live victoriously. https://play.google.com/store/apps/details?id=com.otistories.otistories');
              });
            },
          ),
          ListTile(
            title: Text('Update app'),
            trailing: Icon(Icons.update),
            onTap: () {
              _launchLink(_openAppStore);
            },
          ),
          ListTile(
            title: Text('Contact Us'),
            trailing: Icon(Icons.info_outline),
            onTap: () {
              showDialog(
                context: context,
                child: SimpleDialog(
                  title: Text(
                    'CONTACT US',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: [
                    Text(
                      """Hello… WELCOME TO OTI STORIES…

We’d love to hear from you! Tell us what you think and ask your questions. We are always available.

Call and Whatsaap: +2347035524042

Email: Otistories@gmail.com

We love you!""",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            title: Text('Exit App'),
            trailing: Icon(Icons.exit_to_app),
            onTap: () {
              showDialog(
                context: context,
                child: AlertDialog(
                  title: Text(
                    'Do you want to exit App',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  actions: <Widget>[
                    OutlineButton(child: Text('Yes'), onPressed: () => exit(0)),
                    OutlineButton(
                        child: Text('No'),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
