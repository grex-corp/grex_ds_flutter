library;

import 'package:flutter/material.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart' as phone;

import 'services/grx_toast.service.dart';

export 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

/// Animations
export 'animations/grx_fade_transition.animation.dart' show GrxFadeTransition;

/// Controllers
export 'controllers/grx_animated_loading_button.controller.dart'
    show GrxAnimatedLoadingButtonController;

/// Enums
export 'enums/grx_align.enum.dart' show GrxAlign;
export 'enums/grx_autocomplete_loading_style.enum.dart'
    show GrxAutocompleteLoadingStyle;
export 'enums/grx_country_id.enum.dart' show GrxCountryId;
export 'enums/grx_text_transform.enum.dart' show GrxTextTransform;

/// Extensions
export 'extensions/uint8_list.extension.dart' show Uint8ListExtension;

/// Models
export 'models/grx_country.model.dart' show GrxCountry;
export 'models/grx_federative_unit.model.dart' show GrxFederativeUnit;
export 'models/grx_phone_number.model.dart' show GrxPhoneNumber;
export 'models/grx_toast_action.model.dart' show GrxToastAction;

/// Services
export 'services/grx_bottom_sheet.service.dart' show GrxBottomSheetService;
export 'services/grx_image_picker.service.dart' show GrxImagePickerService;
export 'services/grx_toast.service.dart' show GrxToastService;

/// Themes/Colors
export 'themes/colors/grx_colors.dart' show GrxColors;

/// Themes/FormFieldStyles
export 'themes/grx_text_theme.theme.dart' show GrxTextTheme;

/// Themes
export 'themes/grx_theme_data.theme.dart' show GrxThemeData;

/// Themes/Icons
export 'themes/icons/grx_icons.dart' show GrxIcons;

/// Themes/System Overlay
export 'themes/system_overlay/grx_system_overlay.style.dart'
    show GrxSystemOverlayStyle;
export 'themes/typography/styles/grx_body_large_text.style.dart'
    show GrxBodyLargeTextStyle;
export 'themes/typography/styles/grx_body_text.style.dart'
    show GrxBodyTextStyle;
export 'themes/typography/styles/grx_body_small_text.style.dart'
    show GrxBodySmallTextStyle;
export 'themes/typography/styles/grx_label_large_text.style.dart'
    show GrxLabelLargeTextStyle;
export 'themes/typography/styles/grx_label_small_text.style.dart'
    show GrxLabelSmallTextStyle;
export 'themes/typography/styles/grx_label_text.style.dart'
    show GrxLabelTextStyle;
export 'themes/typography/styles/grx_headline_large_text.style.dart'
    show GrxHeadlineLargeTextStyle;
export 'themes/typography/styles/grx_headline_text.style.dart'
    show GrxHeadlineTextStyle;
export 'themes/typography/styles/grx_headline_small_text.style.dart'
    show GrxHeadlineSmallTextStyle;
export 'themes/typography/styles/grx_title_large_text.style.dart'
    show GrxTitleLargeTextStyle;
export 'themes/typography/styles/grx_title_text.style.dart'
    show GrxTitleTextStyle;
export 'themes/typography/styles/grx_title_small_text.style.dart'
    show GrxTitleSmallTextStyle;
export 'themes/typography/styles/grx_display_large_text.style.dart'
    show GrxDisplayLargeTextStyle;
export 'themes/typography/styles/grx_display_text.style.dart'
    show GrxDisplayTextStyle;
export 'themes/typography/styles/grx_display_small_text.style.dart'
    show GrxDisplaySmallTextStyle;

/// Themes/Typography/Text Styles
export 'themes/typography/styles/grx_text.style.dart' show GrxTextStyle;

/// Themes/Typography/Utils
export 'themes/typography/utils/grx_font_families.dart' show GrxFontFamilies;
export 'themes/typography/utils/grx_font_weights.dart' show GrxFontWeights;
export 'utils/grx_country.util.dart' show GrxCountryUtils;
export 'utils/grx_linkify.util.dart' show GrxLinkify;
export 'utils/grx_regex.util.dart' show GrxRegexUtils;
export 'utils/grx_upper_case_text_formatter.util.dart'
    show GrxUpperCaseTextFormatter;

