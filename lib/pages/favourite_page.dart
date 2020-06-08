import 'package:flutter/material.dart';

class FavouritePage extends StatefulWidget {
  @override
  _FavouritePageState createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  var images = [    
       "https://images.pexels.com/photos/3438178/pexels-photo-3438178.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",     
  ];

  @override
  Widget build(BuildContext context) {


    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[

            Container(alignment: Alignment.topLeft,margin: EdgeInsets.only(left: 20,top: 50,bottom: 0),child: Text("Favourite",style: TextStyle(fontSize: 50,color: Colors.white70,fontWeight: FontWeight.w300,letterSpacing: 4),)),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              childAspectRatio: 9 / 16,
              physics: NeverScrollableScrollPhysics(),
              children: images.map((image) {
                return Image(
                  image: NetworkImage(image),
                  fit: BoxFit.cover,
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}
