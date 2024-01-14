import 'package:flutter/material.dart';
import 'package:movemedriver/core/bloc/chat/chat_bloc.dart';
import 'package:movemedriver/theme.dart';
import 'package:movemedriver/view/chat/chat_list_item.dart';
import 'package:provider/provider.dart';

class ChatListPage extends StatefulWidget {
  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  ChatBloc bloc;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async => await bloc.getChatList());
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<ChatBloc>(context);

    return Stack(
      children: <Widget>[
        Container(decoration: BoxDecoration(color: AppColors.colorWhite)),
        Container(
          height: MediaQuery.of(context).size.height * 0.2,
          decoration: BoxDecoration(
              color: AppColors.colorGradientPrimary,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25.0), bottomRight: Radius.circular(25.0))),
          child: Center(
            child: Text(
              'Conversas',
              style: AppTextStyle.textBoldWhiteMedium,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2, left: 20.0, right: 20.0),
          child: bloc.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.colorGradientPrimary)),
                )
              : RefreshIndicator(
                  child: bloc.chats.isEmpty
                      ? Center(
                          child: Text('Nenhuma conversa para\nexibir no momento',
                              style: AppTextStyle.textGreySmallBold, textAlign: TextAlign.center),
                        )
                      : SingleChildScrollView(
                          child: Column(children: [
                          SizedBox(height: 30),
                          for (var chat in bloc.chats) ChatListItem(model: chat),
                          SizedBox(height: 30),
                        ])),
                  onRefresh: () async => await bloc.getChatList()),
        ),
        Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15, left: 20.0, right: 20.0),
          child: TextField(
            style: AppTextStyle.textGreyExtraSmall,
            keyboardType: TextInputType.text,
            textAlign: TextAlign.start,
            autofocus: false,
            /*onSubmitted: (String value) {
                        _checkCode();
                      },*/
            enableSuggestions: false,
            decoration: InputDecoration(
              fillColor: AppColors.colorWhite,
              filled: true,
              hintText: 'Procurar',
              hintStyle: AppTextStyle.textGreySmall,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: AppSizes.inputPaddingHorizontalDouble, vertical: AppSizes.inputPaddingVerticalDouble),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.colorGradientPrimary, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(AppSizes.inputRadiusDouble))),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.colorGreenLight, width: 0.0),
                  borderRadius: BorderRadius.all(Radius.circular(AppSizes.inputRadiusDouble))),
            ),
          ),
        ),
      ],
    );
  }
}
