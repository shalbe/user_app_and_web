import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart_delivery/helper/constants.dart';
import 'package:zcart_delivery/providers/order_provider.dart';
import 'package:zcart_delivery/translations/locale_keys.g.dart';
import 'package:zcart_delivery/views/orders/components/order_list_item.dart';
import 'package:easy_localization/easy_localization.dart';

class SearchOrderPage extends ConsumerStatefulWidget {
  const SearchOrderPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchOrderPageState();
}

class _SearchOrderPageState extends ConsumerState<SearchOrderPage> {
  String _query = '';
  late FocusNode _focusNode;
  @override
  @override
  void initState() {
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _ordersProvider = ref.watch(ordersProvider);
    return KeyboardVisibilityBuilder(
      builder: (context, child, isKeyboardVisible) {
        if (!isKeyboardVisible) {
          _focusNode.unfocus();
        }

        return child;
      },
      child: GestureDetector(
        onTap: () {
          _focusNode.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 8,
          ),
          body: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      //subtle shadow
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        spreadRadius: 2,
                        offset: Offset(0, 2),
                      ),
                    ]),
                padding: const EdgeInsets.only(right: defaultPadding),
                margin: const EdgeInsets.only(
                  top: defaultPadding,
                  left: defaultPadding,
                  right: defaultPadding,
                  bottom: defaultPadding / 2,
                ),
                child: TextField(
                  autofocus: true,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: LocaleKeys.search_order_title.tr(),
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        _query = value;
                      });
                    } else {
                      setState(() {
                        _query = '';
                      });
                    }
                  },
                ),
              ),
              Expanded(
                child: _ordersProvider.when(
                  data: (data) {
                    if (data != null && data.isNotEmpty) {
                      final _orders = data.where((element) {
                        return element.orderNumber
                            .toLowerCase()
                            .contains(_query.toLowerCase());
                      });
                      return _orders.isEmpty
                          ? Center(
                              child: Text(LocaleKeys.no_item_found.tr()),
                            )
                          : ListView(
                              padding: const EdgeInsets.all(defaultPadding / 2),
                              children: _orders.map((order) {
                                return OrderListItem(order: order);
                              }).toList(),
                            );
                    } else {
                      return Center(
                        child: Text(LocaleKeys.no_item_found.tr()),
                      );
                    }
                  },
                  error: (error, stackTrace) =>
                      Center(child: Text(error.toString())),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KeyboardVisibilityBuilder extends StatefulWidget {
  final Widget child;
  final Widget Function(
    BuildContext context,
    Widget child,
    bool isKeyboardVisible,
  ) builder;

  const KeyboardVisibilityBuilder({
    Key? key,
    required this.child,
    required this.builder,
  }) : super(key: key);

  @override
  _KeyboardVisibilityBuilderState createState() =>
      _KeyboardVisibilityBuilderState();
}

class _KeyboardVisibilityBuilderState extends State<KeyboardVisibilityBuilder>
    with WidgetsBindingObserver {
  var _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance!.window.viewInsets.bottom;
    final newValue = bottomInset > 0.0;
    if (newValue != _isKeyboardVisible) {
      setState(() {
        _isKeyboardVisible = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, widget.child, _isKeyboardVisible);
}
