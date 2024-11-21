import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../res/styles/app_styles.dart';

class AgentName extends StatefulWidget {
  const AgentName({super.key});

  @override
  State<AgentName> createState() => _AgentNameState();
}

class _AgentNameState extends State<AgentName> {
  final TextEditingController _controller =
      TextEditingController(); // 텍스트 입력 컨트롤러
  final _formKey = GlobalKey<FormState>(); // 폼 상태 관리 위한 글로벌 키(validate)

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Agent name",
          style: AppStyles.t1.copyWith(fontWeight: FontWeight.w500)),
      content: Form(
          // Form 필드 관리 및 검증 가능한 컨테이너
          // GlobalKey<FormState>를 통해 일반적인 폼의 상태를 제어
          // FormState를 통해 Form의 상태, 즉 연결된 모든 입력 필드의 상태를 확인하고 관리
          // 주로 ForState에는 validate(), save(), reset()이 있음
          key: _formKey, // 폼 키 설정, 폼 상태 검증 및 관리(validate)
          child: TextFormField(
            controller: _controller,
            // 텍스트 입력 필드의 컨트롤러 설정
            decoration: const InputDecoration(hintText: "Write down new name."),
            maxLength: 10,
            maxLines: 1,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9_]*$'))
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Name cannot be empty';
              }
              return null;
            },
          )),
      actions: <Widget>[
        TextButton(
            onPressed: () async {
              if (_formKey.currentState?.validate() ?? false) {
                // Form 검증
                final agentName = _controller.text;
                Navigator.of(context).pop(agentName);
                _controller.clear();
              }
            },
            child:
                const Text("Apply", style: TextStyle(color: Colors.lightGreen))),
        TextButton(
            onPressed: () {
              _controller.clear();
              Navigator.of(context).pop();
            },
            child: const Text("Cancel")),
      ],
    );
  }
}
