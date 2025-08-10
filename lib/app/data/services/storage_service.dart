import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/fertility_model.dart';
import '../models/fluid_model.dart';
import '../models/medicine_model.dart';

class StorageService extends GetxService {
  late GetStorage _box;
  late Database _database;

  Future<StorageService> init() async {
    _box = GetStorage();
    await _initDatabase();
    return this;
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'fertility_tracker.db'),
      onCreate: (db, version) async {
        // Fertility tables
        await db.execute('''
          CREATE TABLE fertility_data(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            period_start TEXT NOT NULL,
            period_end TEXT NOT NULL,
            cycle_length INTEGER DEFAULT 28,
            next_period_date TEXT NOT NULL,
            ovulation_date TEXT NOT NULL,
            fertile_days TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE period_entries(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            start_date TEXT NOT NULL,
            end_date TEXT NOT NULL,
            flow INTEGER DEFAULT 3,
            symptoms TEXT
          )
        ''');

        // Fluid tables
        await db.execute('''
          CREATE TABLE fluid_intake(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT NOT NULL,
            amount REAL NOT NULL,
            type TEXT DEFAULT 'water'
          )
        ''');

        // Medicine tables
        await db.execute('''
          CREATE TABLE medicines(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            type INTEGER NOT NULL,
            scheduled_times TEXT NOT NULL,
            is_active INTEGER DEFAULT 1,
            notes TEXT,
            created_at TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE medicine_intake(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            medicine_id INTEGER NOT NULL,
            scheduled_time TEXT NOT NULL,
            taken_time TEXT,
            is_taken INTEGER DEFAULT 0,
            FOREIGN KEY (medicine_id) REFERENCES medicines (id)
          )
        ''');
      },
      version: 1,
    );
  }

  // Fertility methods
  Future<void> saveFertilityData(FertilityData data) async {
    await _database.insert(
      'fertility_data',
      {
        'period_start': data.periodStart.toIso8601String(),
        'period_end': data.periodEnd.toIso8601String(),
        'cycle_length': data.cycleLength,
        'next_period_date': data.nextPeriodDate.toIso8601String(),
        'ovulation_date': data.ovulationDate.toIso8601String(),
        'fertile_days': data.fertileDays.map((d) => d.toIso8601String()).join(','),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<FertilityData?> getLatestFertilityData() async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'fertility_data',
      orderBy: 'id DESC',
      limit: 1,
    );

    if (maps.isNotEmpty) {
      final map = maps.first;
      return FertilityData(
        id: map['id'],
        periodStart: DateTime.parse(map['period_start']),
        periodEnd: DateTime.parse(map['period_end']),
        cycleLength: map['cycle_length'],
        nextPeriodDate: DateTime.parse(map['next_period_date']),
        ovulationDate: DateTime.parse(map['ovulation_date']),
        fertileDays: map['fertile_days']
            .split(',')
            .map<DateTime>((d) => DateTime.parse(d))
            .toList(),
      );
    }
    return null;
  }

  // Fluid methods
  Future<void> saveFluidIntake(FluidIntake intake) async {
    await _database.insert(
      'fluid_intake',
      intake.toJson()..remove('id'),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<FluidIntake>> getTodayFluidIntake() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final List<Map<String, dynamic>> maps = await _database.query(
      'fluid_intake',
      where: 'date >= ? AND date < ?',
      whereArgs: [startOfDay.toIso8601String(), endOfDay.toIso8601String()],
    );

    return List.generate(maps.length, (i) => FluidIntake.fromJson(maps[i]));
  }

  // Medicine methods
  Future<int> saveMedicine(Medicine medicine) async {
    return await _database.insert(
      'medicines',
      {
        'name': medicine.name,
        'type': medicine.type.index,
        'scheduled_times': medicine.scheduledTimes.map((t) => t.toIso8601String()).join(','),
        'is_active': medicine.isActive ? 1 : 0,
        'notes': medicine.notes,
        'created_at': medicine.createdAt.toIso8601String(),
      },
    );
  }

  Future<List<Medicine>> getAllMedicines() async {
    final List<Map<String, dynamic>> maps = await _database.query('medicines');
    return List.generate(maps.length, (i) {
      return Medicine(
        id: maps[i]['id'],
        name: maps[i]['name'],
        type: MedicineType.values[maps[i]['type']],
        scheduledTimes: maps[i]['scheduled_times']
            .split(',')
            .map<DateTime>((t) => DateTime.parse(t))
            .toList(),
        isActive: maps[i]['is_active'] == 1,
        notes: maps[i]['notes'],
        createdAt: DateTime.parse(maps[i]['created_at']),
      );
    });
  }

  Future<void> deleteMedicine(int medicineId) async {
  await _database.delete(
    'medicines',
    where: 'id = ?',
    whereArgs: [medicineId],
  );
  
  // Also delete related medicine intake records
  await _database.delete(
    'medicine_intake',
    where: 'medicine_id = ?',
    whereArgs: [medicineId],
  );
}

Future<void> updateMedicineStatus(int medicineId, bool isActive) async {
  await _database.update(
    'medicines',
    {'is_active': isActive ? 1 : 0},
    where: 'id = ?',
    whereArgs: [medicineId],
  );
}

  // Settings methods
  void saveFluidSettings(FluidSettings settings) {
    _box.write('fluid_settings', settings.toJson());
  }

  FluidSettings? getFluidSettings() {
    final data = _box.read('fluid_settings');
    return data != null ? FluidSettings.fromJson(data) : null;
  }

  bool isFirstTime() => _box.read('is_first_time') ?? true;
  void setFirstTime(bool value) => _box.write('is_first_time', value);
}