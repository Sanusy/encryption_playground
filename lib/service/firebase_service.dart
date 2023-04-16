import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:encryption_playground/model/chat.dart';
import 'package:encryption_playground/model/encrypted_message.dart';
import 'package:encryption_playground/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, GoogleAuthProvider;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pointycastle/asymmetric/api.dart';

class FirebaseService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final _usersCollectionId = 'Users';
  final _chatsCollectionId = 'Chats';
  final _messagesCollectionId = 'Messages';

  String? get currentUserId => _auth.currentUser?.uid;

  Future<String?> logInWithGoogle(RSAPublicKey publicKey) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final userCredentials = await _auth.signInWithCredential(credential);

    final user = User(
      id: userCredentials.user!.uid,
      userEmail: userCredentials.user!.email!,
      publicKeyModulus: publicKey.modulus.toString(),
      publicKeyExponent: publicKey.publicExponent.toString(),
    );

    final List<QueryDocumentSnapshot> userChats = [];

    userChats.addAll(await _firestore
        .collection(_chatsCollectionId)
        .where('firstUserId', isEqualTo: userCredentials.user!.uid)
        .get()
        .then((chats) => chats.docs));

    userChats.addAll(await _firestore
        .collection(_chatsCollectionId)
        .where('secondUserId', isEqualTo: userCredentials.user!.uid)
        .get()
        .then((chats) => chats.docs));

    await Future.wait(userChats.map((e) => e.reference.delete()));

    await _firestore
        .collection(_usersCollectionId)
        .doc(userCredentials.user?.uid)
        .set(user.toJson());

    return userCredentials.user?.uid;
  }

  Future<List<User>> loadUsers() {
    return _firestore.collection(_usersCollectionId).get().then((docs) {
      final List<User> users = [];
      for (final doc in docs.docs) {
        users.add(User.fromJson(doc.data()));
      }
      return users;
    });
  }

  Future<void> logOut() {
    return _auth.signOut();
  }

  Future<Chat> chatWithUser(User user) async {
    final possibleChat = await _firestore
        .collection(_chatsCollectionId)
        .where('firstUserId', whereIn: [currentUserId!, user.id])
        .get()
        .then((chatsSnapshot) {
          if (chatsSnapshot.docs.isEmpty) {
            return null;
          }
          final chats =
              chatsSnapshot.docs.map((e) => Chat.fromJson(e.data())).toList();

          final chat = chats.firstWhereOrNull((possibleChat) {
            if (possibleChat.firstUserId == currentUserId) {
              return possibleChat.secondUserId == user.id;
            }
            return possibleChat.firstUserId == user.id;
          });

          return chat;
        });

    if (possibleChat != null) return possibleChat;

    final chatDoc = _firestore.collection(_chatsCollectionId).doc();

    final chat = Chat(
      id: chatDoc.id,
      firstUserId: currentUserId!,
      secondUserId: user.id,
    );

    await chatDoc.set(chat.toJson());

    return chat;
  }

  Future<void> sendMessage(
    Chat chat,
    String rsaMessage,
    String aesMessage,
  ) async {
    final messageDoc = _firestore
        .collection('$_chatsCollectionId/${chat.id}/$_messagesCollectionId')
        .doc();

    final encryptedMessage = EncryptedMessage(
      id: messageDoc.id,
      senderId: currentUserId!,
      rsaEncryptedMessage: rsaMessage,
      aesEncryptedMessage: aesMessage,
    );

    await messageDoc.set(encryptedMessage.toJson());
  }

  Stream<EncryptedMessage> watchMessages(Chat chat) {
    return _firestore
        .collection('$_chatsCollectionId/${chat.id}/$_messagesCollectionId')
        .snapshots()
        .map((event) => event.docChanges
            .where((change) => change.type == DocumentChangeType.added)
            .map((change) => EncryptedMessage.fromJson(change.doc.data()!))
            .toList())
        .expand((messages) => messages);
  }
}
