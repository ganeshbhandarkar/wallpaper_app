import 'package:flutter/material.dart';

class FavouritePage extends StatefulWidget {
  @override
  _FavouritePageState createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  var images = [
    "https://images.pexels.com/photos/3438178/pexels-photo-3438178.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
    "https://images.pexels.com/photos/1351912/pexels-photo-1351912.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
    "https://images.pexels.com/photos/1092211/pexels-photo-1092211.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
    "https://images.pexels.com/photos/1092209/pexels-photo-1092209.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
    "https://images.pexels.com/photos/3426395/pexels-photo-3426395.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
    "https://images.pexels.com/photos/1128306/pexels-photo-1128306.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
    "https://images.pexels.com/photos/2092339/pexels-photo-2092339.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
    "https://images.pexels.com/photos/2441132/pexels-photo-2441132.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
    "https://images.pexels.com/photos/3414506/pexels-photo-3414506.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
    "https://images.pexels.com/photos/925384/pexels-photo-925384.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
    "https://images.pexels.com/photos/3693938/pexels-photo-3693938.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
    "https://images.pexels.com/photos/3693965/pexels-photo-3693965.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
    "https://images.pexels.com/photos/1126957/pexels-photo-1126957.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"
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
