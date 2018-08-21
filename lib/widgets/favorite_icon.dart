import 'package:flutter/material.dart';
import 'package:movies_streams/pages/favorites.dart';

class FavoriteIcon extends StatelessWidget {
  FavoriteIcon({
    Key key,
    this.counter,
  }): super(key: key);

  final int counter;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: (){
        Navigator.of(context)
                 .push(MaterialPageRoute(builder: (BuildContext context) {
                    return FavoritesPage();
                  }));
      },
      icon: Stack(
        overflow: Overflow.visible,
        children: [
          Icon(Icons.favorite),
          Positioned(
            top: -12.0,
            right: -6.0,
            child: Material(
              type: MaterialType.circle,
              elevation: 2.0,
              color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  counter.toString(),
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),    
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}