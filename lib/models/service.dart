class Service {
  String uid;
  String workshopUid;
  String name;
  int minPrice;
  bool isActive;

  Service({
    this.uid = '',
    this.workshopUid = '',
    this.name = '',
    this.minPrice = 0,
    this.isActive = false,
  });

  @override
  String toString() => "$workshopUid, $name, $minPrice, $isActive";
}
