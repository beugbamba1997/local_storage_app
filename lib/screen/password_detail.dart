import 'package:flutter/material.dart';
import 'package:local_storage_app/data/sembast_db.dart';
import 'package:local_storage_app/model/password.dart';
import 'package:local_storage_app/screen/password.dart';

class PasswordDetailDialog extends StatefulWidget {
  final Password password;
  final bool isNew;

  const PasswordDetailDialog(
      {super.key, required this.password, required this.isNew});

  @override
  State<PasswordDetailDialog> createState() => _PasswordDetailDialogState();
}

class _PasswordDetailDialogState extends State<PasswordDetailDialog> {
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  bool hidePasseword = true;
  @override
  Widget build(BuildContext context) {
    String title = (widget.isNew) ? 'Insert new Password' : 'Eddit Password';
    txtName.text = widget.password.name;
    txtPassword.text = widget.password.password;
    return AlertDialog(
      title: Text(title),
      content: Column(
        children: [
          TextField(
            controller: txtName,
            decoration: const InputDecoration(hintText: 'Description'),
          ),
          TextField(
            controller: txtPassword,
            obscureText: hidePasseword,
            decoration: InputDecoration(
                hintText: 'Password',
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      hidePasseword = !hidePasseword;
                    });
                  },
                  icon: hidePasseword
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off),
                )),
          )
        ],
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          onPressed: () {
            widget.password.name = txtName.text;
            widget.password.password = txtPassword.text;
            SembastDB db = SembastDB();
            (widget.isNew)
                ? db.addPasswword(widget.password)
                : db.updatePassword(widget.password);

            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PasswordScreens()));
          },
          child: const Text('Save'),
        ),
        ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
      ],
    );
  }
}
