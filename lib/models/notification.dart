class AppNotification {
  String uid;
  String receiverUserUid;
  String senderUid;
  String type;
  bool isSeen;
  bool isAccepted;
  bool isRejected;

  AppNotification(
      {this.uid = '',
      this.receiverUserUid = '',
      this.senderUid = '',
      this.type = '',
      this.isSeen = false,
      this.isAccepted = false,
      this.isRejected = false});

  @override
  String toString() =>
      "$uid, $receiverUserUid, $senderUid, $isSeen, $isAccepted, $isRejected, $type";
}
