class AppTransaction {
  String uid;
  String orderUid;
  String workshopUid;
  int price;

  AppTransaction({
    this.uid = '',
    this.orderUid = '',
    this.workshopUid = '',
    this.price = 0,
  });

  @override
  String toString() => "$uid, $orderUid, $workshopUid, $price";
}
