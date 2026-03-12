import '../models/exercise.dart';

class ExerciseDatabase {
  static List<Exercise> getAllExercises() => _exercises;

  static List<Exercise> searchExercises(String query) {
    final lower = query.toLowerCase().trim();
    if (lower.isEmpty) return _exercises;
    return _exercises.where((e) {
      return e.name.toLowerCase().contains(lower) ||
          e.category.toLowerCase().contains(lower) ||
          e.equipment.toLowerCase().contains(lower);
    }).toList();
  }

  static const List<Exercise> _exercises = [
    // Chest
    Exercise(
        id: 'ex1',
        name: 'Assisted Dip',
        category: 'Chest (Lower Chest)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex2',
        name: 'Band-Assisted Bench Press',
        category: 'Chest (Middle Chest)',
        equipment: 'Band'),
    Exercise(
        id: 'ex3',
        name: 'Bar Dip',
        category: 'Chest (Lower Chest)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex4',
        name: 'Bench Press',
        category: 'Chest (Middle Chest)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex5',
        name: 'Bench Press Against Band',
        category: 'Chest (Middle Chest)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex6',
        name: 'Board Press',
        category: 'Chest (Middle Chest)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex7',
        name: 'Cable Chest Press',
        category: 'Chest (Middle Chest)',
        equipment: 'Cable'),
    Exercise(
        id: 'ex8',
        name: 'Clap Push-Up',
        category: 'Chest (Middle Chest)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex9',
        name: 'Close-Grip Bench Press',
        category: 'Chest (Middle Chest)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex10',
        name: 'Close-Grip Feet-Up Bench Press',
        category: 'Chest (Middle Chest)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex11',
        name: 'Cobra Push-Up',
        category: 'Chest (Lower Chest)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex12',
        name: 'Decline Bench Press',
        category: 'Chest (Lower Chest)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex13',
        name: 'Decline Push-Up',
        category: 'Chest (Upper Chest)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex14',
        name: 'Dumbbell Chest Fly',
        category: 'Chest (Middle Chest)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex15',
        name: 'Dumbbell Chest Press',
        category: 'Chest (Middle Chest)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex16',
        name: 'Dumbbell Decline Chest Press',
        category: 'Chest (Lower Chest)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex17',
        name: 'Dumbbell Floor Press',
        category: 'Chest (Middle Chest)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex18',
        name: 'Dumbbell Pullover',
        category: 'Chest (Lower Chest)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex19',
        name: 'Feet-Up Bench Press',
        category: 'Chest (Middle Chest)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex20',
        name: 'Floor Press',
        category: 'Chest (Middle Chest)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex21',
        name: 'Incline Bench Press',
        category: 'Chest (Upper Chest)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex22',
        name: 'Incline Dumbbell Press',
        category: 'Chest (Upper Chest)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex23',
        name: 'Incline Push-Up',
        category: 'Chest (Lower Chest)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex24',
        name: 'Kettlebell Floor Press',
        category: 'Chest (Middle Chest)',
        equipment: 'kettlebell'),
    Exercise(
        id: 'ex25',
        name: 'Kneeling Incline Push-Up',
        category: 'Chest (Lower Chest)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex26',
        name: 'Kneeling Push-Up',
        category: 'Chest (Middle Chest)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex27',
        name: 'Machine Chest Fly',
        category: 'Chest (Middle Chest)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex28',
        name: 'Machine Chest Press',
        category: 'Chest (Middle Chest)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex29',
        name: 'Medicin Ball Chest Pass',
        category: 'Chest (Middle Chest)',
        equipment: 'Medicine Ball'),
    Exercise(
        id: 'ex30',
        name: 'Pec Deck',
        category: 'Chest (Middle Chest)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex31',
        name: 'Pin Bench Press',
        category: 'Chest (Middle Chest)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex32',
        name: 'Plank to Push-Up',
        category: 'Chest (Middle Chest)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex33',
        name: 'Push-Up',
        category: 'Chest (Middle Chest)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex34',
        name: 'Push-Up Against Wall',
        category: 'Chest (Middle Chest)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex35',
        name: 'Push-Ups With Feet in Rings',
        category: 'Chest (Middle Chest)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex36',
        name: 'Resistance Band Chest Fly',
        category: 'Chest (Middle Chest)',
        equipment: 'Band'),
    Exercise(
        id: 'ex37',
        name: 'Ring Dip',
        category: 'Chest (Lower Chest)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex38',
        name: 'Seated Cable Chest Fly',
        category: 'Chest (Middle Chest)',
        equipment: 'Cable'),
    Exercise(
        id: 'ex39',
        name: 'Smith Machine Bench Press',
        category: 'Chest (Middle Chest)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex40',
        name: 'Smith Machine Incline Bench Press',
        category: 'Chest (Upper Chest)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex41',
        name: 'Smith Machine Reverse Grip Bench Press',
        category: 'Chest (Upper Chest)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex42',
        name: 'Standing Cable Chest Fly',
        category: 'Chest (Middle Chest)',
        equipment: 'Cable'),
    Exercise(
        id: 'ex43',
        name: 'Standing Resistance Band Chest Fly',
        category: 'Chest (Middle Chest)',
        equipment: 'Band'),
    // Shoulders
    Exercise(
        id: 'ex44',
        name: 'Arnold Press',
        category: 'Shoulders (Front Delts)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex45',
        name: 'Band External Shoulder Rotation',
        category: 'Shoulders (Rear Delts)',
        equipment: 'Band'),
    Exercise(
        id: 'ex46',
        name: 'Band Internal Shoulder Rotation',
        category: 'Shoulders (Front Delts)',
        equipment: 'Band'),
    Exercise(
        id: 'ex47',
        name: 'Band Pull-Apart',
        category: 'Shoulders (Rear Delts)',
        equipment: 'Band'),
    Exercise(
        id: 'ex48',
        name: 'Banded Face Pull',
        category: 'Shoulders (Rear Delts)',
        equipment: 'Band'),
    Exercise(
        id: 'ex49',
        name: 'Barbell Front Raise',
        category: 'Shoulders (Front Delts)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex50',
        name: 'Barbell Rear Delt Row',
        category: 'Shoulders (Rear Delts)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex51',
        name: 'Barbell Upright Row',
        category: 'Shoulders (Side Delts)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex52',
        name: 'Behind the Neck Press',
        category: 'Shoulders (Side Delts)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex53',
        name: 'Cable Internal Shoulder Rotation',
        category: 'Shoulders (Front Delts)',
        equipment: 'Cable'),
    Exercise(
        id: 'ex54',
        name: 'Cable External Shoulder Rotation',
        category: 'Shoulders (Rear Delts)',
        equipment: 'Cable'),
    Exercise(
        id: 'ex55',
        name: 'Cable Front Raise',
        category: 'Shoulders (Front Delts)',
        equipment: 'Cable'),
    Exercise(
        id: 'ex56',
        name: 'Cable Lateral Raise',
        category: 'Shoulders (Side Delts)',
        equipment: 'Cable'),
    Exercise(
        id: 'ex57',
        name: 'Cable Rear Delt Row',
        category: 'Shoulders (Rear Delts)',
        equipment: 'Cable'),
    Exercise(
        id: 'ex58',
        name: 'Cuban Press',
        category: 'Shoulders (Side Delts)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex59',
        name: 'Devils Press',
        category: 'Shoulders (Front Delts)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex60',
        name: 'Dumbbell Front Raise',
        category: 'Shoulders (Front Delts)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex61',
        name: 'Dumbbell Horizontal Internal Shoulder Rotation',
        category: 'Shoulders (Front Delts)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex62',
        name: 'Dumbbell Horizontal External Shoulder Rotation',
        category: 'Shoulders (Rear Delts)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex63',
        name: 'Dumbbell Lateral Raise',
        category: 'Shoulders (Side Delts)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex64',
        name: 'Dumbbell Rear Delt Row',
        category: 'Shoulders (Rear Delts)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex65',
        name: 'Dumbbell Shoulder Press',
        category: 'Shoulders (Front Delts)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex66',
        name: 'Face Pull',
        category: 'Shoulders (Rear Delts)',
        equipment: 'Cable'),
    Exercise(
        id: 'ex67',
        name: 'Front Hold',
        category: 'Shoulders (Front Delts)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex68',
        name: 'Handstand Push-Up',
        category: 'Shoulders (Front Delts)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex69',
        name: 'Jerk',
        category: 'Shoulders (Front Delts)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex70',
        name: 'Kettlebell Halo',
        category: 'Shoulders (Front Delts)',
        equipment: 'Kettlebell'),
    Exercise(
        id: 'ex71',
        name: 'Kettlebell Press',
        category: 'Shoulders (Front Delts)',
        equipment: 'Kettlebell'),
    Exercise(
        id: 'ex72',
        name: 'Kettlebell Push Press',
        category: 'Shoulders (Front Delts)',
        equipment: 'Kettlebell'),
    Exercise(
        id: 'ex73',
        name: 'Landmine Press',
        category: 'Shoulders (Front Delts)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex74',
        name: 'Lying Dumbbell External Shoulder Rotation',
        category: 'Shoulders (Rear Delts)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex75',
        name: 'Lying Dumbbell Internal Shoulder Rotation',
        category: 'Shoulders (Front Delts)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex76',
        name: 'Machine Lateral Raise',
        category: 'Shoulders (Side Delts)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex77',
        name: 'Machine Shoulder Press',
        category: 'Shoulders (Front Delts)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex78',
        name: 'Monkey Row',
        category: 'Shoulders (Side Delts)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex79',
        name: 'One-Arm Landmine Press',
        category: 'Shoulders (Front Delts)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex80',
        name: 'Overhead Press',
        category: 'Shoulders (Front Delts)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex81',
        name: 'Plate Front Raise',
        category: 'Shoulders (Front Delts)',
        equipment: 'Plate'),
    Exercise(
        id: 'ex82',
        name: 'Poliquin Raise',
        category: 'Shoulders (Side Delts)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex83',
        name: 'Power Jerk',
        category: 'Shoulders (Front Delts)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex84',
        name: 'Push Press',
        category: 'Shoulders (Front Delts)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex85',
        name: 'Resistance Band Lateral Raise',
        category: 'Shoulders (Side Delts)',
        equipment: 'Band'),
    Exercise(
        id: 'ex86',
        name: 'Reverse Cable Flyes',
        category: 'Shoulders (Rear Delts)',
        equipment: 'Cable'),
    Exercise(
        id: 'ex87',
        name: 'Reverse Dumbbell Flyes',
        category: 'Shoulders (Rear Delts)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex88',
        name: 'Reverse Dumbbell Flyes on Incline Bench',
        category: 'Shoulders (Rear Delts)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex89',
        name: 'Reverse Machine Fly',
        category: 'Shoulders (Rear Delts)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex90',
        name: 'Seated Dumbbell Shoulder Press',
        category: 'Shoulders (Front Delts)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex91',
        name: 'Seated Barbell Overhead Press',
        category: 'Shoulders (Front Delts)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex92',
        name: 'Seated Kettlebell Press',
        category: 'Shoulders (Front Delts)',
        equipment: 'Kettlebell'),
    Exercise(
        id: 'ex93',
        name: 'Seated Smith Machine Shoulder Press',
        category: 'Shoulders (Front Delts)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex94',
        name: 'Smith Machine Landmine Press',
        category: 'Shoulders (Front Delts)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex95',
        name: 'Snatch Grip Behind the Neck Press',
        category: 'Shoulders (Side Delts)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex96',
        name: 'Squat Jerk',
        category: 'Shoulders (Front Delts)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex97',
        name: 'Split Jerk',
        category: 'Shoulders (Front Delts)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex98',
        name: 'Turkish Get-Up',
        category: 'Shoulders (Front Delts)',
        equipment: 'Kettlebell'),
    Exercise(
        id: 'ex99',
        name: 'Wall Walk',
        category: 'Shoulders (Front Delts)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex100',
        name: 'Z Press',
        category: 'Shoulders (Front Delts)',
        equipment: 'Barbell'),
    // Biceps
    Exercise(
        id: 'ex101',
        name: 'Barbell Curl',
        category: 'Biceps (Short Head Bicep)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex102',
        name: 'Barbell Preacher Curl',
        category: 'Biceps (Short Head Bicep)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex103',
        name: 'Bayesian Curl',
        category: 'Biceps (Long Head Bicep)',
        equipment: 'Cable'),
    Exercise(
        id: 'ex104',
        name: 'Bodyweight Curl',
        category: 'Biceps (Short Head Bicep)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex105',
        name: 'Cable Crossover Bicep Curl',
        category: 'Biceps (Short Head Bicep)',
        equipment: 'Cable'),
    Exercise(
        id: 'ex106',
        name: 'Cable Curl With Bar',
        category: 'Biceps (Short Head Bicep)',
        equipment: 'Cable'),
    Exercise(
        id: 'ex107',
        name: 'Cable Curl With Rope',
        category: 'Biceps (Brachioradialis)',
        equipment: 'Cable'),
    Exercise(
        id: 'ex108',
        name: 'Concentration Curl',
        category: 'Biceps (Short Head Bicep)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex109',
        name: 'Drag Curl',
        category: 'Biceps (Long Head Bicep)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex110',
        name: 'Dumbbell Curl',
        category: 'Biceps (Short Head Bicep)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex111',
        name: 'Dumbbell Preacher Curl',
        category: 'Biceps (Short Head Bicep)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex112',
        name: 'EZ Curl',
        category: 'Biceps (Short Head Bicep)',
        equipment: 'EZ Bar'),
    Exercise(
        id: 'ex113',
        name: 'Hammer Curl',
        category: 'Biceps (Brachialis)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex114',
        name: 'Incline Dumbbell Curl',
        category: 'Biceps (Long Head Bicep)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex115',
        name: 'Kettlebell Curl',
        category: 'Biceps (Short Head Bicep)',
        equipment: 'Kettlebell'),
    Exercise(
        id: 'ex116',
        name: 'Lying Bicep Cable Curl on Bench',
        category: 'Biceps (Short Head Bicep)',
        equipment: 'Cable'),
    Exercise(
        id: 'ex117',
        name: 'Lying Bicep Cable Curl on Floor',
        category: 'Biceps (Short Head Bicep)',
        equipment: 'Cable'),
    Exercise(
        id: 'ex118',
        name: 'Machine Bicep Curl',
        category: 'Biceps (Short Head Bicep)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex119',
        name: 'Overhead Cable Curl',
        category: 'Biceps (Short Head Bicep)',
        equipment: 'Cable'),
    Exercise(
        id: 'ex120',
        name: 'Reverse Barbell Curl',
        category: 'Biceps (Brachioradialis)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex121',
        name: 'Reverse Dumbbell Curl',
        category: 'Biceps (Brachioradialis)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex122',
        name: 'Resistance Band Curl',
        category: 'Biceps (Short Head Bicep)',
        equipment: 'Band'),
    Exercise(
        id: 'ex123',
        name: 'Spider Curl',
        category: 'Biceps (Short Head Bicep)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex124',
        name: 'Zottman Curl',
        category: 'Biceps (Brachioradialis)',
        equipment: 'Dumbbell'),
    // Triceps
    Exercise(
        id: 'ex125',
        name: 'Barbell Standing Triceps Extension',
        category: 'Triceps (Long Head Tricep)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex126',
        name: 'Barbell Incline Triceps Extension',
        category: 'Triceps (Long Head Tricep)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex127',
        name: 'Barbell Lying Triceps Extension',
        category: 'Triceps (Medial Head Tricep)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex128',
        name: 'Bench Dip',
        category: 'Triceps (Medial Head Tricep)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex129',
        name: 'Crossbody Cable Triceps Extension',
        category: 'Triceps (Lateral Head Tricep)',
        equipment: 'Cable'),
    Exercise(
        id: 'ex130',
        name: 'Close-Grip Push-Up',
        category: 'Triceps (Medial Head Tricep)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex131',
        name: 'Dumbbell Lying Triceps Extension',
        category: 'Triceps (Medial Head Tricep)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex132',
        name: 'Dumbbell Standing Triceps Extension',
        category: 'Triceps (Long Head Tricep)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex133',
        name: 'EZ Bar Lying Triceps Extension',
        category: 'Triceps (Medial Head Tricep)',
        equipment: 'EZ Bar'),
    Exercise(
        id: 'ex134',
        name: 'Machine Overhead Triceps Extension',
        category: 'Triceps (Long Head Tricep)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex135',
        name: 'Overhead Cable Triceps Extension',
        category: 'Triceps (Lower Position) (Long Head Tricep)',
        equipment: 'Cable'),
    Exercise(
        id: 'ex136',
        name: 'Overhead Cable Triceps Extension',
        category: 'Triceps (Upper Position) (Long Head Tricep)',
        equipment: 'Cable'),
    Exercise(
        id: 'ex137',
        name: 'Smith Machine Skull Crushers',
        category: 'Triceps (Medial Head Tricep)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex138',
        name: 'Tate Press',
        category: 'Triceps (Medial Head Tricep)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex139',
        name: 'Tricep Bodyweight Extension',
        category: 'Triceps (Medial Head Tricep)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex140',
        name: 'Tricep Pushdown With Bar',
        category: 'Triceps (Lateral Head Tricep)',
        equipment: 'Cable'),
    Exercise(
        id: 'ex141',
        name: 'Tricep Pushdown With Rope',
        category: 'Triceps (Lateral Head Tricep)',
        equipment: 'Cable'),
    // Legs
    Exercise(
        id: 'ex142',
        name: 'Air Squat',
        category: 'Legs (Quads)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex143',
        name: 'Banded Hip March',
        category: 'Legs (Glutes)',
        equipment: 'Band'),
    Exercise(
        id: 'ex144',
        name: 'Barbell Hack Squat',
        category: 'Legs (Quads)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex145',
        name: 'Barbell Lunge',
        category: 'Legs (Quads)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex146',
        name: 'Barbell Walking Lunge',
        category: 'Legs (Quads)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex147',
        name: 'Belt Squat',
        category: 'Legs (Quads)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex148',
        name: 'Body Weight Lunge',
        category: 'Legs (Quads)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex149',
        name: 'Bodyweight Leg Curl',
        category: 'Legs (Hamstrings)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex150',
        name: 'Box Jump',
        category: 'Legs (Quads)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex151',
        name: 'Box Squat',
        category: 'Legs (Quads)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex152',
        name: 'Bulgarian Split Squat',
        category: 'Legs (Quads)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex153',
        name: 'Cable Machine Hip Adduction',
        category: 'Legs (Adductors)',
        equipment: 'Cable'),
    Exercise(
        id: 'ex154',
        name: 'Chair Squat',
        category: 'Legs (Quads)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex155',
        name: 'Curtsy Lunge',
        category: 'Legs (Glutes)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex156',
        name: 'Depth Jump',
        category: 'Legs (Quads)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex157',
        name: 'Dumbbell Lunge',
        category: 'Legs (Quads)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex158',
        name: 'Dumbbell Walking Lunge',
        category: 'Legs (Quads)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex159',
        name: 'Dumbbell Squat',
        category: 'Legs (Quads)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex160',
        name: 'Front Squat',
        category: 'Legs (Quads)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex161',
        name: 'Glute Ham Raise',
        category: 'Legs (Hamstrings)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex162',
        name: 'Goblet Squat',
        category: 'Legs (Quads)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex163',
        name: 'Ground to Overhead',
        category: 'Legs (Quads)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex164',
        name: 'Hack Squat Machine',
        category: 'Legs (Quads)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex165',
        name: 'Half Air Squat',
        category: 'Legs (Quads)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex166',
        name: 'Heel Walk',
        category: 'Legs (Quads)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex167',
        name: 'Hip Adduction Against Band',
        category: 'Legs (Adductors)',
        equipment: 'Band'),
    Exercise(
        id: 'ex168',
        name: 'Hip Adduction Machine',
        category: 'Legs (Adductors)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex169',
        name: 'Jump Squat',
        category: 'Legs (Quads)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex170',
        name: 'Jumping Lunge',
        category: 'Legs (Quads)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex171',
        name: 'Kettlebell Front Squat',
        category: 'Legs (Quads)',
        equipment: 'Kettlebell'),
    Exercise(
        id: 'ex172',
        name: 'Kettlebell Thrusters',
        category: 'Legs (Quads)',
        equipment: 'Kettlebell'),
    Exercise(
        id: 'ex173',
        name: 'Kettlebell Tibialis Raise',
        category: 'Legs (Quads)',
        equipment: 'Kettlebell'),
    Exercise(
        id: 'ex174',
        name: 'Landmine Hack Squat',
        category: 'Legs (Quads)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex175',
        name: 'Landmine Squat',
        category: 'Legs (Quads)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex176',
        name: 'Lateral Bound',
        category: 'Legs (Glutes)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex177',
        name: 'Leg Curl On Ball',
        category: 'Legs (Hamstrings)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex178',
        name: 'Leg Extension',
        category: 'Legs (Quads)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex179',
        name: 'Leg Press',
        category: 'Legs (Quads)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex180',
        name: 'Lying Leg Curl',
        category: 'Legs (Hamstrings)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex181',
        name: 'Nordic Hamstring Eccentric',
        category: 'Legs (Hamstrings)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex182',
        name: 'One-Legged Leg Extension',
        category: 'Legs (Quads)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex183',
        name: 'One-Legged Lying Leg Curl',
        category: 'Legs (Hamstrings)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex184',
        name: 'One-Legged Seated Leg Curl',
        category: 'Legs (Hamstrings)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex185',
        name: 'Pause Squat',
        category: 'Legs (Quads)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex186',
        name: 'Pendulum Squat',
        category: 'Legs (Quads)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex187',
        name: 'Pin Squat',
        category: 'Legs (Quads)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex188',
        name: 'Romanian Deadlift',
        category: 'Legs (Hamstrings)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex189',
        name: 'Safety Bar Squat',
        category: 'Legs (Quads)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex190',
        name: 'Seated Leg Curl',
        category: 'Legs (Hamstrings)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex191',
        name: 'Shallow Body Weight Lunge',
        category: 'Legs (Quads)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex192',
        name: 'Side Lunges',
        category: 'Legs (Adductors)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex193',
        name: 'Smith Machine Bulgarian Split Squat',
        category: 'Legs (Quads)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex194',
        name: 'Smith Machine Front Squat',
        category: 'Legs (Quads)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex195',
        name: 'Smith Machine Lunge',
        category: 'Legs (Quads)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex196',
        name: 'Smith Machine Romanian Deadlift',
        category: 'Legs (Hamstrings)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex197',
        name: 'Smith Machine Squat',
        category: 'Legs (Quads)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex198',
        name: 'Sumo Squat',
        category: 'Legs (Glutes)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex199',
        name: 'Squat',
        category: 'Legs (Quads)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex200',
        name: 'Standing Cable Leg Extension',
        category: 'Legs (Quads)',
        equipment: 'Cable'),
    Exercise(
        id: 'ex201',
        name: 'Standing Hip Flexor Raise',
        category: 'Legs (Quads)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex202',
        name: 'Standing Leg Curl',
        category: 'Legs (Hamstrings)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex203',
        name: 'Step Up',
        category: 'Legs (Quads)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex204',
        name: 'Tibialis Band Pull',
        category: 'Legs (Quads)',
        equipment: 'Band'),
    Exercise(
        id: 'ex205',
        name: 'Tibialis Raise',
        category: 'Legs (Quads)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex206',
        name: 'Vertical Leg Press',
        category: 'Legs (Quads)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex207',
        name: 'Zercher Squat',
        category: 'Legs (Quads)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex208',
        name: 'Zombie Squat',
        category: 'Legs (Quads)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex209',
        name: 'Pistol Squat',
        category: 'Legs (Quads)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex210',
        name: 'Poliquin Step-Up',
        category: 'Legs (Quads)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex211',
        name: 'Prisoner Get Up',
        category: 'Legs (Quads)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex212',
        name: 'Reverse Barbell Lunge',
        category: 'Legs (Quads)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex213',
        name: 'Reverse Body Weight Lunge',
        category: 'Legs (Quads)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex214',
        name: 'Reverse Dumbbell Lunge',
        category: 'Legs (Quads)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex215',
        name: 'Reverse Nordic',
        category: 'Legs (Quads)',
        equipment: 'Bodyweight'),
    // Back
    Exercise(
        id: 'ex216',
        name: 'Assisted Chin-Up',
        category: 'Back (Lower Lats)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex217',
        name: 'Assisted Pull-Up',
        category: 'Back (Upper Lats)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex218',
        name: 'Back Extension',
        category: 'Back (Lower Back)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex219',
        name: 'Banded Muscle-Up',
        category: 'Back (Upper Lats)',
        equipment: 'Band'),
    Exercise(
        id: 'ex220',
        name: 'Barbell Row',
        category: 'Back (Mid Back)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex221',
        name: 'Barbell Shrug',
        category: 'Back (Traps)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex222',
        name: 'Block Clean',
        category: 'Back (Upper Back)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex223',
        name: 'Block Snatch',
        category: 'Back (Upper Back)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex224',
        name: 'Cable Close Grip Seated Row',
        category: 'Back (Mid Back)',
        equipment: 'Cable'),
    Exercise(
        id: 'ex225',
        name: 'Cable Wide Grip Seated Row',
        category: 'Back (Upper Back)',
        equipment: 'Cable'),
    Exercise(
        id: 'ex226',
        name: 'Chest-Supported Dumbbell Row',
        category: 'Back (Mid Back)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex227',
        name: 'Chest to Bar',
        category: 'Back (Upper Lats)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex228',
        name: 'Chin-Up',
        category: 'Back (Lower Lats)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex229',
        name: 'Clean',
        category: 'Back (Upper Back)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex230',
        name: 'Clean and Jerk',
        category: 'Back (Upper Back)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex231',
        name: 'Close-Grip Chin-Up',
        category: 'Back (Lower Lats)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex232',
        name: 'Close-Grip Lat Pulldown',
        category: 'Back (Lower Lats)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex233',
        name: 'Deadlift',
        category: 'Back (Lower Back)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex234',
        name: 'Deficit Deadlift',
        category: 'Back (Lower Back)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex235',
        name: 'Dumbbell Deadlift',
        category: 'Back (Lower Back)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex236',
        name: 'Dumbbell Row',
        category: 'Back (Mid Back)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex237',
        name: 'Dumbbell Shrug',
        category: 'Back (Traps)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex238',
        name: 'Floor Back Extension',
        category: 'Back (Lower Back)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex239',
        name: 'Good Morning',
        category: 'Back (Lower Back)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex240',
        name: 'Gorilla Row',
        category: 'Back (Mid Back)',
        equipment: 'Kettlebell'),
    Exercise(
        id: 'ex241',
        name: 'Hang Clean',
        category: 'Back (Upper Back)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex242',
        name: 'Hang Power Clean',
        category: 'Back (Upper Back)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex243',
        name: 'Hang Power Snatch',
        category: 'Back (Upper Back)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex244',
        name: 'Hang Snatch',
        category: 'Back (Upper Back)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex245',
        name: 'Inverted Row',
        category: 'Back (Mid Back)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex246',
        name: 'Inverted Row with Underhand Grip',
        category: 'Back (Lower Lats)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex247',
        name: 'Jefferson Curl',
        category: 'Back (Lower Back)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex248',
        name: 'Jumping Muscle-Up',
        category: 'Back (Upper Lats)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex249',
        name: 'Kettlebell Clean',
        category: 'Back (Upper Back)',
        equipment: 'Kettlebell'),
    Exercise(
        id: 'ex250',
        name: 'Kettlebell Clean & Jerk',
        category: 'Back (Upper Back)',
        equipment: 'Kettlebell'),
    Exercise(
        id: 'ex251',
        name: 'Kettlebell Clean & Press',
        category: 'Back (Upper Back)',
        equipment: 'Kettlebell'),
    Exercise(
        id: 'ex252',
        name: 'Kettlebell Row',
        category: 'Back (Mid Back)',
        equipment: 'Kettlebell'),
    Exercise(
        id: 'ex253',
        name: 'Kettlebell Snatch',
        category: 'Back (Upper Back)',
        equipment: 'Kettlebell'),
    Exercise(
        id: 'ex254',
        name: 'Kettlebell Swing',
        category: 'Back (Lower Back)',
        equipment: 'Kettlebell'),
    Exercise(
        id: 'ex255',
        name: 'Kroc Row',
        category: 'Back (Mid Back)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex256',
        name: 'Lat Pulldown With Neutral Grip',
        category: 'Back (Lower Lats)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex257',
        name: 'Lat Pulldown With Pronated Grip',
        category: 'Back (Upper Lats)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex258',
        name: 'Lat Pulldown With Supinated Grip',
        category: 'Back (Lower Lats)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex259',
        name: 'Machine Lat Pulldown',
        category: 'Back (Upper Lats)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex260',
        name: 'Muscle-Up',
        category: 'Back (Bar) (Upper Lats)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex261',
        name: 'Muscle-Up',
        category: 'Back (Rings) (Upper Lats)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex262',
        name: 'Neutral Close-Grip Lat Pulldown',
        category: 'Back (Lower Lats)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex263',
        name: 'One-Handed Cable Row',
        category: 'Back (Mid Back)',
        equipment: 'Cable'),
    Exercise(
        id: 'ex264',
        name: 'One-Handed Kettlebell Swing',
        category: 'Back (Lower Back)',
        equipment: 'Kettlebell'),
    Exercise(
        id: 'ex265',
        name: 'One-Handed Lat Pulldown',
        category: 'Back (Lower Lats)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex266',
        name: 'Pause Deadlift',
        category: 'Back (Lower Back)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex267',
        name: 'Pendlay Row',
        category: 'Back (Mid Back)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex268',
        name: 'Power Clean',
        category: 'Back (Upper Back)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex269',
        name: 'Power Snatch',
        category: 'Back (Upper Back)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex270',
        name: 'Pull-Up',
        category: 'Back (Upper Lats)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex271',
        name: 'Pull-Up With a Neutral Grip',
        category: 'Back (Lower Lats)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex272',
        name: 'Rack Pull',
        category: 'Back (Lower Back)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex273',
        name: 'Renegade Row',
        category: 'Back (Mid Back)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex274',
        name: 'Rope Pulldown',
        category: 'Back (Lower Lats)',
        equipment: 'Cable'),
    Exercise(
        id: 'ex275',
        name: 'Ring Pull-Up',
        category: 'Back (Upper Lats)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex276',
        name: 'Ring Row',
        category: 'Back (Mid Back)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex277',
        name: 'Scap Pull-Up',
        category: 'Back (Upper Back)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex278',
        name: 'Seal Row',
        category: 'Back (Mid Back)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex279',
        name: 'Seated Machine Row',
        category: 'Back (Mid Back)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex280',
        name: 'Single Leg Deadlift with Kettlebell',
        category: 'Back (Lower Back)',
        equipment: 'Kettlebell'),
    Exercise(
        id: 'ex281',
        name: 'Smith Machine Deadlift',
        category: 'Back (Lower Back)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex282',
        name: 'Smith Machine One-Handed Row',
        category: 'Back (Mid Back)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex283',
        name: 'Snatch',
        category: 'Back (Upper Back)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex284',
        name: 'Snatch Grip Deadlift',
        category: 'Back (Upper Back)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex285',
        name: 'Stiff-Legged Deadlift',
        category: 'Back (Lower Back)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex286',
        name: 'Straight Arm Lat Pulldown',
        category: 'Back (Lower Lats)',
        equipment: 'Cable'),
    Exercise(
        id: 'ex287',
        name: 'Sumo Deadlift',
        category: 'Back (Lower Back)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex288',
        name: 'Superman Raise',
        category: 'Back (Lower Back)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex289',
        name: 'T-Bar Row',
        category: 'Back (Mid Back)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex290',
        name: 'Towel Row',
        category: 'Back (Mid Back)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex291',
        name: 'Trap Bar Deadlift With High Handles',
        category: 'Back (Lower Back)',
        equipment: 'Trap Bar'),
    Exercise(
        id: 'ex292',
        name: 'Trap Bar Deadlift With Low Handles',
        category: 'Back (Lower Back)',
        equipment: 'Trap Bar'),
    // Glutes
    Exercise(
        id: 'ex293',
        name: 'Banded Side Kicks',
        category: 'Glutes (Glutes)',
        equipment: 'Band'),
    Exercise(
        id: 'ex294',
        name: 'Cable Glute Kickback',
        category: 'Glutes (Glutes)',
        equipment: 'Cable'),
    Exercise(
        id: 'ex295',
        name: 'Cable Pull Through',
        category: 'Glutes (Glutes)',
        equipment: 'Cable'),
    Exercise(
        id: 'ex296',
        name: 'Cable Machine Hip Abduction',
        category: 'Glutes (Glutes)',
        equipment: 'Cable'),
    Exercise(
        id: 'ex297',
        name: 'Clamshells',
        category: 'Glutes (Glutes)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex298',
        name: 'Cossack Squat',
        category: 'Glutes (Glutes)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex299',
        name: 'Death March with Dumbbells',
        category: 'Glutes (Glutes)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex300',
        name: 'Donkey Kicks',
        category: 'Glutes (Glutes)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex301',
        name: 'Dumbbell Romanian Deadlift',
        category: 'Glutes (Glutes)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex302',
        name: 'Dumbbell Frog Pumps',
        category: 'Glutes (Glutes)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex303',
        name: 'Fire Hydrants',
        category: 'Glutes (Glutes)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex304',
        name: 'Frog Pumps',
        category: 'Glutes (Glutes)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex305',
        name: 'Glute Bridge',
        category: 'Glutes (Glutes)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex306',
        name: 'Hip Abduction Against Band',
        category: 'Glutes (Glutes)',
        equipment: 'Band'),
    Exercise(
        id: 'ex307',
        name: 'Hip Abduction Machine',
        category: 'Glutes (Glutes)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex308',
        name: 'Hip Thrust',
        category: 'Glutes (Glutes)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex309',
        name: 'Hip Thrust Machine',
        category: 'Glutes (Glutes)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex310',
        name: 'Hip Thrust With Band Around Knees',
        category: 'Glutes (Glutes)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex311',
        name: 'Kettlebell Windmill',
        category: 'Glutes (Glutes)',
        equipment: 'Kettlebell'),
    Exercise(
        id: 'ex312',
        name: 'Lateral Walk With Band',
        category: 'Glutes (Glutes)',
        equipment: 'Band'),
    Exercise(
        id: 'ex313',
        name: 'Machine Glute Kickbacks',
        category: 'Glutes (Glutes)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex314',
        name: 'One-Legged Glute Bridge',
        category: 'Glutes (Glutes)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex315',
        name: 'One-Legged Hip Thrust',
        category: 'Glutes (Glutes)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex316',
        name: 'Reverse Hyperextension',
        category: 'Glutes (Glutes)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex317',
        name: 'Smith Machine Hip Thrust',
        category: 'Glutes (Glutes)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex318',
        name: 'Single Leg Romanian Deadlift',
        category: 'Glutes (Glutes)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex319',
        name: 'Standing Hip Abduction Against Band',
        category: 'Glutes (Glutes)',
        equipment: 'Band'),
    Exercise(
        id: 'ex320',
        name: 'Standing Glute Kickback in Machine',
        category: 'Glutes (Glutes)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex321',
        name: 'Standing Glute Push Down',
        category: 'Glutes (Glutes)',
        equipment: 'Machine'),
    // Abs
    Exercise(
        id: 'ex322',
        name: 'Ball Slams',
        category: 'Abs (Core)',
        equipment: 'Medicine Ball'),
    Exercise(
        id: 'ex323',
        name: 'Bicycle Crunch',
        category: 'Abs (Obliques)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex324',
        name: 'Cable Crunch',
        category: 'Abs (Upper Abs)',
        equipment: 'Cable'),
    Exercise(
        id: 'ex325',
        name: 'Captain\'s Chair',
        category: 'Abs (Lower Abs)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex326',
        name: 'Dragon Flag',
        category: 'Abs (Core)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex327',
        name: 'Dumbbell Side Bend',
        category: 'Abs (Obliques)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex328',
        name: 'Dynamic Side Plank',
        category: 'Abs (Obliques)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex329',
        name: 'Hanging Knee Raise',
        category: 'Abs (Lower Abs)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex330',
        name: 'Hanging Leg Raise',
        category: 'Abs (Lower Abs)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex331',
        name: 'Hanging Sit-Up',
        category: 'Abs (Upper Abs)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex332',
        name: 'Hanging Windshield Wiper',
        category: 'Abs (Obliques)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex333',
        name: 'High to Low Wood Chop with Band',
        category: 'Abs (Obliques)',
        equipment: 'Band'),
    Exercise(
        id: 'ex334',
        name: 'High to Low Wood Chop with Cable',
        category: 'Abs (Obliques)',
        equipment: 'Cable'),
    Exercise(
        id: 'ex335',
        name: 'Hollow Body Crunch',
        category: 'Abs (Core)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex336',
        name: 'Hollow Hold',
        category: 'Abs (Core)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex337',
        name: 'Horizontal Wood Chop with Band',
        category: 'Abs (Obliques)',
        equipment: 'Band'),
    Exercise(
        id: 'ex338',
        name: 'Horizontal Wood Chop with Cable',
        category: 'Abs (Obliques)',
        equipment: 'Cable'),
    Exercise(
        id: 'ex339',
        name: 'Jackknife Sit-Up',
        category: 'Abs (Upper Abs)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex340',
        name: 'Kettlebell Plank Pull Through',
        category: 'Abs (Core)',
        equipment: 'Kettlebell'),
    Exercise(
        id: 'ex341',
        name: 'Kneeling Ab Wheel Roll-Out',
        category: 'Abs (Core)',
        equipment: 'Ab Wheel'),
    Exercise(
        id: 'ex342',
        name: 'Kneeling Plank',
        category: 'Abs (Core)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex343',
        name: 'Kneeling Side Plank',
        category: 'Abs (Obliques)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex344',
        name: 'Landmine Rotation',
        category: 'Abs (Obliques)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex345',
        name: 'L-Sit',
        category: 'Abs (Core)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex346',
        name: 'Low to High Wood Chop with Band',
        category: 'Abs (Obliques)',
        equipment: 'Band'),
    Exercise(
        id: 'ex347',
        name: 'Low to High Wood Chop with Cable',
        category: 'Abs (Obliques)',
        equipment: 'Cable'),
    Exercise(
        id: 'ex348',
        name: 'Lying Leg Raise',
        category: 'Abs (Lower Abs)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex349',
        name: 'Lying Windshield Wiper',
        category: 'Abs (Obliques)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex350',
        name: 'Lying Windshield Wiper with Bent Knees',
        category: 'Abs (Obliques)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex351',
        name: 'Machine Crunch',
        category: 'Abs (Upper Abs)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex352',
        name: 'Mountain Climbers',
        category: 'Abs (Core)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex353',
        name: 'Oblique Crunch',
        category: 'Abs (Obliques)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex354',
        name: 'Oblique Sit-Up',
        category: 'Abs (Obliques)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex355',
        name: 'Pallof Press',
        category: 'Abs (Core)',
        equipment: 'Cable'),
    Exercise(
        id: 'ex356',
        name: 'Plank',
        category: 'Abs (Core)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex357',
        name: 'Plank with Leg Lifts',
        category: 'Abs (Core)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex358',
        name: 'Plank with Shoulder Taps',
        category: 'Abs (Core)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex359',
        name: 'Side Plank',
        category: 'Abs (Obliques)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex360',
        name: 'Knee Raise',
        category: 'Abs (Lower Abs)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex361',
        name: 'Sit-Up',
        category: 'Abs (Upper Abs)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex362',
        name: 'Weighted Plank',
        category: 'Abs (Core)',
        equipment: 'Dumbbell'),
    // Calves
    Exercise(
        id: 'ex363',
        name: 'Barbell Standing Calf Raise',
        category: 'Calves (Gastrocnemius)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex364',
        name: 'Barbell Seated Calf Raise',
        category: 'Calves (Soleus)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex365',
        name: 'Calf Raise in Leg Press',
        category: 'Calves (Gastrocnemius)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex366',
        name: 'Donkey Calf Raise',
        category: 'Calves (Gastrocnemius)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex367',
        name: 'Eccentric Heel Drop',
        category: 'Calves (Gastrocnemius)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex368',
        name: 'Heel Raise',
        category: 'Calves (Gastrocnemius)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex369',
        name: 'Seated Calf Raise',
        category: 'Calves (Soleus)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex370',
        name: 'Standing Calf Raise',
        category: 'Calves (Gastrocnemius)',
        equipment: 'Machine'),
    // Forearms
    Exercise(
        id: 'ex371',
        name: 'Barbell Wrist Curl',
        category: 'Forearms (Forearm Flexors)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex372',
        name: 'Barbell Wrist Curl Behind the Back',
        category: 'Forearms (Forearm Flexors)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex373',
        name: 'Bar Hang',
        category: 'Forearms (Grip)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex374',
        name: 'Dumbbell Wrist Curl',
        category: 'Forearms (Forearm Flexors)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex375',
        name: 'Farmers Walk',
        category: 'Forearms (Grip)',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'ex376',
        name: 'Fat Bar Deadlift',
        category: 'Forearms (Grip)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex377',
        name: 'Gripper',
        category: 'Forearms (Grip)',
        equipment: 'Gripper'),
    Exercise(
        id: 'ex378',
        name: 'One-Handed Bar Hang',
        category: 'Forearms (Grip)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex379',
        name: 'Plate Pinch',
        category: 'Forearms (Grip)',
        equipment: 'Plate'),
    Exercise(
        id: 'ex380',
        name: 'Plate Wrist Curl',
        category: 'Forearms (Forearm Flexors)',
        equipment: 'Plate'),
    Exercise(
        id: 'ex381',
        name: 'Towel Pull-Up',
        category: 'Forearms (Grip)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex382',
        name: 'Wrist Roller',
        category: 'Forearms (Forearm Extensors)',
        equipment: 'Wrist Roller'),
    Exercise(
        id: 'ex383',
        name: 'Barbell Wrist Extension',
        category: 'Forearms (Forearm Extensors)',
        equipment: 'Barbell'),
    Exercise(
        id: 'ex384',
        name: 'Dumbbell Wrist Extension',
        category: 'Forearms (Forearm Extensors)',
        equipment: 'Dumbbell'),
    // Neck
    Exercise(
        id: 'ex385',
        name: 'Lying Neck Curl',
        category: 'Neck (Neck Flexors)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex386',
        name: 'Lying Neck Extension',
        category: 'Neck (Neck Extensors)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex387',
        name: 'Prone Neck Bridge',
        category: 'Neck (Neck Extensors)',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'ex388',
        name: 'Supine Neck Bridge',
        category: 'Neck (Neck Flexors)',
        equipment: 'Bodyweight'),
    // Cardio
    Exercise(
        id: 'ex389',
        name: 'Rowing Machine',
        category: 'Cardio (Full Body Cardio)',
        equipment: 'Machine'),
    Exercise(
        id: 'ex390',
        name: 'Stationary Bike',
        category: 'Cardio (Full Body Cardio)',
        equipment: 'Machine'),
  ];
}
