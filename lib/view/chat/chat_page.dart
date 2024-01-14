import 'package:flutter/material.dart';
import 'package:movemedriver/core/bloc/chat/chat_bloc.dart';
import 'package:movemedriver/model/chat_message.dart';
import 'package:movemedriver/theme.dart';
import 'package:movemedriver/view/chat/chat_message_driver.dart';
import 'package:movemedriver/view/chat/chat_message_me.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatBloc bloc;

  var _message = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    bloc.chatPageDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<ChatBloc>(context);

    return Scaffold(
        body: Column(children: <Widget>[
      Container(
          height: MediaQuery.of(context).size.height * 0.15,
          margin: EdgeInsets.only(bottom: 1.0),
          decoration: BoxDecoration(
              color: AppColors.colorGradientPrimary,
              borderRadius:
                  BorderRadius.only(bottomLeft: Radius.circular(25.0), bottomRight: Radius.circular(25.0))),
          child: Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
              IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: AppColors.colorWhite, size: 16.0),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              if (bloc.conversation?.user?.photo != null)
                ClipOval(
                    child: FadeInImage.assetNetwork(
                        image: bloc.conversation.user.photo,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        placeholder: 'assets/images/user.png'))
              else
                ClipOval(child: Image(image: AssetImage('assets/images/user.png'), height: 40)),
              Expanded(
                  child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                SizedBox(width: 20.0),
                Text(bloc.conversation?.user?.name ?? '',
                    overflow: TextOverflow.ellipsis, style: AppTextStyle.textWhiteSmallBold)
              ]))
            ])
          ]))),
      Expanded(
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              child: bloc.isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.colorGradientPrimary)))
                  : bloc.conversation.messages == null || bloc.conversation.messages.isEmpty
                      ? Center(
                          child: Text('Esta conversa ainda não possui mensagens',
                              style: AppTextStyle.textGreySmallBold, textAlign: TextAlign.center))
                      : NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification scrollInfo) {
                            if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent)
                              bloc.getOldMessages();
                            return true;
                          },
                          child: ListView.builder(
                              itemCount: bloc.conversation.messages.length,
                              reverse: true,
                              itemBuilder: (BuildContext context, int index) {
                                return bloc.conversation.messages[index].owner == 'mobile'
                                    ? ChatMessageMe(message: bloc.conversation.messages[index])
                                    : ChatMessageDriver(message: bloc.conversation.messages[index]);
                              })))),
      Container(
          color: AppColors.colorWhite,
          margin: EdgeInsets.only(top: 1.0),
          child: Container(
              decoration: BoxDecoration(
                  color: AppColors.colorGradientPrimary,
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(20.0), topLeft: Radius.circular(20.0))),
              child: Row(children: <Widget>[
                Expanded(
                    child: Container(
                        margin: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.colorWhite),
                            borderRadius: BorderRadius.circular(20.0)),
                        child: TextField(
                            controller: _message,
                            style: AppTextStyle.textWhiteSmall,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.send,
                            maxLines: 2,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                hintText: 'Digite sua Mensagem',
                                hintStyle: AppTextStyle.textWhiteSmall,
                                border: InputBorder.none)))),
                RotationTransition(
                    turns: AlwaysStoppedAnimation(315 / 360),
                    child: IconButton(
                        onPressed: () async => onSendMessage(),
                        icon: Icon(Icons.send, color: AppColors.colorWhite)))
              ])))
    ]));
  }

  void onSendMessage() async {
    if (_message.text.length > 0) {
      await bloc.createMessage(ChatMessage(
          message: _message.text, owner: 'driver', createdAt: DateTime.now(), id: bloc.conversation.id));
      _message.text = '';
    }
  }
}
