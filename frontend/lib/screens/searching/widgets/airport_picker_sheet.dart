import 'dart:async';
import 'package:flutter/material.dart';
import '../models/airport_model.dart';
import '../services/airport_search_service.dart';

Future<AirportResult?> showAirportPicker(
  BuildContext context, {
  required String label,
}) {
  return showModalBottomSheet<AirportResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _AirportPickerSheet(),
  );
}

class _AirportPickerSheet extends StatefulWidget {
  const _AirportPickerSheet();

  @override
  State<_AirportPickerSheet> createState() => _AirportPickerSheetState();
}

class _AirportPickerSheetState extends State<_AirportPickerSheet> {
  final _controller = TextEditingController();
  final _service = AirportSearchService();

  List<AirportResult> _results = [];
  bool _searched = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) async {
    if (query.trim().isEmpty) {
      if (mounted) {
        setState(() {
          _results = [];
          _searched = false;
        });
      }
      return;
    }

    final results = await _service.searchAirports(query);
    if (mounted) {
      setState(() {
        _results = results;
        _searched = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: EdgeInsets.only(bottom: bottomInset),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Search field
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                controller: _controller,
                autofocus: true,
                onChanged: _onQueryChanged,
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search city or airport (e.g. Jakarta, CGK)',
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: Colors.black.withValues(alpha: 0.35),
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF2B99E3),
                    size: 20,
                  ),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _controller.clear();
                            _onQueryChanged('');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Results
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.45,
            ),
            child: _buildBody(),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_searched && _results.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          children: [
            Icon(
              Icons.search_off,
              size: 40,
              color: Colors.black.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 8),
            Text(
              'No airports found',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: Colors.black.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      );
    }

    if (_results.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: _results.length,
      separatorBuilder: (_, _) => Divider(
        height: 1,
        color: Colors.black.withValues(alpha: 0.06),
        indent: 56,
      ),
      itemBuilder: (context, i) {
        final airport = _results[i];
        return ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF2B99E3).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              airport.iataCode,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2B99E3),
              ),
            ),
          ),
          title: Text(
            airport.cityName.isNotEmpty ? airport.cityName : airport.name,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            '${airport.name} · ${airport.countryCode}',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              color: Colors.black.withValues(alpha: 0.45),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () => Navigator.of(context).pop(airport),
        );
      },
    );
  }
}
