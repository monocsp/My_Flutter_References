import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AutoFillPage(),
    );
  }
}

class AutoFillPage extends StatefulWidget {
  const AutoFillPage({Key? key}) : super(key: key);

  @override
  _AutoFillPageState createState() => _AutoFillPageState();
}

class _AutoFillPageState extends State<AutoFillPage> {
  var isSameAddress = true;

  final billingAddress1Key = UniqueKey();
  final billingAddress2Key = UniqueKey();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Auto Fill"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: AutofillGroup(
              onDisposeAction: AutofillContextAction.commit,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Column(
                    children: [
                      TextFormField(
                        autofillHints: [AutofillHints.email],
                        validator: (value) =>
                            value!.isEmpty ? "some email please" : null,
                        decoration: const InputDecoration(
                          labelText: 'email',
                          hintText: 'enter email adress',
                        ),
                      ),
                      TextFormField(
                        autofillHints: [AutofillHints.password],
                        validator: (value) =>
                            value!.isEmpty ? "some password please" : null,
                        decoration: const InputDecoration(
                          labelText: 'password',
                          hintText: 'enter your password',
                        ),
                      ),
                    ],
                  ),
                  MaterialButton(
                    child: Text("submit"),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        TextInput.finishAutofillContext(shouldSave: true);
                        debugPrint("----> Naigate to 2nd Page");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SecondRoute()),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  @override
  void dispose() {
    debugPrint("Form widget disposed");
    super.dispose();
  }
}

class SecondRoute extends StatefulWidget {
  @override
  _SecondRouteState createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            debugPrint("----> Naigate back to first page");
            Navigator.pop(context);
            //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp()));
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    debugPrint("2nd Screen widget disposed");
    super.dispose();
  }
}
