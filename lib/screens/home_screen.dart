import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        // Menu button
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {}, //TODO: Implement menu functionality
        ),
        title: Text('Inbox'),
      ),
      body: Container(
        // Sets the padding for all elements in the container
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
         child: Row(
           // A list of contacts goes here I suppose?
           children: <Widget>[
             Container(
               // Sets the padding between the user icon and the little ring around it :3
               padding: EdgeInsets.all(1),
               // Makes the user icon pretty :3
               decoration: BoxDecoration(
                 // User icon border
                 border: Border.all(
                   width: 2,
                   color: Theme.of(context).primaryColor,
                 ),
                 // Shape of the icon shadow
                 shape: BoxShape.circle,
                 // The icon shadow itself
                 boxShadow: [
                   BoxShadow(
                     color: Colors.grey.withOpacity(0.5),
                     spreadRadius: 2,
                     blurRadius: 5,
                   )
                 ]
               ),
               // The user icon
               child: CircleAvatar(
                 radius: 35,
                 // For the image to work you need to
                 // update the pubspec.yaml file in the 'assets:' part
                 // with the image part
                 // TODO: figure out how that's done automatically
                 backgroundImage: AssetImage('assets/images/bone.png'),
               )
             )
           ],
         ),
      )
    );
  }
}
