import 'package:flutter/material.dart';

import '../utils/db_helper.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  var textcont1 = TextEditingController();
  var databaseValues = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: textcont1,
                decoration: InputDecoration(
                    hintText: "Enter values here",
                    label: Text("Values"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),

              // Insert
              ElevatedButton(
                  onPressed: () async {
                    var readQuery =
                        await DatabaseHelper.getInstance.queryDatabase();
                        _counter = readQuery.length;
                    // Map<String, dynamic> mp = {
                    //   DatabaseHelper.NOTES_ID: _counter++,
                    //   DatabaseHelper.NOTES_TEXT: textcont1.text.toString()
                    // };
                    await DatabaseHelper.getInstance.insertDatabase(
                      {
                        DatabaseHelper.NOTES_ID: _counter++,
                        DatabaseHelper.NOTES_TEXT: textcont1.text.toString()
                      }
                    );
                    

                    databaseValues = "Record Added!";
                    setState(() {});
                  },
                  child: Text("Create/Insert")),

              // Read
              ElevatedButton(
                  onPressed: () async {
                    var readQuery =
                        await DatabaseHelper.getInstance.queryDatabase();
                    databaseValues = readQuery.toString();
                    setState(() {});
                    print(databaseValues);
                  },
                  child: Text("Read")),
              // Update
              ElevatedButton(
                  onPressed: () async {
                    var readQuery =
                        await DatabaseHelper.getInstance.queryDatabase();
                    _counter = readQuery.length;
                    int res = await DatabaseHelper.getInstance.updateDatabase({
                      DatabaseHelper.NOTES_ID: _counter,
                      DatabaseHelper.NOTES_TEXT: "Hello World!"
                    });
                    (res == 1)
                        ? databaseValues = "Record Added Successfully!"
                        : databaseValues = "Record not added!";
                    // if(res == 1)
                    //   {
                    //     showDialog(context: context, builder: (context)=> Text("Data Updated"));
                    //   }
                    // else
                    //   {
                    //     showDialog(context: context, builder: (context)=> Text("Data Not Updated"));
                    //   }
                    setState(() {});
                  },
                  child: Text("Update")),
              // Delete
              ElevatedButton(
                  onPressed: () async {
                    var readQuery =
                        await DatabaseHelper.getInstance.queryDatabase();
                    _counter = readQuery.length;
                    int res = await DatabaseHelper.getInstance
                        .deleteDatabase(_counter);

                    if (res == 1) {
                      databaseValues = "Record Deleted";
                      _counter--;
                    } else
                      databaseValues = "Record Not Found!";
                    if (_counter < 0) _counter = 0;
                    // if(res == 1)
                    //   {
                    //     showDialog(context: context, builder: (context)=> Text("Record Deleted!"));
                    //   }
                    // else
                    //   {
                    //     showDialog(context: context, builder: (context)=> Text("Record not yet deleted"));
                    //   }
                    setState(() {});
                  },
                  child: Text("Delete")),

              ElevatedButton(
                  onPressed: () async {
                    var res =  await DatabaseHelper.getInstance
                        .queryDatabase();
                    databaseValues = res.length;
                    setState(() {});
                  },
                  child: Text("No of Records")),
              Text("Database contains:\n ${databaseValues ?? "Nothing"}"),
            ],
          ),
        ),
      ),
    );
  }
}
