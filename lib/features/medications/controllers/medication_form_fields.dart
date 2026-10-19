import 'package:dose_tracker/core/database/data_sources/dose_times_local_data_source.dart'
    show DoseTimeInput;
import 'package:dose_tracker/core/utils/stock_policy.dart';
import 'package:dose_tracker/core/utils/validators.dart';
import 'package:dose_tracker/features/medications/controllers/dose_times_editor.dart';
import 'package:dose_tracker/features/medications/data/models/medication_enums.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class MedicationFormFields {
  MedicationFormFields()
    : thresholdController = TextEditingController(
        text: StockPolicy.defaultThreshold.toString(),
      );

  final TextEditingController nameController = TextEditingController();
  final TextEditingController doseController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController thresholdController;
  final Rx<DoseUnit> doseUnit = DoseUnit.mg.obs;
  final Rxn<MealInstruction> mealInstruction = Rxn<MealInstruction>();
  final RxBool trackInventory = false.obs;
  final DoseTimesEditor _timesEditor = DoseTimesEditor();

  RxList<DoseTimeInput> get times => _timesEditor.times;

  int get frequency => _timesEditor.frequency;

  bool get canIncreaseFrequency => _timesEditor.canIncrease;

  bool get canDecreaseFrequency => _timesEditor.canDecrease;

  double? get doseAmount => Validators.parsePositiveNumber(doseController.text);

  int? get currentStock => Validators.parsePositiveInt(stockController.text);

  int get stockThreshold =>
      Validators.parsePositiveInt(thresholdController.text) ??
      StockPolicy.defaultThreshold;

  String? validateName(String? value) => Validators.required(value);

  String? validateDose(String? value) => Validators.positiveNumber(value);

  String? validateStock(String? value) {
    return trackInventory.value ? Validators.positiveInteger(value) : null;
  }

  String? validateThreshold(String? value) {
    return trackInventory.value ? Validators.positiveInteger(value) : null;
  }

  void selectUnit(DoseUnit unit) {
    doseUnit.value = unit;
  }

  void selectMeal(MealInstruction instruction) {
    mealInstruction.value = mealInstruction.value == instruction
        ? null
        : instruction;
  }

  void setTrackInventory(bool value) {
    trackInventory.value = value;
  }

  void increaseFrequency() => _timesEditor.increase();

  void decreaseFrequency() => _timesEditor.decrease();

  void addTime() => _timesEditor.addTime();

  void removeTime(int index) => _timesEditor.removeTime(index);

  bool updateTime({
    required int index,
    required int minuteOfDay,
    required double quantity,
  }) {
    return _timesEditor.updateTime(
      index: index,
      minuteOfDay: minuteOfDay,
      quantity: quantity,
    );
  }

  void dispose() {
    nameController.dispose();
    doseController.dispose();
    stockController.dispose();
    thresholdController.dispose();
  }
}
