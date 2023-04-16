import 'package:encryption_playground/chat/chat_cubit.dart';
import 'package:encryption_playground/chat/chat_state.dart';
import 'package:encryption_playground/model/chat.dart';
import 'package:encryption_playground/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatelessWidget {
  final User userToChatWith;
  final Chat chat;

  const ChatScreen({
    Key? key,
    required this.chat,
    required this.userToChatWith,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatCubit(chat, userToChatWith)..watchMessages(),
      child: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          late final Widget body;
          if (state.isLoading) {
            body = const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            body = _ChatBody(state: state);
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(userToChatWith.userEmail),
            ),
            body: body,
          );
        },
      ),
    );
  }
}

class _ChatBody extends StatefulWidget {
  final ChatState state;

  const _ChatBody({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  State<_ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<_ChatBody> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final body = widget.state.messages.isEmpty
        ? const Center(
            child: Text('There are no messages yet'),
          )
        : ListView.separated(
            padding: const EdgeInsets.all(16),
            reverse: true,
            itemBuilder: (context, index) {
              final message = widget.state.messages[index];

              return Row(
                children: [
                  if (message.isUserSender) const Spacer(),
                  Container(
                    width: 220,
                    padding: const EdgeInsets.all(16),
                    color: message.isUserSender
                        ? Colors.greenAccent
                        : Colors.amberAccent,
                    child: Text(message.message),
                  ),
                  if (!message.isUserSender) const Spacer(),
                ],
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemCount: widget.state.messages.length,
          );

    return SafeArea(
      child: Column(
        children: [
          Expanded(child: body),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _textEditingController,
                  onChanged: context.read<ChatCubit>().onMessageChanged,
                ),
              ),
              IconButton(
                onPressed: widget.state.enteredMessage.isEmpty
                    ? null
                    : () {
                        context.read<ChatCubit>().onSendMessage();
                        _textEditingController.clear();
                      },
                icon: Icon(
                  Icons.send,
                  color:
                      widget.state.enteredMessage.isEmpty ? null : Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
