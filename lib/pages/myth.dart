import 'dart:convert';

import 'package:covid19/api/api.dart';
import 'package:flutter/material.dart';

class Myth extends StatefulWidget {
  @override
  _MythState createState() => _MythState();
}

class _MythState extends State<Myth> {
  //Get myths data
  Future getMyth() async {
    var response = await Api().getData('https://nepalcorona.info/api/v1/myths');
    var data = json.decode(response.body)['data'];
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Covid Myths'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: getMyth(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var mydata = snapshot.data[index];
                      return Image.network(mydata["image_url"].toString());
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
    );
  }
}
