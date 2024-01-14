import 'package:flutter/material.dart';
import 'package:movemedriver/component/app_bar.dart';
import 'package:movemedriver/component/text_field_custom.dart';
import 'package:movemedriver/theme.dart';

class MultiSelectPage extends StatefulWidget {
  final String title;
  final List<SelectItem> items;
  final bool multi;

  MultiSelectPage({this.title, this.items, this.multi});

  @override
  _MultiSelectPageState createState() => _MultiSelectPageState();
}

class _MultiSelectPageState extends State<MultiSelectPage> {
  TextEditingController searchController;

  var term = '';

  List<SelectItem> get getList {
    return term.isNotEmpty
        ? widget.items.where((v) => v.text.toLowerCase().contains(term.toLowerCase())).toList()
        : widget.items;
  }

  void onConfirm() {
    var list = widget.items.where((e) => e.selected).toList();
    if (list.length == 0) {
      return;
    }
    Navigator.pop(context, [list]);
  }

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  void onChecked(SelectItem item) {
    if (widget.multi)
      setState(() {
        item.selected = !item.selected;
      });
    else
      return Navigator.pop(context, [item]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            child: AppBarCustom(title: widget.title ?? '', callback: () => Navigator.pop(context), actions: [
              if (widget.multi)
                InkWell(
                    onTap: () => this.onConfirm(),
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20), child: Center(child: Text('OK'))))
            ]),
            preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08)),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
              SizedBox(height: 20),
              TextFieldCustom(
                  isDecorationDefault: false,
                  label: 'Procurar',
                  keyBoardType: TextInputType.text,
                  controller: searchController,
                  onChanged: (value) {
                    this.term = value;
                    setState(() {});
                  }),
              Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.only(top: 15),
                      //scrollDirection: Axis.vertical,
                      //physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: getList.length,
                      itemBuilder: (BuildContext context, int index) {
                        var item = getList[index];

                        return InkWell(
                            onTap: () => this.onChecked(item),
                            child: Container(
                                //color: Colors.amber,
                                child:
                                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                              Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Flexible(
                                            child:
                                                Text(item.text, style: AppTextStyle.textBlueLightExtraSmall)),
                                        if (widget.multi)
                                          Checkbox(
                                              activeColor: AppColors.colorBlueDark,
                                              value: item.selected,
                                              onChanged: (value) => this.onChecked(item)),
                                        if (!widget.multi)
                                          Icon(Icons.navigate_next, color: AppColors.colorBlueLight)
                                      ])),
                              Divider(height: 1)
                            ])));
                      }))
            ])));
  }
}

class SelectItem {
  String id;
  String text;
  bool selected;

  SelectItem({this.id, this.text, this.selected});
}
