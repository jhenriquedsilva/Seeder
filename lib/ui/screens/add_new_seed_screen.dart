import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seed/providers/seed_provider.dart';
import 'package:seed/ui/widgets/add_new_seed_form.dart';
import 'package:seed/ui/widgets/custom_elevated_button.dart';
import 'package:seed/ui/widgets/date_label.dart';
import 'package:seed/utils/UIUtils.dart';

class AddNewSeedScreen extends StatefulWidget {
  const AddNewSeedScreen({Key? key}) : super(key: key);

  static const routName = '/add_new_seed';

  @override
  State<AddNewSeedScreen> createState() => _AddNewSeedScreenState();
}

class _AddNewSeedScreenState extends State<AddNewSeedScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String? _seedName;
  String? _manufacturerName;
  DateTime? _manufacturedAt;
  DateTime? _expiresIn;

  Future<void> _processUserInput() async {
    if (!_isInputValid()) {
      return;
    }

    if (_areDatesInvalid()) {
      UIUtils.showSnackBar(context, 'Selecione fabricação e validade');
      return;
    }

    _saveInput();
    await _insertSeed();
    goBackToSeedsScreen();
    refreshSeeds();
  }

  bool _isInputValid() {
    final isValid = _formKey.currentState?.validate();
    return isValid != null && isValid;
  }

  bool _areDatesInvalid() {
    return _manufacturedAt == null || _expiresIn == null;
  }

  void _saveInput() {
    _formKey.currentState?.save();
  }

  Future<void> _insertSeed() async {
    try {
      await Provider.of<SeedProvider>(context, listen: false).insert(
        _seedName as String,
        _manufacturerName as String,
        _manufacturedAt as DateTime,
        _expiresIn as DateTime,
      );

      UIUtils.showSnackBar(context, 'Semente cadastrada com sucesso');
    } catch (error) {
      UIUtils.showSnackBar(context, error.toString());
    }
  }

  void goBackToSeedsScreen() {
    Navigator.of(context).pop();
  }

  Future<void> refreshSeeds() async {
    await Provider.of<SeedProvider>(context, listen: false).getSeeds();
  }

  Future<void> processDatePickerInput(
    DateTime firstDate,
    DateTime lastDate,
    bool isManufacturedAt,
  ) async {
    final date = await showCustomDatePicker(firstDate, lastDate);

    if (date != null) {
      setState(() {
        if (isManufacturedAt) {
          _manufacturedAt = date;
        } else {
          _expiresIn = date;
        }
      });
    }
  }

  Future<DateTime?> showCustomDatePicker(
      DateTime firstDate, DateTime lastDate) async {
    return showDatePicker(
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
                colorScheme:
                    ColorScheme.light(primary: Theme.of(context).primaryColor)),
            child: child as Widget);
      },
      context: context,
      initialDate: DateTime.now(),
      firstDate: firstDate,
      lastDate: lastDate,
    );
  }

  void _setSeedName(String name) {
    _seedName = name;
  }

  void _setManufacturerName(String name) {
    _manufacturerName = name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'Adicionar',
          style: Theme.of(context).textTheme.headline4,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(top: 16),
              child: Column(
                children: [
                  AddNewSeedForm(
                    formKey: _formKey,
                    onSaveSeedNameHandler: _setSeedName,
                    onSaveManufacturerNameHandler: _setManufacturerName,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _manufacturedAt == null
                            ? Icon(
                                Icons.calendar_month,
                                color: Theme.of(context).primaryColor,
                              )
                            : Text(
                                DateFormat('dd/MM/yyyy')
                                    .format(_manufacturedAt as DateTime),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                        ElevatedButton(
                          child: const Text('Fabricação'),
                          onPressed: () async {
                            final date = await showDatePicker(
                              builder: (context, child) {
                                return Theme(
                                    data: Theme.of(context).copyWith(
                                        colorScheme: ColorScheme.light(
                                            primary: Theme.of(context)
                                                .primaryColor)),
                                    child: child!);
                              },
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(DateTime.now().year - 50,
                                  DateTime.now().month, DateTime.now().day),
                              lastDate: DateTime.now(),
                            );

                            if (date != null) {
                              setState(() {
                                _manufacturedAt = date;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                            padding: const EdgeInsets.all(16),
                            fixedSize: Size(
                                MediaQuery.of(context).size.width * 0.4, 60),
                            elevation: 16,
                            shadowColor: Colors.green,
                            shape: const StadiumBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _expiresIn == null
                            ? Icon(
                                Icons.calendar_month,
                                color: Theme.of(context).primaryColor,
                              )
                            : Text(
                                DateFormat('dd/MM/yyyy').format(_expiresIn as DateTime),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                        ElevatedButton(
                          child: const Text('Validade'),
                          onPressed: _manufacturedAt != null
                              ? () async {
                                  final date = await showDatePicker(
                                    builder: (context, child) {
                                      return Theme(
                                          data: Theme.of(context).copyWith(
                                              colorScheme: ColorScheme.light(
                                                  primary: Theme.of(context)
                                                      .primaryColor)),
                                          child: child!);
                                    },
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: _manufacturedAt!
                                        .add(const Duration(days: 1)),
                                    lastDate: DateTime(
                                      _manufacturedAt!.year + 50,
                                    ),
                                  );

                                  if (date != null) {
                                    setState(() {
                                      _expiresIn = date;
                                    });
                                  }
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                            padding: const EdgeInsets.all(16),
                            fixedSize: Size(
                                MediaQuery.of(context).size.width * 0.4, 60),
                            elevation: 16,
                            shadowColor: Colors.green,
                            shape: const StadiumBorder(),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () async {
          await _submitData();
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