/// Utils
export 'utils/grx_utils.util.dart' show GrxUtils;

///Widget/Buttons
export 'widgets/buttons/grx_back_button.widget.dart' show GrxBackButton;
export 'widgets/buttons/grx_bottom_button.widget.dart' show GrxBottomButton;
export 'widgets/buttons/grx_circle_button.widget.dart' show GrxCircleButton;
export 'widgets/buttons/grx_close_button.widget.dart' show GrxCloseButton;
export 'widgets/buttons/grx_filter_button.widget.dart' show GrxFilterButton;
export 'widgets/buttons/grx_icon_button.widget.dart' show GrxIconButton;
export 'widgets/buttons/grx_primary_button.widget.dart' show GrxPrimaryButton;
export 'widgets/buttons/grx_rounded_button.widget.dart' show GrxRoundedButton;
export 'widgets/buttons/grx_secondary_button.widget.dart'
    show GrxSecondaryButton;
export 'widgets/buttons/grx_tertiary_button.widget.dart' show GrxTertiaryButton;

/// Widgets/Checkbox
export 'widgets/checkbox/grx_checkbox.widget.dart' show GrxCheckbox;
export 'widgets/checkbox/grx_checkbox_list_tile.widget.dart'
    show GrxCheckboxListTile;
export 'widgets/checkbox/grx_rounded_checkbox.widget.dart'
    show GrxRoundedCheckbox;

/// Widgets/Cupertino
export 'widgets/cupertino/cupertino_switch_list_tile.dart'
    show CupertinoSwitchListTile;

/// Widget/Fields/Controllers
export 'widgets/fields/controllers/grx_form_field.controller.dart'
    show GrxFormFieldController;
export 'widgets/fields/grx_autocomplete_dropdown_form_field.widget.dart'
    show GrxAutocompleteDropdownFormField;

/// Widgets/Fields
export 'widgets/fields/grx_custom_dropdown_form_field.widget.dart'
    show GrxCustomDropdownFormField;
export 'widgets/fields/grx_date_time_picker_form_field.widget.dart'
    show GrxDateTimePickerFormField;
export 'widgets/fields/grx_dropdown_form_field.widget.dart'
    show GrxDropdownFormField;
export 'widgets/fields/grx_multi_select_form_field.widget.dart'
    show GrxMultiSelectFormField;
export 'widgets/fields/grx_phone_form_field.widget.dart' show GrxPhoneFormField;
export 'widgets/fields/grx_search_field.widget.dart' show GrxSearchField;
export 'widgets/fields/grx_switch_form_field.widget.dart'
    show GrxSwitchFormField;
export 'widgets/fields/grx_text_field.widget.dart' show GrxTextField;
export 'widgets/fields/grx_text_form_field.widget.dart' show GrxTextFormField;

///Widgets/Card
export 'widgets/grx_card.widget.dart' show GrxCard;

/// Widget/Chip
export 'widgets/grx_chip.widget.dart' show GrxChip;
export 'enums/grx_chip_type.enum.dart' show GrxChipType;

/// Widget/DashedDivider
export 'widgets/grx_dashed_divider.widget.dart' show GrxDashedDivider;

/// Widget/DismissibleKeyboard
export 'widgets/grx_dismissible_keyboard.widget.dart'
    show GrxDismissibleKeyboard;

///Widget/DismissibleScaffold
export 'widgets/grx_dismissible_scaffold.widget.dart'
    show GrxDismissibleScaffold;

/// Widget/Divider
export 'widgets/grx_divider.widget.dart' show GrxDivider;

/// Widgets/Help
export 'widgets/grx_help.widget.dart' show GrxHelpWidget;

/// Widgets/Lists
export 'widgets/grx_sliver_animated_list.widget.dart'
    show GrxSliverAnimatedList;

