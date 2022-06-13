import 'package:flutter/material.dart';
import 'package:seed/ui/widgets/custom_text_form_field.dart';
import 'package:seed/validators/validator.dart';

class AddNewSeedForm extends StatelessWidget with Validator {
  const AddNewSeedForm({
    Key? key,
    required this.formKey,
    required this.onSaveSeedNameHandler,
    required this.onSaveManufacturerNameHandler,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final void Function(String) onSaveSeedNameHandler;
  final void Function(String) onSaveManufacturerNameHandler;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
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
                child: CustomTextFormField(
                  cursorColor: Theme.of(context).primaryColor,
                  borderColor: Theme.of(context).primaryColor,
                  validationCallback: validateName,
                  errorMessage: 'Informe o nome da semente',
                  onSaveHandler: onSaveSeedNameHandler,
                  hintText: 'Nome da semente',
                  hintColor: Colors.grey,
                  inputType: TextInputType.name,
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
                child: CustomTextFormField(
                  cursorColor: Theme.of(context).primaryColor,
                  borderColor: Theme.of(context).primaryColor,
                  validationCallback: validateName,
                  errorMessage: 'Nome inválido',
                  onSaveHandler: onSaveManufacturerNameHandler,
                  hintText: 'Fabricante',
                  hintColor: Colors.grey,
                  inputType: TextInputType.name,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
