import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/data/data_model.dart';
import 'package:sitemarker/data/dbrecord_provider.dart';

class PageEdit extends StatelessWidget {
  final DBRecord record;
  final _formkey = GlobalKey<FormState>();

  PageEdit({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    String recName = '';
    String recUrl = '';
    List<String> recTags = [];
    String recTagString = '';
    List<String> nameList = [];
    List<String> urlList = [];
    late List<DBRecord> dbRec;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Record",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<DBRecordProvider>(builder: (context, value, child) {
        dbRec = value.records;
        for (int i = 0; i < dbRec.length; i++) {
          nameList.add(dbRec[i].name);
          urlList.add(dbRec[i].url);
        }
        return Center(
          child: Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.all(150),
              child: Wrap(
                spacing: 200,
                children: <Widget>[
                  TextFormField(
                    maxLength: 100,
                    autofocus: true,
                    initialValue: record.name,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.subject),
                      hintText: 'Enter the name to be associated with the URL',
                      labelText: 'Name *',
                    ),
                    validator: (name) {
                      if (name == null || name.isEmpty) {
                        return "Please enter a name.";
                      } else if (nameList.contains(name)) {
                        if (name != record.name) {
                          return 'The name entered has been associated with a different record.';
                        }
                      }
                      return null;
                    },
                    onSaved: (name) {
                      recName = name!;
                    },
                  ),
                  TextFormField(
                    initialValue: record.url,
                    maxLength: 250,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.link),
                      hintText: 'Enter the URL',
                      labelText: 'URL *',
                    ),
                    validator: (url) {
                      if (url == null || url.isEmpty) {
                        return "Please enter a link";
                      }
                      if (!Uri.parse(url).isAbsolute) {
                        return "Please enter a valid URL";
                      }
                      if (urlList.contains(url)) {
                        if (url != record.url) {
                          return 'The URL entered has been associated with a different record.';
                        }
                      }
                      return null;
                    },
                    onSaved: (url) {
                      recUrl = url!;
                    },
                  ),
                  TextFormField(
                    initialValue: record.tags,
                    maxLength: 250,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.tag),
                      hintText:
                          'Enter the tags to be associated with the URL separated by comma',
                      labelText: 'Tags (separated by ,)',
                    ),
                    validator: (tags) {
                      return null;
                    },
                    onSaved: (tags) {
                      List<String> tagList = [];
                      if (tags != null && tags.isNotEmpty) {
                        List<String> tmp = tags.split(',');
                        for (int i = 0; i < tmp.length; i++) {
                          tagList.add(tmp[i]);
                        }
                      }
                      recTags = tagList;
                      for (int i = 0; i < recTags.length; i++) {
                        recTagString += recTags[i];
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 250, vertical: 30),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            recName = '';
                            recUrl = '';
                            recTagString = '';
                            recTags = [];
                            Navigator.pop(
                              context,
                            );
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.cancel),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Cancel"),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 100,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Provider.of<DBRecordProvider>(context,
                                    listen: false)
                                .deleteRecord(record);
                            if (_formkey.currentState!.validate()) {
                              _formkey.currentState!.save();
                              record.name = recName;
                              record.url = recUrl;
                              record.tags = recTagString;
                              Provider.of<DBRecordProvider>(context,
                                      listen: false)
                                  .insertRecord(record);
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                            }
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.save),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Save record"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
