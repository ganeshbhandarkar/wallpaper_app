import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wallpaperapp/pages/add_wallpaper_screen.dart';
import 'package:wallpaperapp/pages/wallpaper_view_screen.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

//  var images = [
//    "https://images.pexels.com/photos/2168356/pexels-photo-2168356.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
//    "https://images.pexels.com/photos/2610722/pexels-photo-2610722.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
//    "https://images.pexels.com/photos/2991754/pexels-photo-2991754.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
//    "https://images.pexels.com/photos/3257654/pexels-photo-3257654.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"
//  ];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  FirebaseUser _user;

  @override
  void initState() {
    // TODO: implement initState
    _fetchUserData();
    super.initState();
  }

  _fetchUserData() async {
    try {
      FirebaseUser u = await _auth.currentUser();
      setState(() {
        _user = u;
      });
    } catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> WallpaperAdd(),fullscreenDialog: true));
        },
        label: Text("ADD"),
        icon: Icon(FontAwesomeIcons.adjust),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: _user!=null?Column(
            children: <Widget>[
              Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 100),
                  height: 100,
                  alignment: Alignment.center,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: FadeInImage(
                        image: NetworkImage("${_user.photoUrl}"),
                        placeholder: AssetImage("assets/placeholder.jpg"),
                      ))),
              Container(
                child: Text(
                  _user.displayName,
                  style: TextStyle(
                    fontSize: 20,
                    letterSpacing: 2,
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: EdgeInsets.all(30),
              ),
              RaisedButton(
                child: Text("Sign out"),
                onPressed: () {
                  _auth.signOut();
                },
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.all(10),
                width: 130,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "My Wallpapers",
                  style: TextStyle(fontSize: 15, color: Colors.white70),
                ),
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 10),
              ),

              StreamBuilder(
                stream: _db.collection("wallpapers").where("uploaded_by",isEqualTo: _user.uid).orderBy("date",descending: true).snapshots(),
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

                          onLongPress: (){
                            showDialog(
                                context: context,
                                builder: (cxt){
                                  return AlertDialog(
                                    title: Text("Delete the Post"),
                                    content: Text("Do you want to delete the Post ?"),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("Cancel"),
                                        onPressed: (){
                                          Navigator.pop(cxt);
                                        },

                                      ),
                                      RaisedButton(
                                        child: Text("Yes"),
                                        onPressed: (){

                                          _db.collection("wallpapers").document(snapshot.data.documents[index].documentID).delete();
                                          Navigator.pop(cxt);
                                          setState(() {

                                          });

                                        },
                                      )
                                    ],
                                  );
                                }
                            );
                          },

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
//              GridView.count(
//                crossAxisCount: 3,
//                shrinkWrap: true,
//                childAspectRatio: 9 / 16,
//                physics: NeverScrollableScrollPhysics(),
//                children: images.map((image) {
//                  return Image(
//                    image: NetworkImage(image),
//                    fit: BoxFit.cover,
//                  );
//                }).toList(),
//              )

            ],
          ):LinearProgressIndicator(),
        ),
      ),
    );
  }


  void _deletePost() async {



}
}
