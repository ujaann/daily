import 'package:calendar_view/calendar_view.dart';
import 'package:daily/entity/event.dart';
import 'package:daily/entity/expense.dart';
import 'package:daily/entity/user.dart';
import 'package:hive_ce/hive.dart';

part 'hive_adapters.g.dart';

@GenerateAdapters([
  AdapterSpec<ExpenseEntity>(),
  AdapterSpec<ExpenseType>(),
  AdapterSpec<EventEntity>(),
  AdapterSpec<RepeatFrequency?>(),
  AdapterSpec<UserEntity>(),
])
class HiveAdapters {}
