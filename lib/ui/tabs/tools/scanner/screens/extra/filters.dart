import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/bottom_sheet.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/base/text_field.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/manager/scanner.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/custom/filter_list.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';
import '../../manager/filters.dart';

class ScannerFilters extends StatefulWidget {
  const ScannerFilters({super.key});

  @override
  State<ScannerFilters> createState() => _ScannerFiltersState();
}

class _ScannerFiltersState extends State<ScannerFilters> {
  final TextEditingController _bidStart = TextEditingController();
  final TextEditingController _bidEnd = TextEditingController();
  final TextEditingController _askStart = TextEditingController();
  final TextEditingController _askEnd = TextEditingController();
  final TextEditingController _lastTradeStart = TextEditingController();
  final TextEditingController _lastTradeEnd = TextEditingController();
  final TextEditingController _netChangeStart = TextEditingController();
  final TextEditingController _netChangeEnd = TextEditingController();
  final TextEditingController _perChangeStart = TextEditingController();
  final TextEditingController _perChangeEnd = TextEditingController();
  final TextEditingController _volumeStart = TextEditingController();
  final TextEditingController _volumeEnd = TextEditingController();
  final TextEditingController _dolorVolumeStart = TextEditingController();
  final TextEditingController _dolorVolumeEnd = TextEditingController();
  final TextEditingController _sector = TextEditingController(
    text: "Healthcare",
  );
  final TextEditingController _symbolCompany = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ScannerManager manager = context.read<ScannerManager>();
      if (manager.sectors == null) {
        await manager.getFilterSectors(showProgress: true);
      }

