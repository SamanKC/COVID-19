import 'dart:convert';

import 'package:covid19/api/api.dart';
import 'package:flutter/material.dart';

class HospitalList extends StatefulWidget {
  @override
  _HospitalListState createState() => _HospitalListState();
}

class _HospitalListState extends State<HospitalList> {
  //Get Hospital data
  Future getHostpitalList() async {
    var response =
        await Api().getData('https://nepalcorona.info/api/v1/hospitals');
    var data = json.decode(response.body)['data'];
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Hopital in Nepal'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              FutureBuilder(
                future: getHostpitalList(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var mydata = snapshot.data[index];
                        return Card(
                          child: ListTile(
                              title: Text(mydata['name']),
                              trailing: mydata['is_full']
                                  ? Text('Status: Full')
                                  : Text('Status: Not Full'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text("Address: "),
                                      mydata['address'] == ''
                                          ? Text("Not Available")
                                          : Text(mydata['address'])
                                    ],
                                  ),
                                  Container(
                                      child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Text("Phone: "),
                                        mydata['phone'] == ''.toString()
                                            ? Text("Not Available")
                                            : Text(mydata['phone']),
                                      ],
                                    ),
                                  ))
                                ],
                              )),
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
