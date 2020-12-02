import 'dart:convert';

import 'package:covid19/api/api.dart';
import 'package:covid19/pages/listhospital.dart';
import 'package:covid19/pages/myth.dart';
import 'package:covid19/pages/news.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  //Get world data
  Future getWorldData() async {
    var response =
        await Api().getData('https://data.nepalcorona.info/api/v1/world');
    var data = json.decode(response.body);
    return data;
  }

  //Get Nepal Data
  Future getNepalData() async {
    var response =
        await Api().getData('https://nepalcorona.info/api/v1/data/nepal');
    var data = json.decode(response.body);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("COVID-19, by Saman KC"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              //TODO: World Record
              ListTile(
                leading: Icon(Icons.coronavirus_rounded),
                title: Text("World Covid Situation"),
              ),
              FutureBuilder(
                future: getWorldData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Row(
                      children: [
                        buildWorldRecordCard(
                            snapshot: snapshot,
                            title: 'Positive',
                            keyword: 'cases',
                            color: Colors.blue),
                        buildWorldRecordCard(
                            snapshot: snapshot,
                            title: 'Deaths',
                            keyword: 'deaths',
                            color: Colors.red),
                        buildWorldRecordCard(
                            snapshot: snapshot,
                            title: 'Recovered',
                            keyword: 'recovered',
                            color: Colors.green)
                      ],
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

              SizedBox(
                height: 20,
              ),
              //TODO: Nepal Record
              ListTile(
                leading: Icon(Icons.coronavirus_rounded),
                title: Text("Nepal Covid Situation"),
              ),
              FutureBuilder(
                future: getNepalData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Row(
                      children: [
                        buildWorldRecordCard(
                            snapshot: snapshot,
                            title: 'Positive',
                            keyword: 'tested_positive',
                            color: Colors.blue),
                        buildWorldRecordCard(
                            snapshot: snapshot,
                            title: 'Deaths',
                            keyword: 'deaths',
                            color: Colors.red),
                        buildWorldRecordCard(
                            snapshot: snapshot,
                            title: 'Recovered',
                            keyword: 'recovered',
                            color: Colors.green)
                      ],
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

              SizedBox(
                height: 20,
              ),
              //TODO: Covid Information
              ListTile(
                leading: Icon(Icons.coronavirus_rounded),
                title: Text("Covid-19 Informations"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RaisedButton(
                    color: Colors.amberAccent,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Myth()));
                    },
                    child: Text('Myths'),
                  ),
                  RaisedButton(
                    color: Colors.redAccent,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => News()));
                    },
                    child: Text('Covid News'),
                  ),
                  RaisedButton(
                    color: Colors.orangeAccent,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HospitalList()));
                    },
                    child: Text('Hospitals List'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildWorldRecordCard(
      {AsyncSnapshot snapshot, String title, String keyword, Color color}) {
    return Expanded(
      child: Card(
        color: color,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(snapshot.data[keyword].toString()),
            ],
          ),
        ),
      ),
    );
  }
}
