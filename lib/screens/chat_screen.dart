import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  var loggedInUser;
  String messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser);
      }
    } catch (e) {
      print(e);
    }
  }

  messagesStream() async {
    // await for (var snapshot in _firestore.collection('messages').snapshots()) {
    //   for (var message in snapshot.docs) {
    //     print(message.data()); // paranthesis should be passed to data()
    //   }
    // }

    final snapshot = await _firestore.collection('messages').snapshots();
    snapshot.forEach((element) {
      print(element.docs[0].data());
      // THIS IS THE TESTING FOR A STEREAM BUILDER

      // STREAMBUILDRE HAS QUIET FEW STEPS

      //1. NEED TO CALL ITS COLLECTION ON COLLECTION('COLLECTION NAME')
      //2. THEN CALL THE SNAPSHOT METHOD ON IT
      //3. THEN CALL THE FOREACH METHOD ON IT (SNAPSHOTS RETURN SNAPSHOT OBJECTS)
            //A. SNAPSHOT IS A PICTURE OF ALL DATA => LIKE WHOLE FIREBASE DATA INCLUDING COLLECTION | WE NEED TO EXTARCT ONLY DOCUMENT BY CALLING DOCS() METHOD ON IT
      //4. THEN SNAPSHOT HAS ALL THE DATA FRAME(PICTURE) , TO ACCESS DOCUMENTS WE NEED TO CALL DOCS() METHOD ON IT | SNAPSHOT.DOCS() RETURNS A LIST OF DOCUMENTS
      //5. SNAPSHOT.DOCS() IS A LIST OF DOUCMENT, SO WE CAN ITARATE OVER IT USING FOREACH METHOD
      //6. ITERATING SNAPSHOT.DOCS(), WE CAN FIND EACH OF THE AVAILABLE DOCUMENT
      //7. AFTER CALLING DATA() ON DOCUMENT, WE CAN GET THE REAL DATA OF EACH DOCUMENT
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons
                  .close), // changed icon to another one for retriving data from firebase
              onPressed: () {
                messagesStream();
                // _auth.signOut();
                // Navigator.pop(context);
                //Implement logout functionality
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      //Implement send functionality.
                      // adding data to firestore
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser.email,
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
