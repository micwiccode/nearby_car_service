List<int> getYearsToNow(int startYear) {
  if (startYear < 0) {
    return [];
  }
  return new List<int>.generate(new DateTime.now().year - startYear + 1,
      (i) => new DateTime.now().year - i);
}
