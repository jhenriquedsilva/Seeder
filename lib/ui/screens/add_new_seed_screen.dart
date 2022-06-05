import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:seed/providers/seed_provider.dart';

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

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Future<void> _submitData() async {
    final isValid = _formKey.currentState?.validate();
    if (isValid != null && !isValid) {
      return;
    }

    if (_manufacturedAt == null || _expiresIn == null) {
      showSnackBar(context, 'Selecione data de fabricação e validade');
      return;
    }

    _formKey.currentState?.save();

    try {
      await Provider.of<SeedProvider>(context, listen: false).insert(
        _seedName!,
        _manufacturerName!,
        _manufacturedAt!,
        _expiresIn!,
      );

      showSnackBar(context, 'Nova semente cadastrada com sucesso');

      Navigator.of(context).pop();
      Provider.of<SeedProvider>(context, listen: false).getSeeds();
    } catch (error) {
      showSnackBar(context, error.toString());
    }
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
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Icon(
                              Icons.nature,
                              color: Theme.of(context).primaryColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: TextFormField(
                                cursorColor: Theme.of(context).primaryColor,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  hintText: 'Nome da semente',
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(color: Colors.black),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      borderSide: BorderSide(
                                          color:
                                              Theme.of(context).primaryColor)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      borderSide: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 2.0)),
                                  errorBorder: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      borderSide:
                                          BorderSide(color: Colors.red)),
                                  focusedErrorBorder: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2.0)),
                                ),
                                keyboardType: TextInputType.name,
                                validator: (seedName) {
                                  if (seedName == null ||
                                      seedName.trim().isEmpty) {
                                    return 'Você precisa informar o nome da semente';
                                  }
                                  return null;
                                },
                                onSaved: (seedName) {
                                  _seedName = seedName as String;
                                },
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(
                              Icons.factory,
                              color: Theme.of(context).primaryColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: TextFormField(
                                cursorColor: Theme.of(context).primaryColor,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  hintText: 'Fabricante',
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(color: Colors.black),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      borderSide: BorderSide(
                                          color:
                                              Theme.of(context).primaryColor)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      borderSide: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 2.0)),
                                  errorBorder: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      borderSide:
                                          BorderSide(color: Colors.red)),
                                  focusedErrorBorder: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2.0)),
                                ),
                                validator: (manufacturerName) {
                                  if (manufacturerName == null ||
                                      manufacturerName.trim().isEmpty) {
                                    return 'Nome inválido';
                                  }
                                  return null;
                                },
                                onSaved: (manufacturerName) {
                                  _manufacturerName =
                                      manufacturerName as String;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_manufacturedAt == null
                            ? 'Escolha data de fabricação'
                            : DateFormat('dd-MM-yyyy')
                                .format(_manufacturedAt!)),
                        Container(
                          margin: const EdgeInsets.all(8),
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: OutlinedButton(
                            child: const Text('Data de Fabricação'),
                            onPressed: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(DateTime.now().year - 1,
                                    DateTime.now().month, DateTime.now().day),
                                lastDate: DateTime.now(),
                              );

                              if (date != null) {
                                setState(() {
                                  _manufacturedAt = date;
                                });
                              }
                            },
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_expiresIn == null
                            ? 'Escolha a data de validade'
                            : DateFormat('dd-MM-yyyy').format(_expiresIn!)),
                        Container(
                          margin: const EdgeInsets.all(8),
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: OutlinedButton(
                            child: const Text('Validade'),
                            onPressed: _manufacturedAt != null
                                ? () async {
                                    final date = await showDatePicker(
                                      context: context,
                                      initialDate: _manufacturedAt!
                                          .add(const Duration(days: 1)),
                                      firstDate: _manufacturedAt!
                                          .add(const Duration(days: 1)),
                                      lastDate: DateTime(
                                        _manufacturedAt!.year + 10,
                                      ),
                                    );

                                    if (date != null) {
                                      setState(() {
                                        _expiresIn = date;
                                      });
                                    }
                                  }
                                : null,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _submitData();
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
