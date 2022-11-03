class MerchantFilterModel {
  int id;
  String name;
  bool isSelected;
  List<MerchantFilterDetailModel> filterDetailList;

  MerchantFilterModel(
      {required this.id,
        required this.name,
        this.isSelected = false,
        required this.filterDetailList});
}

class MerchantFilterDetailModel {
  int id;
  String name;
  bool isSelected;

  MerchantFilterDetailModel(
      {required this.id, required this.name, this.isSelected = false});
}

class MerchantFilterData {
  static List<MerchantFilterModel> merchantFilterList = [

    MerchantFilterModel(id: 2, name: "Categories", filterDetailList: [
      MerchantFilterDetailModel(id: 1, name: "Categories 1", isSelected: false),
      MerchantFilterDetailModel(id: 2, name: "Categories 2", isSelected: false),
      MerchantFilterDetailModel(id: 3, name: "Categories 3", isSelected: false),
      MerchantFilterDetailModel(id: 4, name: "Categories 4", isSelected: false),
    ]),
    MerchantFilterModel(id: 3, name: "KM Range", filterDetailList: [
      MerchantFilterDetailModel(id: 1, name: "KM Range 1", isSelected: false),
      MerchantFilterDetailModel(id: 2, name: "KM Range 2", isSelected: false),
      MerchantFilterDetailModel(id: 3, name: "KM Range 3", isSelected: false),
      MerchantFilterDetailModel(id: 4, name: "KM Range 4", isSelected: false),
    ]),
    MerchantFilterModel(id: 4, name: "TBD", filterDetailList: [
      MerchantFilterDetailModel(id: 1, name: "TBD 1", isSelected: false),
      MerchantFilterDetailModel(id: 2, name: "TBD 2", isSelected: false),
      MerchantFilterDetailModel(id: 3, name: "TBD 3", isSelected: false),
      MerchantFilterDetailModel(id: 4, name: "TBD 4", isSelected: false),
    ]),
    MerchantFilterModel(id: 5, name: "TBD", filterDetailList: [
      MerchantFilterDetailModel(id: 1, name: "TBD 1", isSelected: false),
      MerchantFilterDetailModel(id: 2, name: "TBD 2", isSelected: false),
      MerchantFilterDetailModel(id: 3, name: "TBD 3", isSelected: false),
      MerchantFilterDetailModel(id: 4, name: "TBD 4", isSelected: false),
    ]),
  ];
}
