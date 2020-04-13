import 'dart:convert';
import 'package:timeago/timeago.dart' as timeago;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
timeago.PtBrMessages a = timeago.PtBrMessages();

  


  bool isLoading = false;
  List<String> dogImages = new List();
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    fetchFive();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        //if we are at the bottom of the page
        fetchFive();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose;
  }

  @override
  Widget build(BuildContext context) {
    final d = DateTime.now();
   // a.days(d.day);
    a.hours(d.hour);
    return Scaffold(
      appBar: AppBar(
        title: Text("${a.days(d.day)} + ${a.hours(d.hour)}"),
        centerTitle: true,
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: dogImages.length,
        itemBuilder: (context, index) {
          return Container(
            // constraints: BoxConstraints.tightFor(height: 150.0),
            child: Column(
              children: <Widget>[
                Image.network(dogImages[index], fit: BoxFit.fitWidth),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget loading() {
    if (this.isLoading) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
        ],
      );
    }else{
      return SizedBox();
    }
  }

  fetch2() async {
    final response =
        await http.get('https://api.thecatapi.com/v1/images/search');
    if (response.statusCode == 200) {
      setState(() {
        dogImages.add(json.decode(response.body)[0]['url']);
      });
    } else {
      throw Exception('Failed to load images');
    }
  }

  fetch() async {
    final response = await http.get('https://dog.ceo/api/breeds/image/random');
    if (response.statusCode == 200) {
      setState(() {
        print(response.body);
        dogImages.add(json.decode(response.body)['message']);
      });
    } else {
      throw Exception('Failed to load images');
    }
  }

  fetchFive() {
    for (var i = 0; i < 7; i++) {
      fetch();
    }
  }
}
