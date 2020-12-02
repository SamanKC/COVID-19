import 'dart:convert';

import 'package:covid19/api/api.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  //Get News data
  Future getNews() async {
    var response = await Api().getData('https://nepalcorona.info/api/v1/news');
    var data = json.decode(response.body)['data'];
    return data;
  }

  //url launcher
  launchURL(String webUrl) async {
    if (await canLaunch(webUrl)) {
      await launch(webUrl);
    } else {
      throw 'Could not launch $webUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Covid News'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              FutureBuilder(
                future: getNews(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var mydata = snapshot.data[index];
                        return Card(
                          child: ListTile(
                            title: Text(
                              mydata['title'],
                            ),
                            subtitle: Column(
                              children: [
                                Text(
                                  mydata['summary'],
                                  // maxLines: 2,
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.event,
                                            color: Colors.red,
                                            size: 18,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          InkWell(
                                            onTap: () {},
                                            child: Text(mydata['created_at']
                                                .toString()
                                                .split('T')
                                                .first),
                                          )
                                        ],
                                      ),
                                    ),
                                    FlatButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side:
                                                BorderSide(color: Colors.red)),
                                        onPressed: () {
                                          launchURL(mydata['url']);
                                        },
                                        color: Colors.red,
                                        child: Text('Read more'))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: snapshot.data.length,
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                        'Cannot load at this moment, please try again later');
                  } else {
                    return Center(
                      child: LinearProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