/// Widget/Loading
export 'widgets/grx_shimmer.widget.dart' show GrxShimmer;
export 'widgets/grx_spinner_loading.widget.dart' show GrxSpinnerLoading;

/// Widget/Avatar
export 'widgets/grx_user_avatar.widget.dart' show GrxUserAvatar;
export 'widgets/headers/grx_animated_sliver_header.widget.dart'
    show GrxAnimatedSliverHeader;

/// Widget/Headers
export 'widgets/headers/grx_header.widget.dart' show GrxHeader;
export 'widgets/headers/grx_searchable_header.widget.dart'
    show GrxSearchableHeader;
export 'widgets/headers/grx_searchable_sliver_header.widget.dart'
    show GrxSearchableSliverHeader;

/// Widgets/Layout
export 'widgets/layout/grx_responsive_layout.widget.dart'
    show GrxResponsiveLayout;
export 'widgets/list/grx_list_empty.widget.dart' show GrxListEmpty;
export 'widgets/list/grx_list_error.widget.dart' show GrxListError;

/// Widgets/Media
export 'widgets/media/grx_svg.widget.dart' show GrxSvg;

/// Widgets/Typography
export 'widgets/typography/grx_body_large_text.widget.dart'
    show GrxBodyLargeText;
export 'widgets/typography/grx_body_text.widget.dart' show GrxBodyText;
export 'widgets/typography/grx_body_small_text.widget.dart'
    show GrxBodySmallText;
export 'widgets/typography/grx_label_large_text.widget.dart'
    show GrxLabelLargeText;
export 'widgets/typography/grx_label_small_text.widget.dart'
    show GrxLabelSmallText;
export 'widgets/typography/grx_label_text.widget.dart' show GrxLabelText;
export 'widgets/typography/grx_headline_large_text.widget.dart'
    show GrxHeadlineLargeText;
export 'widgets/typography/grx_headline_text.widget.dart' show GrxHeadlineText;
export 'widgets/typography/grx_headline_small_text.widget.dart'
    show GrxHeadlineSmallText;
export 'widgets/typography/grx_title_large_text.widget.dart'
    show GrxTitleLargeText;
export 'widgets/typography/grx_title_text.widget.dart' show GrxTitleText;
export 'widgets/typography/grx_title_small_text.widget.dart'
    show GrxTitleSmallText;
export 'widgets/typography/grx_display_large_text.widget.dart'
    show GrxDisplayLargeText;
export 'widgets/typography/grx_display_text.widget.dart' show GrxDisplayText;
export 'widgets/typography/grx_display_small_text.widget.dart'
    show GrxDisplaySmallText;
export 'widgets/typography/grx_text.widget.dart' show GrxText;

/// Themes/Spacing
export 'themes/spacing/grx_spacing.dart' show GrxSpacing;

/// Themes/Radius
export 'themes/radius/grx_radius.dart' show GrxRadius;

/// Grex Design System
/// Main initialization class for the Grex Design System library
abstract class GrexDS {
  /// Initializes all required services for the Grex Design System
  ///
  /// This method should be called once at app startup, typically in the main function.
  /// Optionally, provide a [context] to also initialize the toast service.
  ///
  /// Example (in main):
  /// ```dart
  /// void main() async {
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///   await GrexDS.init();
  ///   runApp(MyApp());
  /// }
  /// ```
  ///
  /// Example (with context for toast notifications):
  /// ```dart
  /// @override
  /// void initState() {
  ///   super.initState();
  ///   WidgetsBinding.instance.addPostFrameCallback((_) async {
  ///     await GrexDS.init(context);
  ///   });
  /// }
  /// ```
  ///
  /// [context] - Optional BuildContext for initializing toast service
  static Future<void> init([BuildContext? context]) async {
    // Initialize toast service first if context is provided (synchronous)
    if (context != null) {
      GrxToastService.init(context);
    }

    // Initialize flutter_libphonenumber for phone number formatting
    await phone.init();
  }
}
