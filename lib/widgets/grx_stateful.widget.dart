import 'package:material_ui/material_ui.dart';

abstract class GrxStatefulWidget extends StatefulWidget {
  GrxStatefulWidget({
    Key? key,
  }) : super(
          key: key ?? UniqueKey(),
        );

  @override
  @factory
  @protected
  State<StatefulWidget> createState();
}
