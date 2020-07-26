import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:brew_crew/models/user.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  String _currentName;
  String _currentSugars;
  int _currentStrength;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Text(
                      'Update your brew settings',
                      style: TextStyle(fontSize: 14.0),
                    ),
                    TextFormField(
                      initialValue: userData.name,
                      decoration: textInputDirection,
                      validator: (val) =>
                          val.isEmpty ? 'Please enter a name' : null,
                      onChanged: (val) => setState(() => _currentName = val),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    // dropdown
                    DropdownButtonFormField(
                        decoration: textInputDirection,
                        value: _currentSugars ?? userData.sugars,
                        items: sugars
                            .map((sugar) => DropdownMenuItem(
                                value: sugar, child: Text('$sugar sugar(s)')))
                            .toList(),
                        onChanged: (val) =>
                            setState(() => _currentSugars = val)),
                    SizedBox(
                      height: 10.0,
                    ),
                    Slider(
                        value:
                            (_currentStrength ?? userData.strength).toDouble(),
                        activeColor:
                            Colors.brown[_currentStrength ?? userData.strength],
                        inactiveColor:
                            Colors.brown[_currentStrength ?? userData.strength],
                        min: 100.0,
                        max: 900.0,
                        divisions: 8,
                        onChanged: (val) =>
                            setState(() => _currentStrength = (val).round())),
                    SizedBox(
                      height: 10.0,
                    ),
                    // slider
                    RaisedButton(
                      color: Colors.pink,
                      child: Text(
                        'Update data',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          await DatabaseService(uid: userData.uid)
                              .updateUserData(
                                  _currentName ?? userData.name,
                                  _currentSugars ?? userData.sugars,
                                  _currentStrength ?? userData.strength);
                          Navigator.pop(context);
                        }
                      },
                    )
                  ],
                ));
          } else {
            return Loading();
          }
        });
  }
}