      setFilerValues();
    });
  }

  @override
  void dispose() {
    _bidStart.dispose();
    _bidEnd.dispose();
    _askStart.dispose();
    _askEnd.dispose();
    _lastTradeStart.dispose();
    _lastTradeEnd.dispose();
    _netChangeStart.dispose();
    _netChangeEnd.dispose();
    _perChangeStart.dispose();
    _perChangeEnd.dispose();
    _volumeStart.dispose();
    _volumeEnd.dispose();
    _dolorVolumeStart.dispose();
    _dolorVolumeEnd.dispose();
    _sector.dispose();
    _symbolCompany.dispose();
    super.dispose();
  }

  void setFilerValues() {
    ScannerManager provider = context.read<ScannerManager>();
    _bidStart.text = "${provider.filterParams?.bidStart ?? ''}";
    _bidEnd.text = "${provider.filterParams?.bidEnd ?? ''}";
    _askStart.text = "${provider.filterParams?.askStart ?? ''}";
    _askEnd.text = "${provider.filterParams?.askEnd ?? ''}";
    _lastTradeStart.text = "${provider.filterParams?.lastTradeStart ?? ''}";
    _lastTradeEnd.text = "${provider.filterParams?.lastTradeEnd ?? ''}";
    _netChangeStart.text = "${provider.filterParams?.netChangeStart ?? ''}";
    _netChangeEnd.text = "${provider.filterParams?.netChangeEnd ?? ''}";
    _perChangeStart.text = "${provider.filterParams?.perChangeStart ?? ''}";
    _perChangeEnd.text = "${provider.filterParams?.perChangeEnd ?? ''}";
    _volumeStart.text = "${provider.filterParams?.volumeStart ?? ''}";
    _volumeEnd.text = "${provider.filterParams?.volumeEnd ?? ''}";
    _dolorVolumeStart.text = "${provider.filterParams?.dolorVolumeStart ?? ''}";
    _dolorVolumeEnd.text = "${provider.filterParams?.dolorVolumeEnd ?? ''}";
    _sector.text = provider.filterParams?.sector ?? "";
    _symbolCompany.text = provider.filterParams?.symbolCompany ?? "";
  }

  void _showSectorPicker() {
    ScannerManager provider = context.read<ScannerManager>();

    BaseBottomSheet().bottomSheet(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseHeading(title: 'Select Sector'),
        FilterListing(
          titleBold: false,
          items: List.generate(provider.sectors?.length ?? 0, (index) {
            return KeyValueElement(
              key: provider.sectors?[index],
              value: provider.sectors?[index],
            );
          }),
          onSelected: (index) {
            setState(() {
              _sector.text = provider.sectors![index];
            });
          },
        ),
      ],
    ));

    // BaseBottomSheets().gradientBottomSheet(
    //   title: "Select Sector",
    //   child:
    // );
  }

  void _applyFilter() {
    ScannerManager provider = context.read<ScannerManager>();
    FilterParams params = FilterParams();
    if (_bidStart.text.isNotEmpty) {
      params.bidStart = double.tryParse(_bidStart.text);
    } else {
      params.bidStart = null;
    }
    if (_bidEnd.text.isNotEmpty) {
      params.bidEnd = double.tryParse(_bidEnd.text);
    } else {
      params.bidEnd = null;
    }
    if (_askStart.text.isNotEmpty) {
      params.askStart = double.tryParse(_askStart.text);
    } else {
      params.askStart = null;
    }
    if (_askEnd.text.isNotEmpty) {
      params.askEnd = double.tryParse(_askEnd.text);
    } else {
      params.askEnd = null;
    }
    if (_lastTradeStart.text.isNotEmpty) {
      params.lastTradeStart = double.tryParse(_lastTradeStart.text);
    } else {
      params.lastTradeStart = null;
    }
    if (_lastTradeEnd.text.isNotEmpty) {
      params.lastTradeEnd = double.tryParse(_lastTradeEnd.text);
    } else {
      params.lastTradeEnd = null;
    }
    if (_netChangeStart.text.isNotEmpty) {
      params.netChangeStart = double.tryParse(_netChangeStart.text);
    } else {
      params.netChangeStart = null;
    }
    if (_netChangeEnd.text.isNotEmpty) {
      params.netChangeEnd = double.tryParse(_netChangeEnd.text);
    } else {
      params.netChangeEnd = null;
    }
    if (_perChangeStart.text.isNotEmpty) {
      params.perChangeStart = double.tryParse(_perChangeStart.text);
    } else {
      params.perChangeStart = null;
    }
    if (_perChangeEnd.text.isNotEmpty) {
      params.perChangeEnd = double.tryParse(_perChangeEnd.text);
    } else {
      params.perChangeEnd = null;
    }
    if (_volumeStart.text.isNotEmpty) {
      params.volumeStart = double.tryParse(_volumeStart.text);
    } else {
      params.volumeStart = null;
    }
    if (_volumeEnd.text.isNotEmpty) {
      params.volumeEnd = double.tryParse(_volumeEnd.text);
    } else {
      params.volumeEnd = null;
    }
    if (_dolorVolumeStart.text.isNotEmpty) {
      params.dolorVolumeStart = double.tryParse(_dolorVolumeStart.text);
    } else {
      params.dolorVolumeStart = null;
    }
    if (_dolorVolumeEnd.text.isNotEmpty) {
      params.dolorVolumeEnd = double.tryParse(_dolorVolumeEnd.text);
    } else {
      params.dolorVolumeEnd = null;
    }
    if (_sector.text.isNotEmpty) {
      params.sector = _sector.text;
    } else {
      params.sector = null;
    }
    if (_symbolCompany.text.isNotEmpty) {
      params.symbolCompany = _symbolCompany.text;
    } else {
      params.symbolCompany = null;
    }
    provider.applyFilter(params);

    Navigator.pop(context);
  }

  void _resetFilter() {
    ScannerManager provider = context.read<ScannerManager>();
    provider.clearFilter();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        showBack: true,
        title: "Market Scanner Filter",
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text("Symbol Name", style: styleGeorgiaBold()),
                    const SpacerVertical(height: 5),
                    BaseTextField(
                      controller: _symbolCompany,
                      placeholder: "Symbol Name/Company Name",
                      // hintText: "Symbol Name",
                    ),
                    const SpacerVertical(height: 16),
                    FilterRow(
                      label: "Bid:",
                      startHint: "Bid Start",
                      startController: _bidStart,
                      endHint: "Bid End",
                      endController: _bidEnd,
                    ),
                    FilterRow(
                      label: "Ask:",
                      startHint: "Ask Start",
                      startController: _askStart,
                      endHint: "Ask End",
                      endController: _askEnd,
                    ),
                    FilterRow(
                      label: "Last Trade:",
                      startHint: "Last Trade Start",
                      startController: _lastTradeStart,
                      endHint: "Last Trade End",
                      endController: _lastTradeEnd,
                    ),
                    FilterRow(
                      label: "Net Change:",
                      startHint: "Net Change Start",
                      startController: _netChangeStart,
                      endHint: "Net Change End",
                      endController: _netChangeEnd,
                    ),
                    FilterRow(
                      label: "% Change:",
                      startHint: "% Change Start",
                      startController: _perChangeStart,
                      endHint: "% Change End",
                      endController: _perChangeEnd,
                    ),
                    FilterRow(
                      label: "Volume:",
                      startHint: "Volume Start",
                      startController: _volumeStart,
                      endHint: "Volume End",
                      endController: _volumeEnd,
                    ),
                    FilterRow(
                      label: "\$Volume:",
                      startHint: "\$ Volume Start",
                      startController: _dolorVolumeStart,
                      endHint: "\$ Volume End",
                      endController: _dolorVolumeEnd,
                    ),
                    const SpacerVertical(height: 5),
                    // TextInputField(
                    //   controller: TextEditingController(),
                    //   hintText: "Select Sector",
                    // ),
                    GestureDetector(
                      onTap: _showSectorPicker,
                      child: BaseTextField(
                        hintText: "Select Sector",
                        suffixIcon: const Icon(
                          Icons.arrow_drop_down,
                          size: 23,
                          color: ThemeColors.background,
                        ),
                        // style: styleGeorgiaBold(
                        //   fontSize: 15,
                        //   color: ThemeColors.background,
                        // ),
                        editable: false,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        controller: _sector,
                      ),
                    ),
                    const SpacerVertical(height: 16),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Flexible(
                  child: ThemeButton(
                    onPressed: _resetFilter,
                    text: "Reset All",
                  ),
                ),
                const SpacerHorizontal(width: 16),
                Flexible(
                  child: ThemeButton(onPressed: _applyFilter, text: "Apply"),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FilterRow extends StatelessWidget {
  final TextEditingController startController;
  final TextEditingController endController;
  final String label, startHint, endHint;

  const FilterRow({
    super.key,
    required this.label,
    required this.startHint,
    required this.startController,
    required this.endHint,
    required this.endController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SpacerVertical(height: 5),
        Row(
          children: [
            Expanded(
              child: BaseTextField(
                controller: startController,
                placeholder: startHint,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    if (newValue.text.contains('.') &&
                        newValue.text.split('.').length > 2) {
                      return oldValue;
                    }
                    return newValue;
                  }),
                ],
              ),
            ),
            const SpacerHorizontal(width: 16),
            Expanded(
              child: BaseTextField(
                controller: endController,
                placeholder: endHint,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  TextInputFormatter.withFunction(
                    (oldValue, newValue) {
                      final regExp = RegExp(r'^-?\d*\.?\d*$');
                      if (regExp.hasMatch(newValue.text)) {
                        return newValue;
                      }
                      return oldValue;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        const SpacerVertical(height: 16),
      ],
    );
  }
}
