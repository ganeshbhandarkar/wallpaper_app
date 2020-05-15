import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class WallpaperView extends StatefulWidget {

  String image;

  WallpaperView({
    this.image
  });

  @override
  _WallpaperViewState createState() => _WallpaperViewState();
}

class _WallpaperViewState extends State<WallpaperView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    child: Hero(
                      tag: widget.image,
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: widget.image,
                        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child: SafeArea(
                        child: Icon(Icons.close),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
