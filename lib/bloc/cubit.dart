import 'dart:developer';
import 'package:chatgpt/bloc/states.dart';
import 'package:chatgpt/models/chatModel.dart';
import 'package:chatgpt/models/model.dart';
import 'package:chatgpt/models/openai.dart';
import 'package:chatgpt/shared/const.dart';
import 'package:chatgpt/shared/network/network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatGptCubit extends Cubit<ChatGptStates> {
  ChatGptCubit() : super(ChatGptInitialState());
  static ChatGptCubit get(context) => BlocProvider.of(context);
  OpenAi? openAi;
  void postData(
      {String model = "text-davinci-003",
      String? prompt,
      int maxTokens = 100}) {
    DioHelper.postUrl(
            path: completions,
            data: {"model": model, "prompt": prompt, "max_tokens": maxTokens})
        .then((value) {
      openAi = OpenAi.fromJson(value.data);
      // chatModel = List.generate(
      //   openAi!.choice.length,
      //   (index) => ChatModel(msg: openAi!.choice[index].text, chatIndex: 1),
      // );
      for (var e in openAi!.choice) {
        chatModel.add(ChatModel(msg: e.text, chatIndex: 1));
      }
      log(modelGetData!.data[3].id);

      emit(ChatGptOpenAiState());
    }).catchError((e) {
      log(e.toString());
    });
  }

  Model? modelGetData;
  List<ChatModel> chatModel = [];
  void getData() {
    DioHelper.getUrl(path: modelsUrl).then((value) {
      modelGetData = Model.fromJson(value.data);
      emit(ChatGptModelsUrlState());
    }).catchError((e) {
      log(e.toString());
    });
  }

  bool isType = false;
  List<DropdownMenuItem<dynamic>>? get getModel {
    List<DropdownMenuItem<dynamic>> items =
        List<DropdownMenuItem<dynamic>>.generate(
      modelGetData!.data.length,
      growable: true,
      (index) => DropdownMenuItem<String>(
        onTap: () {
          postData(prompt: modelGetData!.data[index].id);
        },
        value: modelGetData!.data[index].id,
        child: Text(
          modelGetData!.data[index].id,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
    return items;
  }

  var model = "Model 1";
  void modelOfDrop(String v) {
    model = v;
    emit(ChatGptModelState());
  }
}
