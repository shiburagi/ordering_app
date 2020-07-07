class Menu {
  String name;
  String category;
  double price;

  String id;

  Menu({this.name, this.category, this.price});

  Menu.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    category = json['category'];
    price = (json['price'] as num).toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['category'] = this.category;
    data['price'] = this.price;
    return data;
  }
}
