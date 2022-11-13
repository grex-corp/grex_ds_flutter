import 'package:flutter/material.dart';

abstract class GrxStatefulWidget extends StatefulWidget {
  GrxStatefulWidget({Key? key}) : super(key: key ?? UniqueKey());

  @override
  @factory
  @protected
  State<StatefulWidget> createState();
}
