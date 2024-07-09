import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';

class FullScreenImageView extends StatefulWidget {
  final String imageurl;

  const FullScreenImageView({super.key, required this.imageurl});

  @override
  State<FullScreenImageView> createState() => _FullScreenImageViewState();
}

class _FullScreenImageViewState extends State<FullScreenImageView> {
  Future<void> setwallpaper(BuildContext context) async {
    int selectedLocation = WallpaperManager.HOME_SCREEN;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Select Wallpaper Location"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext, WallpaperManager.HOME_SCREEN);
                },
                child: Text("Home Screen"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext, WallpaperManager.LOCK_SCREEN);
                },
                child: Text("Lock Screen"),
              ),
            ],
          ),
        );
      },
    ).then((value) async {
      if (value != null) {
        selectedLocation = value;

        var file = await DefaultCacheManager().getSingleFile(widget.imageurl);

        final bool result = await WallpaperManager.setWallpaperFromFile(
            file.path, selectedLocation);

        if (result) {
          print("Wallpaper set successfully for selected location");
        } else {
          print("Failed to set wallpaper for selected location");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
           /* SizedBox(height: 80),*/
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(widget.imageurl),
              ),
            ),
            SizedBox(height: 90),
            InkWell(
              onTap: () {
                setwallpaper(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 26, vertical: 10),
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Set Wallaper",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
