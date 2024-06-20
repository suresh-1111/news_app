import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_app/home.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List articles = [];
  List filteredArticles = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    final box = Hive.box('newsBox');
    if (await hasInternetConnection()) {
      final response = await http.get(
        Uri.parse('https://newsapi.org/v2/top-headlines?country=us&apiKey=5c9c10436fb140abbff0a97a6c6e2365'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        articles = data['articles'];
        filteredArticles = articles;
        box.put('articles', articles);
      } else {
        throw Exception('Failed to load news');
      }
    } else {
      articles = box.get('articles', defaultValue: []);
      filteredArticles = articles;
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<bool> hasInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  void filterSearchResults(String query) {
    List dummySearchList = [];
    dummySearchList.addAll(articles);
    if (query.isNotEmpty) {
      List dummyListData = [];
      dummySearchList.forEach((item) {
        if (item['title'].toLowerCase().contains(query.toLowerCase()) ||
            item['description'].toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        filteredArticles.clear();
        filteredArticles.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        filteredArticles.clear();
        filteredArticles.addAll(articles);
      });
    }
  }

  Future<void> logout() async {
    // Clear Hive box
    final box = Hive.box('newsBox');
    await box.clear();

    // Sign out from Firebase
    await FirebaseAuth.instance.signOut();

    // Navigate to login page
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  String timeAgo(DateTime date) {
    Duration diff = DateTime.now().difference(date);
    if (diff.inDays > 1) {
      return '${diff.inDays} days ago';
    } else if (diff.inHours > 1) {
      return '${diff.inHours} hours ago';
    } else if (diff.inMinutes > 1) {
      return '${diff.inMinutes} minutes ago';
    } else {
      return 'just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      filterSearchResults(value);
                    },

                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Search in feed",
                      hintStyle: TextStyle(color: Colors.blue, fontSize: 25.0),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.blue,
                        size: 28.0,
                      ),

                    ),
                  ),

                ),

                IconButton(
                  icon: Icon(Icons.logout, color: Colors.blue, size: 28.0),
                  onPressed: logout,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredArticles.length,
              itemBuilder: (context, index) {
                final article = filteredArticles[index];
                final publishDate = DateTime.parse(article['publishedAt']);
                return Container(
                  color: Colors.white,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.white,
                    elevation: 5,
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${timeAgo(publishDate)} • ${article['source']['name']}',
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.6),
                                      fontSize: 12.0),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  article['title'] ?? '',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[900]),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  article['description'] ?? '',
                                  style: TextStyle(
                                      color: Colors.lightBlue, fontSize: 14.0),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          article['urlToImage'] != null
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Center(
                              child: CachedNetworkImage(
                                imageUrl: article['urlToImage'],
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(
                                        color: Colors.blue),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error, color: Colors.blue),
                              ),
                            ),
                          )
                              : Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey,
                            child: Container(
                                child: Icon(
                                  Icons.image,
                                  color: Colors.blue,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
