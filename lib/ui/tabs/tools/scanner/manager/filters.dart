class FilterParamsGainerLoser {
  // 2 = percent  3= volume
  int? sortBy;
  String? sortByHeader;
  bool? sortByAsc;
  FilterParamsGainerLoser({this.sortBy, this.sortByAsc, this.sortByHeader});
}

class FilterParams {
  double? bidStart, bidEnd;
  double? askStart, askEnd;
  double? lastTradeStart, lastTradeEnd;
  double? netChangeStart, netChangeEnd;
  double? perChangeStart, perChangeEnd;
  double? volumeStart, volumeEnd;
  double? dolorVolumeStart, dolorVolumeEnd;
  String? sector;
  String? symbolCompany;
  String? sortBy;
  bool? sortByAsc;

  FilterParams({
    this.bidStart,
    this.bidEnd,
    this.askStart,
    this.askEnd,
    this.lastTradeStart,
    this.lastTradeEnd,
    this.netChangeStart,
    this.netChangeEnd,
    this.perChangeStart,
    this.perChangeEnd,
    this.volumeStart,
    this.volumeEnd,
    this.dolorVolumeStart,
    this.dolorVolumeEnd,
    this.sector,
    this.symbolCompany,
    this.sortBy,
    this.sortByAsc,
  });
}
