import 'package:daily/entity/expense.dart';
import 'package:hive_ce/hive.dart';

part 'hive_adapters.g.dart';

@GenerateAdapters([
  AdapterSpec<ExpenseEntity>(),
  AdapterSpec<ExpenseType>(),
])
class HiveAdapters {}
