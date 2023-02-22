import 'package:chatgpt/bloc/cubit.dart';
import 'package:chatgpt/bloc/states.dart';
import 'package:chatgpt/components/components.dart';
import 'package:chatgpt/models/chatModel.dart';
import 'package:chatgpt/shared/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController textEditingController = TextEditingController();
  late FocusNode focusNode;
  late ScrollController scrollController;
  @override
  void initState() {
    focusNode = FocusNode();
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatGptCubit()..getData(),
      child: BlocConsumer<ChatGptCubit, ChatGptStates>(
        builder: (context, state) {
          var cubit = ChatGptCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              leading: Image.asset(
                "assets/openai_logo.jpg",
                fit: BoxFit.fill,
                height: 45,
                width: 45,
              ),
              title: const Text(
                "ChatGPT",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                    onPressed: () async {
                      await showModel(
                        function: (v) {
                          cubit.modelOfDrop(v);
                        },

                        // value: cubit.model,
                        context: context,
                        items: cubit.getModel!,
                      );
                    },
                    icon: const Icon(
                      Icons.more_vert,
                      size: 24,
                      color: Colors.white,
                    ))
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ListView.separated(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                      itemBuilder: (context, index) => chat(
                          index: cubit.chatModel[index].chatIndex,
                          image: cubit.chatModel[index].chatIndex == 0
                              ? "assets/person.png"
                              : "assets/chat_logo.png",
                          text: cubit.chatModel[index].msg),
                      itemCount: cubit.chatModel.length,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                if (cubit.isType) ...[
                  const SpinKitThreeBounce(
                    color: Colors.white,
                    size: 18,
                  ),
                ],
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: double.infinity,
                  height: 55,
                  color: cardColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            focusNode: focusNode,
                            controller: textEditingController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration.collapsed(
                                hintText: "Write What You Want",
                                hintStyle: TextStyle(color: Colors.white)),
                          ),
                        ),
                        IconButton(
                            highlightColor: Colors.transparent,
                            // focusColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onPressed: () {
                              if (textEditingController.text.isNotEmpty &&
                                  cubit.isType == false) {
                                setState(() {
                                  cubit.isType = true;
                                });
                                cubit.postData(
                                    prompt: textEditingController.text);
                                cubit.chatModel.add(ChatModel(
                                    msg: textEditingController.text,
                                    chatIndex: 0));

                                textEditingController.clear();
                                focusNode.unfocus();
                              }
                            },
                            icon: const Icon(
                              Icons.send,
                              color: Colors.white,
                            ))
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
        listener: (context, state) {
          if (state is ChatGptOpenAiState) {
            ChatGptCubit.get(context).isType = false;
            scroll();
          }
        },
      ),
    );
  }

  void scroll() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 3), curve: Curves.bounceInOut);
  }
}
