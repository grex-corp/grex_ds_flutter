import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

import '../../extensions/list.extension.dart';
import '../../models/grx_country.model.dart';
import '../../themes/colors/grx_colors.dart';
import '../../utils/grx_country.util.dart';
import '../../utils/grx_utils.util.dart';
import '../checkbox/grx_rounded_checkbox.widget.dart';
import '../fields/grx_search_field.widget.dart';
import '../grx_card.widget.dart';
import '../typography/grx_body_text.widget.dart';
import '../typography/grx_headline_small_text.widget.dart';

class GrxBottomSheetCountries extends StatefulWidget {
  const GrxBottomSheetCountries({
    super.key,
    required this.selectedCountry,
  });

  final GrxCountry selectedCountry;

  @override
  State<StatefulWidget> createState() => _GrxBottomSheetCountriesState();
}

class _GrxBottomSheetCountriesState extends State<GrxBottomSheetCountries> {
  final searchFieldController = TextEditingController();
  final _filteredCountries = <GrxCountry>[...GrxCountryUtils.countries];

  bool showClearButton = false;
  late GrxCountry selectedCountry = widget.selectedCountry;

  Future<void> _onSearch(final String searchString) async {
    setState(() {
      showClearButton = searchString.isNotEmpty;
      _filteredCountries.assignAll(
        GrxCountryUtils.countries.where((country) =>
            country.name.toLowerCase().contains(searchString.toLowerCase()) ||
            country.code.toLowerCase().contains(searchString.toLowerCase())),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final viewInsets = mediaQuery.viewInsets;
    final padding = mediaQuery.padding;

    return ColoredBox(
      color: GrxColors.cfff2f7fd,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            titleSpacing: 0.0,
            toolbarHeight: 65.0,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 8.0,
              ),
              child: GrxSearchField(
                // searchFieldController: widget.quickSearchFieldController!,
                searchFieldController: searchFieldController,
                onChanged: _onSearch,
                hintText: 'Search',
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(
              left: 8.0,
              top: 8.0,
              right: 8.0,
              bottom: viewInsets.bottom + padding.bottom + 8.0,
            ),
            sliver: SuperSliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: _filteredCountries.length,
                (context, index) {
                  final country = _filteredCountries[index];

                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedCountry = country;
                      });
                      Navigator.pop(context, country);
                    },
                    child: GrxCard(
                      child: Padding(
                        padding: const EdgeInsets.all(
                          16.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    'assets/svgs/flags/${country.flag}.svg',
                                    width: 22.0,
                                    package: GrxUtils.packageName,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0,
                                    ),
                                    child: GrxBodyText(country.name),
                                  ),
                                  GrxHeadlineSmallText(country.code),
                                ],
                              ),
                            ),
                            GrxRoundedCheckbox(
                              value: selectedCountry.code == country.code &&
                                  selectedCountry.name == country.name,
                              radius: 8.0,
                              isTappable: false,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
