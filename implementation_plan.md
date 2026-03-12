# 12 Feature Changes — Implementation Plan

## Overview

12 feature changes touching models, services, screens, and app flow. Grouped into 6 phases to manage dependencies.

---

## Phase 1 — Data Model Changes

### [NEW] `lib/models/user_profile.dart`
New Hive model (typeId: 3) storing:
- `String username` — user's display name
- `int weekCount` — cumulative weeks completed
- `int currentDayIndex` — which day the user is currently on

### [NEW] `lib/models/user_profile.g.dart`
Hand-written Hive adapter (same pattern as existing [.g.dart](file:///c:/Users/Admin/Desktop/gym_tracker/lib/models/exercise.g.dart) files).

### [MODIFY] [lib/models/workout_day.dart](file:///c:/Users/Admin/Desktop/gym_tracker/lib/models/workout_day.dart)
No changes needed — existing model supports everything.

### [MODIFY] [lib/models/exercise_instance.dart](file:///c:/Users/Admin/Desktop/gym_tracker/lib/models/exercise_instance.dart)
No schema changes — the existing fields cover what's needed.

---

## Phase 2 — Service Layer Changes

### [MODIFY] [workout_service.dart](file:///c:/Users/Admin/Desktop/gym_tracker/lib/services/workout_service.dart)

**Feature 1 — Exercise re-add retains weight/reps:**
- Add `getLatestExerciseState(String exerciseId)` — scans all days and returns the most recently used weight/reps for that exercise
- Modify [addExerciseToDay()](file:///c:/Users/Admin/Desktop/gym_tracker/lib/services/workout_service.dart#86-91) to accept optional weight/reps overrides

**Feature 3 — Fix weight increment:**
- No change here (this is in the screen), but ensure service [updateExerciseWeight](file:///c:/Users/Admin/Desktop/gym_tracker/lib/services/workout_service.dart#98-104) accepts the correct value.

**Feature 6 — Remove lock restriction:**
- Remove [isDayAccessible()](file:///c:/Users/Admin/Desktop/gym_tracker/lib/services/workout_service.dart#46-54) logic (or make it always return `true`)
- Remove [_autoCompleteRestDays()](file:///c:/Users/Admin/Desktop/gym_tracker/lib/services/workout_service.dart#136-152) — rest days don't need auto-completion anymore
- Keep [canMarkDoneToday()](file:///c:/Users/Admin/Desktop/gym_tracker/lib/services/workout_service.dart#55-69) but simplify it

**Feature 7 — Shared exercise state across days (sync on completion only):**
- Add `syncExerciseAcrossDays(String exerciseId, double weight, int reps)` — updates the same exercise on all other days
- Called only from [markDayDone()](file:///c:/Users/Admin/Desktop/gym_tracker/lib/services/workout_service.dart#122-135) — NOT during live editing. User edits weight/reps freely on one day; other days only update when that workout is marked complete.

**Feature 11 — Week counter:**
- Add `incrementWeekCount()` triggered when all 7 days are completed
- Stored in `UserProfile`

**Feature 12 — Workout summary data:**
- Add `getExerciseSummary(int dayIndex)` that returns a list of comparisons: `{name, currentWeight, currentReps, lastWeight, lastReps, weightDelta, repsDelta}`

**User profile management:**
- Add a `userProfile` Hive box (name: `'userProfile'`)
- `getUsername()`, `setUsername(String)`, `getWeekCount()`, `getCurrentDayIndex()`, `setCurrentDayIndex(int)`

---

## Phase 3 — Splash Screen + Username

### [NEW] `lib/screens/splash_screen.dart`
- Shows a gym-themed logo (generated image) centered on dark background
- 2-second animated display, then:
  - If no username saved → navigate to username input screen
  - If username exists → navigate to home screen

### [NEW] `lib/screens/username_screen.dart`
- Simple screen: text input for username, "Let's Go" button
- Saves username via [WorkoutService](file:///c:/Users/Admin/Desktop/gym_tracker/lib/services/workout_service.dart#5-167), then navigates to home screen

### [MODIFY] [main.dart](file:///c:/Users/Admin/Desktop/gym_tracker/lib/main.dart)
- Register `UserProfileAdapter` in Hive init
- Change `home:` from [HomeScreen](file:///c:/Users/Admin/Desktop/gym_tracker/lib/screens/home_screen.dart#7-14) to `SplashScreen`

---

## Phase 4 — Home Screen Revamp

### [MODIFY] [home_screen.dart](file:///c:/Users/Admin/Desktop/gym_tracker/lib/screens/home_screen.dart)

**Feature 5 — Main screen with progress:**
Already has a progress bar, but will be enhanced:
- **Feature 9 — Greeting:** Show "Hey, {username}! 💪" at the top
- **Feature 10 — Current day indicator:** Show "Today: Day X — {title}" card highlighted
- **Feature 11 — Week counter:** Show "Week {N}" badge near the top
- Progress bar stays, showing day completion

**Feature 4 — Edit day title:**
- Add an edit icon button on each day card
- Tapping opens a dialog with a `TextField` pre-filled with current title
- Calls `workoutService.updateDayTitle(index, newTitle)`

**Feature 6 — Remove lock restriction:**
- All days are always tappable (remove `accessible` check and lock icon)
- Just show chevron arrow for all non-rest days

---

## Phase 5 — Workout Day Screen Changes

### [MODIFY] [workout_day_screen.dart](file:///c:/Users/Admin/Desktop/gym_tracker/lib/screens/workout_day_screen.dart)

**Feature 1 — Re-add retains state:**
- In exercise search, when adding an exercise, check `workoutService.getLatestExerciseState(exerciseId)` for existing weight/reps

**Feature 2 — Rest timer:**
- Add a rest timer button in the app bar or as a floating element
- Tapping shows a bottom sheet to choose 2 or 3 minutes
- Countdown timer displayed, with audio/vibration feedback when done

**Feature 3 — Weight increment fix:**
- Change [_changeWeight(i, -2.25)](file:///c:/Users/Admin/Desktop/gym_tracker/lib/screens/workout_day_screen.dart#34-41) → [_changeWeight(i, -2.5)](file:///c:/Users/Admin/Desktop/gym_tracker/lib/screens/workout_day_screen.dart#34-41)
- Change [_changeWeight(i, 2.25)](file:///c:/Users/Admin/Desktop/gym_tracker/lib/screens/workout_day_screen.dart#34-41) → [_changeWeight(i, 2.5)](file:///c:/Users/Admin/Desktop/gym_tracker/lib/screens/workout_day_screen.dart#34-41)

**Feature 7 — Sync across days:**
- [_changeWeight](file:///c:/Users/Admin/Desktop/gym_tracker/lib/screens/workout_day_screen.dart#34-41) and [_changeReps](file:///c:/Users/Admin/Desktop/gym_tracker/lib/screens/workout_day_screen.dart#42-48) now also call `syncExerciseAcrossDays`

**Feature 12 — Workout summary:**
- After [markDayDone()](file:///c:/Users/Admin/Desktop/gym_tracker/lib/services/workout_service.dart#122-135) succeeds, show a summary dialog/bottom sheet
- Lists each exercise with: `exerciseName: weight × reps (±delta from last session)`
- Green for improvement, red for regression, grey for same

### [MODIFY] [exercise_search_screen.dart](file:///c:/Users/Admin/Desktop/gym_tracker/lib/screens/exercise_search_screen.dart)

**Feature 1 — Re-add retains state:**
- When creating [ExerciseInstance](file:///c:/Users/Admin/Desktop/gym_tracker/lib/models/exercise_instance.dart#5-42), check for latest state via service
- Pre-fill weight/reps if exercise was previously used on any day

---

## Phase 6 — Rest Timer Widget

### [NEW] `lib/screens/rest_timer_screen.dart`
- Full-screen or bottom-sheet countdown timer
- User picks 2:00 or 3:00, countdown starts
- Circular progress indicator with time remaining
- Vibration when timer hits 0

---

## Verification Plan

### Build Verification
```
cd c:\Users\Admin\Desktop\gym_tracker
flutter analyze
```
Ensures no compilation or lint errors across all files.

### Manual Testing
Since this is a mobile UI-heavy app, the main verification is manual:

1. **Fresh install flow:** Uninstall/clear data → Open app → See splash logo → Username prompt → Enter name → See home screen with greeting
2. **Returning user flow:** Reopen app → Splash → Auto-skip to home with greeting
3. **Day title edit:** Tap edit icon on a day → Change title → Verify it saves and displays
4. **No lock restriction:** Tap any day (even day 5 before day 1 is done) → Should open
5. **Weight increment:** Go to an exercise → Tap + on weight → Verify it adds 2.5 not 2.3
6. **Rest timer:** Tap timer button → Choose 2 or 3 min → Timer counts down → Vibrates at 0
7. **Exercise re-add:** Add Bench Press → set to 185 lbs × 8 reps → Remove it → Add it back → Verify 185 × 8 retained
8. **Cross-day sync:** Add Bench Press to Day 1 and Day 5 → Update weight on Day 1 → Go to Day 5 → Verify weight updated
9. **Workout summary:** Complete a workout → Summary popup shows comparing to last session
10. **Week counter:** Complete all 7 days → Verify week count increments → Reset → Complete again

> [!IMPORTANT]
> Please review the plan, especially items 6 (removing locks) and 7 (cross-day sync). Removing locks means the user can do days in any order — and cross-day sync means *all* days with the same exercise share state. Please confirm this is what you want.
