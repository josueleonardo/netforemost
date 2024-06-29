import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class ArticlesPage extends StatefulWidget {
  @override
  _ArticlesPageState createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  List articles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/articles')); //articles
      if (response.statusCode == 200) {
        setState(() {
          articles = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load articles');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error fetching articles')));
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Articles',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.amberAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return ListTile(
            title:
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  const TextSpan(
                      text: 'Title: ',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18)),
                  TextSpan(
                      text: articles[index]['title'],
                      style: const TextStyle(fontSize: 18, color: Colors.black)
                  ),
                ],
              ),
            ),
            onTap: () => _launchURL(articles[index]['url']),
          );
        },
      ),
    );
  }
}