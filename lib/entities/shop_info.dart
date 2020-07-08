class ShopInfo {
  String name;
  List<String> address;

  String id;

  ShopInfo({this.name, this.address});

  ShopInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['address'] = this.address;
    return data;
  }
}
