import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/share_review_bloc.dart';
import '../bloc/share_review_state.dart';
import '../../domain/entities/airline.dart';
import '../../domain/entities/airport.dart';

class DropdownSearchField<T> extends StatefulWidget {
  final String labelText;
  final T? value;
  final String Function(T) displayText;
  final void Function(T?) onChanged;
  final void Function(String) onSearch;
  final Widget Function(T) itemBuilder;
  final String? Function(T?)? validator;

  const DropdownSearchField({
    super.key,
    required this.labelText,
    required this.value,
    required this.displayText,
    required this.onChanged,
    required this.onSearch,
    required this.itemBuilder,
    this.validator,
  });

  @override
  State<DropdownSearchField<T>> createState() => _DropdownSearchFieldState<T>();
}

class _DropdownSearchFieldState<T> extends State<DropdownSearchField<T>> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  List<T> _items = [];
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    if (widget.value != null) {
      _controller.text = widget.displayText(widget.value!);
    }
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      _showOverlay();
    } else {
      _removeOverlay();
    }
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;
    
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isOpen = true;
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isOpen = false;
    });
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: BlocConsumer<ShareReviewBloc, ShareReviewState>(
                listener: (context, state) {
                  if (state is AirlinesLoaded && T == Airline) {
                    setState(() {
                      _items = state.airlines as List<T>;
                    });
                  } else if (state is AirportsLoaded && T == Airport) {
                    setState(() {
                      _items = state.airports as List<T>;
                    });
                  }
                },
                builder: (context, state) {
                  if (state is ShareReviewLoading) {
                    return const SizedBox(
                      height: 100,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (_items.isEmpty) {
                    return const SizedBox(
                      height: 100,
                      child: Center(
                        child: Text('No items found'),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return InkWell(
                        onTap: () {
                          widget.onChanged(item);
                          _controller.text = widget.displayText(item);
                          _focusNode.unfocus();
                          _removeOverlay();
                        },
                        child: widget.itemBuilder(item),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          labelText: widget.labelText,
          suffixIcon: Icon(
            _isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          ),
        ),
        onChanged: (value) {
          widget.onSearch(value);
        },
        validator: widget.validator != null 
            ? (value) => widget.validator!(widget.value)
            : null,
      ),
    );
  }
}