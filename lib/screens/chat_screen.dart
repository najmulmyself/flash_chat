// ignore_for_file: missing_return

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
  String messageSender;

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

// THIS IS THE EXPLAINED CODE TO UNDERSTAND STREAMBUILDER | LETS ADD STERAMBUILDER TO EXECUTE REAL IMPLEMENTATION

  messagesStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data()); // paranthesis should be passed to data()
      }
    }

    // final snapshot = await _firestore.collection('messages').snapshots();
    // snapshot.forEach((element) {
    //   print(element.docs[0].data());
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
    // });
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
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('messages').snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                // this is the snapshot we got response from stream;
                //let's check if data null or not by checking snapshot.hasdata;
                if (snapshot.hasData) {
                  final messages = snapshot.data
                      .docs; // LIST OF ALL DOCUMENT | DEFAULT WAS DYNAMIC BY CHANGING QUERYSNAPSHOT IT CHANGES TO LIST OF QueryDocumentSnapshot
                  // REFACTOR CODE:
                  // MESSAGES SIMPLY IS A COLLECTION OF DOCUMENTS LIKE UID
                  // WE NEED TO LOOP THROUGH THOSE DOCUMENTS
                  // WE CAN USE FOREACH / MAP/ FOR IN LOOP TO ITERATE EACH ITEM
                  // WHY WE NEED TO ADD TYPE OF STREAM TO QUERYSNAPSHOT?
                  // NOT ADDING QUERYSNAPSHOT DOESN'T EFFECT ON RESULT

                  // print(messages[1]['sender']);

                  // messages.map((e) => print(e['text']));

                  // TESTING FOR EACH METHOD

                  //  messages.forEach((message) {
                  //     print('for each method:  ${message['text']}');
                  //   });
                  // didn't get why use need to use <QuerySnapshot> to change data type dynamic to QuerySnapshot;

                  List<Text> messageWidgets = [];
                  // messages.forEach(
                  //   (message) {

                  //   },
                  for (var message in messages) {

                    
// ERROR HAPPEND WAS Bad state: field does not exist within the DocumentSnapshotPlatform
// ref link : https://stackoverflow.com/questions/64949640/flutter-unhandled-exception-bad-state-field-does-not-exist-within-the-documen
// WHAT I CHANGED:
                    // CHANGED SNAPSHOT TO ASYNCSNAPSHOT IN BUILDER
                    // ACCESS EACH DATA MESSAGE.DATA()['TEXT'] INSTED OF MESSAGE['TEXT']

                    messageText = message.data()['text'];
                    messageSender = message.data()['sender'];

                    final messageWidget =
                        Text('$messageText from $messageSender');
                    messageWidgets.add(messageWidget);
                  }
                  // );
                  // for (var message in messages) {
                  //   final messageText = message;
                  //   // print('dummy data : ${message['sender']}');
                  //   // }
                  // }
                  // return messageText == null
                  //     ? Text('No data')
                  //     : Column(
                  //         children: [
                  //           Text(messageText),
                  //           Text(messageSender),
                  //         ],
                  //       );
                  return Column(
                    children: messageWidgets,
                  );

                  // ITS WORKING FOR A REASON 🙂 I DON'T KNOW WHY 
                }
              },
            ),
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
