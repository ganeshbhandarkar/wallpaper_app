import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallpaperapp/pages/wallpaper_view_screen.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
//  var images = [
//    "https://images.pexels.com/photos/3438178/pexels-photo-3438178.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
//    "https://images.pexels.com/photos/1351912/pexels-photo-1351912.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
//    "https://images.pexels.com/photos/1092211/pexels-photo-1092211.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
//    "https://images.pexels.com/photos/1092209/pexels-photo-1092209.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
//    "https://images.pexels.com/photos/3426395/pexels-photo-3426395.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
//    "https://images.pexels.com/photos/1128306/pexels-photo-1128306.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
//    "https://images.pexels.com/photos/2092339/pexels-photo-2092339.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
//    "https://images.pexels.com/photos/2441132/pexels-photo-2441132.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
//    "https://images.pexels.com/photos/3414506/pexels-photo-3414506.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
//    "https://images.pexels.com/photos/925384/pexels-photo-925384.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
//    "https://images.pexels.com/photos/3693938/pexels-photo-3693938.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
//    "https://images.pexels.com/photos/3693965/pexels-photo-3693965.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
//    "https://images.pexels.com/photos/1126957/pexels-photo-1126957.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"
//  ];

  final Firestore _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child : Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 20, top: 50, bottom: 0),
                  child: Text(
                    "Explore",
                    style: TextStyle(
                        fontSize: 50,
                        color: Colors.white70,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 4),
                  )),
              StreamBuilder(
                stream: _db
                    .collection("wallpapers")
                    .orderBy("date", descending: true)
                    .snapshots(),
                builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return StaggeredGridView.countBuilder(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      itemCount: snapshot.data.documents.length,
                      physics: NeverScrollableScrollPhysics(),
                      staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                      itemBuilder: (ctx, index) {
                        return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (cxt) =>
                                          WallpaperView(image: snapshot.data
                                              .documents[index].data["url"])));
                            },
                            child: Hero(
                              tag: snapshot.data.documents[index].data["url"],
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: snapshot.data.documents[index]
                                        .data["url"],
                                    placeholder: (cxt, url) =>
                                        Container(child: Center(child: CircularProgressIndicator())),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                              ),
                            ),
                        );
                      },
                    );
                  }
                  return Container(height: MediaQuery.of(context).size.width,child: Center(child: CircularProgressIndicator()));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/*

GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    childAspectRatio: 9 / 16,
                    physics: NeverScrollableScrollPhysics(),
                    children: snapshot.data.documents.map((image) {
//                return Image(
//                  image: NetworkImage(image),
//                  fit: BoxFit.cover,
//                );
                      return InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (cxt)=> WallpaperView(image: image,)));
                        },
                        child: Hero(
                          tag: image,
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: image,
                            placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),
                        ),
                      );
                    }).toList(),
                  );

 */
