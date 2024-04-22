import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';
import '../models/response.dart';
import 'package:intl/intl.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference MessagesCollection = firestore.collection('Messages');

class MessagesFireCrud {
  static Stream<List<MessageModel>> fetchMessages() =>
      MessagesCollection.snapshots().map((snapshot) => snapshot.docs
          .map((doc) =>
              MessageModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList());

  static Future<Response> addMessage({
    required String userId,
    required String phone,
    required String content,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = MessagesCollection.doc();
    MessageModel user = MessageModel(
      id: "",
      date:
          "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
      content: content,
      time: DateFormat('hh:mm a').format(DateTime.now()),
      title: "Requested from $userId",
      timestamp: DateTime.now().millisecondsSinceEpoch,
      isViewed: false,
      phone: phone
    );
    user.id = documentReferencer.id;
    var json = user.toJson();
    var result = await documentReferencer.set(json).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully added to the database";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });
    return response;
  }
}
