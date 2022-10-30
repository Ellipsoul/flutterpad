import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterpad/colors.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutterpad/common/widgets/loader.dart';
import 'package:flutterpad/repository/auth_repository.dart';
import 'package:flutterpad/repository/document_repository.dart';
import 'package:flutterpad/repository/models/document_model.dart';
import 'package:flutterpad/repository/models/error_model.dart';
import 'package:flutterpad/repository/socket_repository.dart';
import 'package:routemaster/routemaster.dart';

// Screen for editing a document
class DocumentScreen extends ConsumerStatefulWidget {
  final String id;
  const DocumentScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  // Controllers for title and text editing
  TextEditingController titleController =
      TextEditingController(text: "Untitled Document");
  quill.QuillController? _controller = quill.QuillController.basic();
  ErrorModel? errorModel;
  SocketRepository socketRepository = SocketRepository();

  @override
  void initState() {
    super.initState();
    socketRepository.joinRoom(widget.id);
    fetchDocumentData();

    socketRepository.changeListener((data) => {
          _controller?.compose(
            quill.Delta.fromJson(data["delta"]),
            _controller?.selection ?? const TextSelection.collapsed(offset: 0),
            quill.ChangeSource.REMOTE,
          )
        });

    Timer.periodic(const Duration(seconds: 2), (timer) {
      socketRepository.autoSave(<String, dynamic>{
        'delta': _controller!.document.toDelta(),
        'room': widget.id
      });
    });
  }

  void fetchDocumentData() async {
    errorModel = await ref.read(documentRepositoryProvider).getDocumentById(
          ref.read(userProvider)!.token,
          widget.id,
        );

    // Document has been correctly retrieved
    if (errorModel!.data != null) {
      titleController.text = (errorModel!.data as DocumentModel).title;
      _controller = quill.QuillController(
          document: errorModel!.data.content.isEmpty
              ? quill.Document()
              : quill.Document.fromDelta(
                  quill.Delta.fromJson(errorModel!.data.content)),
          selection: const TextSelection.collapsed(offset: 0));
      setState(() {}); // Refreshes the state
    }

    _controller!.document.changes.listen((event) {
      if (event.item3 == quill.ChangeSource.LOCAL) {
        Map<String, dynamic> map = {
          'delta': event.item2,
          'room': widget.id,
        };
        socketRepository.typing(map);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
  }

  // Title update when user presses enter while editing title
  void updateTitle(WidgetRef ref, String title) {
    ref.read(documentRepositoryProvider).updateTitle(
          token: ref.read(userProvider)!.token,
          id: widget.id,
          title: title,
        );
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Scaffold(body: Loader());
    }

    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: colorBlack),
          backgroundColor: colorWhite,
          elevation: 0,
          actions: [
            // Share Button
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton.icon(
                onPressed: (() {
                  Clipboard.setData(
                    ClipboardData(
                      text: 'http://localhost:3000/#/document/${widget.id}',
                    ),
                  ).then((value) => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Link Copied!'))));
                }),
                icon: const Icon(
                  Icons.lock,
                  size: 16,
                ),
                label: const Text('Share'),
                style: ElevatedButton.styleFrom(backgroundColor: colorBlue),
              ),
            )
          ],
          // Editable document title
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(children: [
              GestureDetector(
                  onTap: (() {
                    Routemaster.of(context).replace('/');
                  }),
                  child: Image.asset('assets/docs-logo.png', height: 40)),
              const SizedBox(width: 10),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: colorBlue),
                        borderRadius: BorderRadius.all(Radius.circular(3))),
                    contentPadding: EdgeInsets.only(left: 10),
                  ),
                  onSubmitted: (value) => updateTitle(ref, value),
                ),
              ),
            ]),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: colorGrey,
                  width: 0.1,
                ),
              ),
            ),
          ),
        ),
        // Centered Quill toolbar and editing area
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),
              quill.QuillToolbar.basic(controller: _controller!),
              const SizedBox(height: 10),
              Expanded(
                child: SizedBox(
                  width: 750,
                  child: Card(
                    color: colorWhite,
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: quill.QuillEditor.basic(
                        controller: _controller!,
                        readOnly: false,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
