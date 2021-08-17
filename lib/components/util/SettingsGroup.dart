import 'package:flutter/material.dart';

class SettingsGroup extends StatelessWidget {
  const SettingsGroup({
    Key? key,
    required this.title,
    this.subtitle = "",
    required this.onTrailingCallback,
  }) : super(key: key);
  final String title;
  final String subtitle;
  final VoidCallback onTrailingCallback;

  @override
  Widget build(BuildContext context) {
    final Size _deviceDimensions = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SizedBox(
          width: _deviceDimensions.width * 0.8,
          child: ListTile(
            title: Text(title),
            subtitle: Text(subtitle),
            trailing: IconButton(
                onPressed: onTrailingCallback, icon: Icon(Icons.edit)),
          ),
        ),
      ),
    );
  }
}
