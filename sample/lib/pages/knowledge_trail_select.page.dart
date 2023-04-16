import 'package:flutter/material.dart';
import 'package:grex_ds/grex_ds.dart';

import '../models/knowledge_trail_model.dart';

class KnowledgeTrailSelectPage extends StatefulWidget {
  final KnowledgeTrail? data;
  final ScrollController? controller;

  const KnowledgeTrailSelectPage({
    super.key,
    this.data,
    this.controller,
  });

  @override
  createState() => _KnowledgeTrailStateSelectPage();
}

class _KnowledgeTrailStateSelectPage extends State<KnowledgeTrailSelectPage> {
  late KnowledgeTrail _data;
  List<KnowledgeTrail> _knowledgeTrail = [];

  @override
  initState() {
    super.initState();

    _data =
        widget.data ?? const KnowledgeTrail(name: 'Undefined', priority: -1);

    _initList();
  }

  Future<void> _initList() async {
    // _knowledgeTrail = (await KnowledgeTrailService.list()).list.toList();
    _knowledgeTrail = [
      const KnowledgeTrail(name: 'Curso das Águas', priority: 1),
      const KnowledgeTrail(name: 'Consolidação', priority: 2),
      const KnowledgeTrail(name: 'Maturidade no Espírito', priority: 3),
      const KnowledgeTrail(name: 'Treinamento de Líderes', priority: 4),
      const KnowledgeTrail(name: 'Seminário', priority: 5),
    ];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Container(
      padding: EdgeInsets.only(
        top: 8.0,
        left: 8.0,
        right: 8.0,
        bottom: mediaQuery.viewInsets.bottom + mediaQuery.padding.bottom + 8.0,
      ),
      color: GrxColors.cfff2f7fd,
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: GrxUtils.defaultCardBorder,
        // margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GrxHeader(
              title: 'Trilho do Vencedor',
              showCloseButton: true,
            ),
            const SizedBox(height: 20),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _knowledgeTrail.length,
              itemBuilder: (context, index) {
                final trail = _knowledgeTrail[index];

                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          GrxBodyText(
                            trail.priority.toString(),
                            // style: trail.priority > _data.priority
                            //     ? peopleDetailsEnumeratorText
                            //     : peopleDetailsEnumeratorTextAppThemeColor,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            width: 11,
                            height: 11,
                            decoration: BoxDecoration(
                              // Circle shape
                              shape: BoxShape.circle,
                              color: trail.priority > _data.priority
                                  ? Colors.grey
                                  : Colors.green,
                            ),
                          ),
                          index < _knowledgeTrail.length - 1
                              ? trail.priority > _data.priority - 1
                                  ? Container(
                                      width: 4,
                                      height: 15,
                                      color: Colors.grey,
                                    )
                                  : Container(
                                      width: 4,
                                      height: 15,
                                      color: Colors.green,
                                    )
                              : const SizedBox(
                                  height: 15,
                                )
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: <Widget>[
                          GrxCaptionLargeText(
                            trail.name,
                          ),
                          const SizedBox(
                            height: 35,
                          )
                        ],
                      )
                    ],
                  ),
                  trailing: GestureDetector(
                    child: Container(
                      // margin: const EdgeInsets.only(bottom: 20),
                      child: GrxRoundedCheckbox(
                        radius: 10,
                        initialValue: trail.priority == _data.priority,
                        isTappable: false,
                      ),
                    ),
                  ),
                  onTap: () {
                    _data = trail;
                    Navigator.pop(context, _data);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
