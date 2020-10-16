import 'package:flutter/cupertino.dart';
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
      body: Column(
        children: <Widget>[
          Container(
            // Sets the padding for all elements in the container
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            child: Row(
              // A list of contacts goes here I suppose? Or at least how they look :I
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
                        ]),
                    // The user icon
                    child: CircleAvatar(
                      radius: 30,
                      // For the image to work you need to
                      // update the pubspec.yaml file in the 'assets:' part
                      // with the image part
                      // TODO: figure out how that's done automatically
                      backgroundImage: AssetImage('assets/images/bone.png'),
                    )),
                // User's name by the icon, time, message preview
                Container(
                    // This makes the with of the element 65 % of the device-width
                    width: MediaQuery.of(context).size.width * 0.65,
                    padding: EdgeInsets.only(
                      left: 20,
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          // Assigns the content spacing
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Bestie', style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),),
                            Text('12:30pm', style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w300,
                              color: Colors.black54,
                            ),)
                          ],
                        ),
                        // SizedBox to make a gap between the two containers
                        SizedBox(height: 10),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text('I got the drugz', style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                          overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
