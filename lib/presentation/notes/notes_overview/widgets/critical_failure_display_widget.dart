import 'package:flutter/material.dart';
import 'package:flutter_notes_app/domain/notes/note_failure.dart';

class CriticalFailureDisplay extends StatelessWidget {
  final NoteFailure noteFailure;

  const CriticalFailureDisplay({
    Key key,
    @required this.noteFailure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '😱',
            style: TextStyle(
              fontSize: 100,
            ),
          ),
          Text(
            noteFailure.maybeMap(
                insufficientPermissions: (_) => 'Insufficient permissions',
                orElse: () => 'Unexpected error. \nPlease, contact support.'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
            ),
          ),
          FlatButton(
            onPressed: () {
              print('Sending email!');
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                Icon(Icons.mail),
                SizedBox(width: 4),
                Text('I NEED HELP'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
