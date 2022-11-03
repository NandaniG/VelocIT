class FilterModel {
  int id;
  String name;
  bool isSelected;
  List<FilterDetailModel> filterDetailList;

  FilterModel(
      {required this.id,
      required this.name,
      this.isSelected = false,
      required this.filterDetailList});
}

class FilterDetailModel {
  int id;
  String name;
  bool isSelected;

  FilterDetailModel(
      {required this.id, required this.name, this.isSelected = false});
}

class FilterData {
  static List<FilterModel> filterList = [
    FilterModel(id: 1, name: "Merchants", isSelected: true, filterDetailList: [
      FilterDetailModel(id: 1, name: "Merchants 1", isSelected: false),
      FilterDetailModel(id: 2, name: "Merchants 2", isSelected: false),
      FilterDetailModel(id: 3, name: "Merchants 3", isSelected: false),
      FilterDetailModel(id: 4, name: "Merchants 4", isSelected: false),
    ]),
    FilterModel(id: 2, name: "Categories", filterDetailList: [
      FilterDetailModel(id: 1, name: "Categories 1", isSelected: false),
      FilterDetailModel(id: 2, name: "Categories 2", isSelected: false),
      FilterDetailModel(id: 3, name: "Categories 3", isSelected: false),
      FilterDetailModel(id: 4, name: "Categories 4", isSelected: false),
    ]),
    FilterModel(id: 3, name: "Pricing", filterDetailList: [
      FilterDetailModel(id: 1, name: "Pricing 1", isSelected: false),
      FilterDetailModel(id: 2, name: "Pricing 2", isSelected: false),
      FilterDetailModel(id: 3, name: "Pricing 3", isSelected: false),
      FilterDetailModel(id: 4, name: "Pricing 4", isSelected: false),
    ]),
    FilterModel(id: 4, name: "Availability", filterDetailList: [
      FilterDetailModel(id: 1, name: "Availability 1", isSelected: false),
      FilterDetailModel(id: 2, name: "Availability 2", isSelected: false),
      FilterDetailModel(id: 3, name: "Availability 3", isSelected: false),
      FilterDetailModel(id: 4, name: "Availability 4", isSelected: false),
    ]),
    FilterModel(id: 5, name: "Brand", filterDetailList: [
      FilterDetailModel(id: 1, name: "Brand 1", isSelected: false),
      FilterDetailModel(id: 2, name: "Brand 2", isSelected: false),
      FilterDetailModel(id: 3, name: "Brand 3", isSelected: false),
      FilterDetailModel(id: 4, name: "Brand 4", isSelected: false),
    ]),
  ];
}
