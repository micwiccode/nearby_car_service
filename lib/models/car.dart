enum FuelType { petrol, gas, diesel, hybrid, electric }

class Car {
  String uid;
  String appUserUid;
  String mark;
  String model;
  String fuelType;
  int? productionYear;
  String avatar;

  Car({
    this.uid = '',
    this.appUserUid = '',
    this.mark = '',
    this.model = '',
    this.fuelType = 'Petrol',
    this.productionYear,
    this.avatar = '',
  });

  @override
  String toString() => "$mark, $model, $fuelType, $productionYear, $appUserUid, $avatar";
}
