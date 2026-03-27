import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const _kBlue = Color(0xFF2B99E3);
const _kTextStyle = TextStyle(fontFamily: 'Poppins');

// ── Date Picker ───────────────────────────────────────────────────────────────

/// Returns the selected [DateTime] or null if dismissed.
Future<DateTime?> showFlightDatePicker(BuildContext context, DateTime initial) {
  return showDatePicker(
    context: context,
    initialDate: initial,
    firstDate: DateTime.now(),
    lastDate: DateTime.now().add(const Duration(days: 365)),
    builder: (context, child) => Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(
          primary: _kBlue,
          onPrimary: Colors.white,
          onSurface: Colors.black87,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: _kBlue),
        ),
      ),
      child: child!,
    ),
  );
}

/// Formats a [DateTime] for human display, e.g. "Fri, 27 Mar 2026".
String formatDisplayDate(DateTime date) => DateFormat('EEE, d MMM yyyy').format(date);

/// Formats a [DateTime] as ISO 8601 date string, e.g. "2026-03-27".
String formatApiDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

// ── Passenger Picker ──────────────────────────────────────────────────────────

class PassengerCount {
  final int adults;
  final int children;
  final int infants;

  const PassengerCount({
    this.adults = 1,
    this.children = 0,
    this.infants = 0,
  });

  int get total => adults + children + infants;

  String get displayLabel {
    final parts = <String>['$adults Adult${adults > 1 ? 's' : ''}'];
    if (children > 0) parts.add('$children Child${children > 1 ? 'ren' : ''}');
    if (infants > 0) parts.add('$infants Infant${infants > 1 ? 's' : ''}');
    return parts.join(', ');
  }

  PassengerCount copyWith({int? adults, int? children, int? infants}) =>
      PassengerCount(
        adults: adults ?? this.adults,
        children: children ?? this.children,
        infants: infants ?? this.infants,
      );
}

Future<PassengerCount?> showPassengerPicker(
  BuildContext context,
  PassengerCount initial,
) {
  return showModalBottomSheet<PassengerCount>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _PassengerPickerSheet(initial: initial),
  );
}

class _PassengerPickerSheet extends StatefulWidget {
  final PassengerCount initial;
  const _PassengerPickerSheet({required this.initial});

  @override
  State<_PassengerPickerSheet> createState() => _PassengerPickerSheetState();
}

class _PassengerPickerSheetState extends State<_PassengerPickerSheet> {
  late PassengerCount _count;

  @override
  void initState() {
    super.initState();
    _count = widget.initial;
  }

  void _adjust(String category, int delta) {
    setState(() {
      switch (category) {
        case 'adults':
          final next = _count.adults + delta;
          if (next >= 1) _count = _count.copyWith(adults: next);
        case 'children':
          final next = _count.children + delta;
          if (next >= 0) _count = _count.copyWith(children: next);
        case 'infants':
          final next = _count.infants + delta;
          if (next >= 0 && next <= _count.adults) {
            _count = _count.copyWith(infants: next);
          }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Color(0x26000000), blurRadius: 20, offset: Offset(0, -4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _handle(),
          _sectionTitle('Passengers'),
          _counter('Adults', 'Age 12+', 'adults', _count.adults),
          _divider(),
          _counter('Children', 'Age 2–11', 'children', _count.children),
          _divider(),
          _counter('Infants', 'Under 2 (max = adults)', 'infants', _count.infants),
          const SizedBox(height: 16),
          _confirmButton(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _handle() => Container(
        margin: const EdgeInsets.only(top: 12, bottom: 8),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(2),
        ),
      );

  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: _kTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      );

  Widget _counter(String label, String subtitle, String category, int value) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: _kTextStyle.copyWith(
                          fontSize: 14, fontWeight: FontWeight.w500)),
                  Text(subtitle,
                      style: _kTextStyle.copyWith(
                          fontSize: 11,
                          color: Colors.black.withValues(alpha: 0.4))),
                ],
              ),
            ),
            _countButton(Icons.remove, () => _adjust(category, -1)),
            const SizedBox(width: 16),
            SizedBox(
              width: 24,
              child: Text(
                '$value',
                textAlign: TextAlign.center,
                style: _kTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 16),
            _countButton(Icons.add, () => _adjust(category, 1)),
          ],
        ),
      );

  Widget _countButton(IconData icon, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black.withValues(alpha: 0.15)),
          ),
          child: Icon(icon, size: 16, color: _kBlue),
        ),
      );

  Widget _divider() => Divider(
        height: 1,
        indent: 20,
        endIndent: 20,
        color: Colors.black.withValues(alpha: 0.06),
      );

  Widget _confirmButton() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(_count),
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: _kBlue,
              borderRadius: BorderRadius.circular(22),
              boxShadow: const [
                BoxShadow(color: Color(0x26000000), blurRadius: 10, offset: Offset(0, 4)),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              'Confirm',
              style: _kTextStyle.copyWith(
                  color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        ),
      );
}

// ── Flight Class Picker ───────────────────────────────────────────────────────

const _flightClasses = [
  ('Economy', 'ECONOMY'),
  ('Premium Economy', 'PREMIUM_ECONOMY'),
  ('Business', 'BUSINESS'),
  ('First Class', 'FIRST'),
];

Future<(String display, String apiValue)?> showFlightClassPicker(
  BuildContext context,
  String currentApiValue,
) {
  return showModalBottomSheet<(String, String)>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _FlightClassPickerSheet(currentApiValue: currentApiValue),
  );
}

class _FlightClassPickerSheet extends StatefulWidget {
  final String currentApiValue;
  const _FlightClassPickerSheet({required this.currentApiValue});

  @override
  State<_FlightClassPickerSheet> createState() => _FlightClassPickerSheetState();
}

class _FlightClassPickerSheetState extends State<_FlightClassPickerSheet> {
  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.currentApiValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Color(0x26000000), blurRadius: 20, offset: Offset(0, -4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Flight Class',
                style: _kTextStyle.copyWith(
                    fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          ...(_flightClasses.map((entry) {
            final (display, apiValue) = entry;
            final isSelected = _selected == apiValue;
            return GestureDetector(
              onTap: () => Navigator.of(context).pop((display, apiValue)),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected
                      ? _kBlue.withValues(alpha: 0.08)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? _kBlue.withValues(alpha: 0.4)
                        : Colors.black.withValues(alpha: 0.08),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        display,
                        style: _kTextStyle.copyWith(
                          fontSize: 14,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isSelected ? _kBlue : Colors.black87,
                        ),
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check_circle,
                          color: _kBlue, size: 20),
                  ],
                ),
              ),
            );
          })),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
