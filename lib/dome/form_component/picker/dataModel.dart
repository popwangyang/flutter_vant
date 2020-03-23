
class ObjectPicker {
  List<String> values;
  int defaultIndex;

  ObjectPicker({this.values, this.defaultIndex});

  ObjectPicker.fromJson(Map<String, dynamic> json) {
    values = json['values'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['values'] = this.values;
    return data;
  }
}

class ObjectCascadePicker {
  String text;
  List<Map<String, dynamic>> children;

  ObjectCascadePicker({this.text, this.children});

  ObjectCascadePicker.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    if (json['children'] != null) {
      children = new List<Map<String, dynamic>>();
      json['children'].forEach((v) {
        children.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    if (this.children != null) {
      data['children'] = this.children;
    }
    return data;
  }
}