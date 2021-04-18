

List<int> getYearsToNow(int startYear) {
  return new List<int>.generate(
      new DateTime.now().year - startYear, (i) => new DateTime.now().year - i);
}

