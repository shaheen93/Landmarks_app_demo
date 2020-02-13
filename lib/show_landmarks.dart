import './models/landmark.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShowLandmarks extends StatefulWidget {
  @override
  _ShowLandmarksState createState() => _ShowLandmarksState();
}

class _ShowLandmarksState extends State<ShowLandmarks> {
  bool _isLoading = false;
  List<LandMark> _list = List<LandMark>();
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    fetchData().then((response) {
      List<LandMark> x = List<LandMark>();
      print(response);
      response.forEach((data) {
        x.add(LandMark(
          id: data['id'],
          title: data['title'],
          slug: data['slug'],
          haram: data['haram'],
          icon: data['icon'],
        ));
      });
      setState(() {
        _list = x;
        _isLoading = false;
      });
    });
  }

  Future fetchData() async {
    final response = await http
        .get('https://testing.a2.wmnapp.fslabs.net/api/landmarkCategories');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return (json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'LANDMARKS',
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _list.isEmpty
              ? Center(
                  child: Text(
                    'No Landmarks Available',
                  ),
                )
              : ListView.builder(
                  itemCount: _list.length,
                  itemBuilder: (ctx, index) {
                    return Card(
                      elevation: 5,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            'https://a2.wmnapp.net/api/containers/landmarks_category_icons/download/${_list[index].icon}',
                          ),
                        ),
                        title: Text('${_list[index].title}'),
                        subtitle: Text('${_list[index].slug}'),
                        trailing: Column(
                          children: <Widget>[
                            Text('ID: ${_list[index].id}'),
                            Text('Haram: ${_list[index].haram}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
