# Project notes

## Redesign status

Reference: `design/dose_tracker_redesign.html` (no separate plan files exist).
Phase 2 assumed = move every screen onto the Phase 1 tokens and shared widgets.
Rule: design only, no logic, data flow or new features.

- [x] Phase 1: tokens, Readex Pro, shared widgets, nav bar, branding
- [x] Shared: progress ring widget (design `.ring`) replacing bars (P1)
- [x] Shared: list row + section header widgets (design `.row`, `.section-h`) (P1)
- [x] Home: collapsing header with date eyebrow + add icon button, ring cards (P1)
- [x] Schedule: collapsing header + progress ring, time slot styling (P1)
- [x] Inventory: collapsing header, AppSwitch, card layout per design (P1)
- [x] Settings: collapsing header, grouped row cards, danger log out (P1)
- [x] Profile detail: inner header with edit icon, ring avatar, All medications row (P2)
- [x] Profile medications: inner header, card with time chips (P2)
- [x] Medication form: inner header, segmented unit/meal, AppSwitch stock (P2)
- [x] Add / edit profile: inner header, avatar preview (P2)
- [x] Doctor's report: inner header, segmented period, ring overview (P2)
- [x] Sheets: language radio rows with hairlines and subtitle; refill sheet titled with the medication, profile and count left as subtitle, "Save stock"; dose time sheet with large time field, "Amount at this time", Done; notifications sheet uses AppSwitch (P3)
- [x] Auth, onboarding, splash: forgot password moved to the inner header; the rest already used the shared widgets (P3)
- [x] Profile medications: was still on the old AppBar and FAB; now inner header + GradientFab (P3)

## Next steps

- Added for the first version (were skipped in Phase 2): Home hero "Next" row, "Up next" list (3 soonest pending doses, opens Schedule), low-stock card (same rule as the cabinet, opens Cabinet); Delete medication in the edit form (`MedicationUpdatesRepository.deleteMedication`, reminders follow automatically); refill +10/+20/+30 buttons.
- Not added: the hero "1 missed" pill from the design.
- Dose time sheet keeps a number field instead of the design's +/- stepper, because amounts can be decimals (0.5).
- Refill sheet has no unit suffix: the stock unit is not stored, so "pills" could be wrong.
- Added the missing Arabic "Count after refill" label.
- Remaining: manual testing on a phone, committing, release signing key, and the delivery build.
- New shared widgets: progress_ring, section_header, pill_tile, time_chip, gradient_fab, sticky_cta, app_list_row (moved from settings_row).
