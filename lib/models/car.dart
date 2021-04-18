enum FuelType { petrol, gas, diesel, hybrid, electric }

class Car {
  String mark;
  String model;
  FuelType fuelType;
  int? productionYear;

  Car({
    this.mark = '',
    this.model = '',
    this.fuelType = FuelType.petrol,
    this.productionYear,
  });

  @override
  String toString() => "$mark, $model, $fuelType, $productionYear";
}
