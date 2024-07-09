import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pexels/Screens/Full_Screen_Image/Full_Screen_Image_View.dart';

class UsingSliver extends StatefulWidget {
  @override
  _UsingSliverState createState() => _UsingSliverState();
}

class _UsingSliverState extends State<UsingSliver> {
  List<dynamic> images = [];

  int page = 1;

  @override
  void initState() {
    fetchapi();
    super.initState();
  }

  Future<void> fetchapi() async {
    String url = 'https://api.pexels.com/v1/curated?per_page=80&page=1';
    try {
      var response = await http.get(Uri.parse(url), headers: {
        'Authorization':
            'QZSA8nTC1tvf3dOgGPUa0j6b2S1WAp5oTiIB6vSLBnJwqhePApZx6anf',
      });

      if (response.statusCode == 200) {
        Map result = jsonDecode(response.body);
        setState(() {
          images = result['photos'];
        });
      } else {
        print("Failed to fetch data. Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  loadmore() async {
    setState(() {
      page = page + 1;
    });
    String url = 'https://api.pexels.com/v1/curated?per_page=80&page = ' +
        page.toString();
    await http.get(Uri.parse(url), headers: {
      'Authorization':
          'QZSA8nTC1tvf3dOgGPUa0j6b2S1WAp5oTiIB6vSLBnJwqhePApZx6anf'
    }).then(
      (value) {
        Map result = jsonDecode(value.body);
        setState(() {
          images.addAll(result['photos']);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: images.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  expandedHeight: 200.0,
                  floating: false,
                  pinned: true,
                  backgroundColor: Colors.black,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(
                      'Pexels',
                      style: TextStyle(
                        color: Colors.white54,
                      ),
                    ),
                    background: Image.network(
                      'https://img.freepik.com/free-vector/abstract-triangles-pattern-luxury-dark-blue_206725-634.jpg?t=st=1720529866~exp=1720533466~hmac=e51db39ebde58d9636bfc1a5ce1fd5b14fba7f9441c7ff2be9b1789f1e515051&w=1060',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SliverGrid.count(
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  crossAxisCount: 3,
                  childAspectRatio: 2 / 3,
                  children: List.generate(
                    images.length,
                    (index) {
                      if (index == images.length - 1) {
                        // Custom design for the last container
                        return InkWell(
                          onTap: () {
                            loadmore();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.black.withOpacity(
                                  0.5), // Custom background color for the last container
                            ),
                            child: Center(
                              child: Text(
                                '20 +',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        FullScreenImageView(
                                  imageurl: images[index]['src']['large2x'],
                                ),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  var begin = Offset(0.0, 1.0);
                                  var end = Offset.zero;
                                  var curve = Curves.ease;

                                  var tween = Tween(begin: begin, end: end)
                                      .chain(CurveTween(curve: curve));

                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Image.network(
                              images[index]['src']['tiny'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
