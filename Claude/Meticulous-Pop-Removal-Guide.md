# Meticulous Pop Removal Guide
## Soft Close Boilerplate for Meticulous Profiles

Adds a pressure/flow bleed stage at the end of your profile to prevent the **vacuum snap** (loud pop) that occurs when the piston retracts against residual pressure after a hard weight cutoff.

---

## How It Works

When your final extraction stage exits on `weight`, the piston retracts immediately - regardless of how much pressure is still in the group. If pressure is above ~2 bar at that moment, the rapid depressurization creates a vacuum cavity that collapses with an audible snap or pop.

Soft Close bleeds pressure or flow to near-zero over a few seconds *before* the piston lifts. To wire it in:

1. **Remove the `weight` exit trigger from your final extraction stage** (or move it to Soft Close)
2. **Add Soft Close as the last stage** - it holds the weight exit and lets the shot end gracefully

---

## Variant A - Pressure-Controlled Close
*Use after pressure-controlled extraction stages (lever profiles, adaptive espresso)*

```json
{
  "name": "Soft Close",
  "key": "soft_close",
  "type": "pressure",
  "dynamics": {
    "over": "time",
    "interpolation": "linear",
    "points": [
      [0, 3.0],
      [6, 0.5]
    ]
  },
  "exit_triggers": [
    {
      "type": "weight",
      "value": "$weight_YourYieldVariable",
      "relative": false,
      "comparison": ">="
    },
    {
      "type": "time",
      "value": 6,
      "relative": true,
      "comparison": ">="
    }
  ],
  "limits": [
    {
      "type": "flow",
      "value": 3.0
    }
  ]
}
```

**Tune the starting pressure** to match where your profile typically is when yield is hit:

| Profile type | Recommended start | Duration |
|---|---|---|
| High peak (9 - 10 bar), short decline | 4.0 - 5.0 bar | 6 - 8 s |
| Medium peak (7 - 9 bar), long decline | 2.0 - 3.0 bar | 5 - 6 s |
| Soft spring / low peak (4 - 6 bar) | 1.0 - 1.5 bar | 4 - 5 s |
| Already near floor (1 - 2 bar) | 1.0 bar | 3 - 4 s |

---

## Variant B - Flow-Controlled Close
*Use after flow-controlled extraction stages (allongé, turbo, constant-flow profiles)*

```json
{
  "name": "Soft Close",
  "key": "soft_close",
  "type": "flow",
  "dynamics": {
    "over": "time",
    "interpolation": "linear",
    "points": [
      [0, 4.5],
      [5, 0.5]
    ]
  },
  "exit_triggers": [
    {
      "type": "weight",
      "value": "$weight_YourYieldVariable",
      "relative": false,
      "comparison": ">="
    },
    {
      "type": "time",
      "value": 5,
      "relative": true,
      "comparison": ">="
    }
  ],
  "limits": [
    {
      "type": "pressure",
      "value": "$pressure_YourPressureLimitVariable"
    }
  ]
}
```

**Set the starting flow** to match your extraction flow rate, and keep the pressure limit the same as your extraction stage:

| Extraction flow | Start point | End point | Duration |
|---|---|---|---|
| 4.0 - 5.0 ml/s (allongé) | 4.5 ml/s | 0.5 ml/s | 5 s |
| 2.0 - 3.0 ml/s (standard) | 3.0 ml/s | 0.5 ml/s | 4 s |
| 1.5 - 2.0 ml/s (slow/Italian) | 2.0 ml/s | 0.3 ml/s | 4 s |

---

## Variant C - Minimal (3-second pressure drop)
*Lightweight version for simple profiles or when you just want a quick bleed*

```json
{
  "name": "Soft Close",
  "key": "soft_close",
  "type": "pressure",
  "dynamics": {
    "over": "time",
    "interpolation": "linear",
    "points": [
      [0, 2.0],
      [3, 0.0]
    ]
  },
  "exit_triggers": [
    {
      "type": "weight",
      "value": "$weight_YourYieldVariable",
      "relative": false,
      "comparison": ">="
    },
    {
      "type": "time",
      "value": 3,
      "relative": true,
      "comparison": ">="
    }
  ],
  "limits": [
    {
      "type": "flow",
      "value": 2.0
    }
  ]
}
```

---

## Bonus: Flow Runaway Exit

Add this to your final **extraction stage** (not Soft Close) to catch a collapsing puck before it gushes. If flow climbs above your threshold, the stage exits early into Soft Close regardless of weight:

```json
{
  "type": "flow",
  "value": 4.0,
  "relative": false,
  "comparison": ">="
}
```

Tune the threshold to ~1.5× your normal locked/extraction flow:

| Extraction type | Runaway threshold |
|---|---|
| Espresso (1.5 - 2.5 ml/s) | 3.5 - 4.0 ml/s |
| Adaptive locked (2.0 - 3.5 ml/s) | 4.0 - 5.0 ml/s |
| Allongé (4.0 - 5.0 ml/s) | 6.0 - 7.0 ml/s |

---

## Before / After - Stage Wiring

**Before (hard cutoff):**
```
Extraction Stage
  exit_triggers:
    - weight >= $weight_Yield    ← shot ends hard here at full pressure
    - time >= 30 (safety)
```

**After (soft close):**
```
Extraction Stage
  exit_triggers:
    - time >= 30 (safety only)
    - flow >= 4.0 (runaway safety)   ← no weight exit here anymore

Soft Close
  exit_triggers:
    - weight >= $weight_Yield    ← weight exit moves here
    - time >= 6 (safety)
```

---

## Notes

- The `time` safety exit on Soft Close ensures the stage always terminates even if the scale hasn't registered yield yet (rare but possible with slow scale response)
- The flow limit on pressure-type Soft Close prevents the pump from over-driving during the bleed; keep it at or below your extraction flow
- Starting pressure of `0.0` is valid but may cause a brief re-pressurization artifact on some machines - `0.3 - 0.5` is a safer floor
- Soft Close adds ~3 - 8 s to total shot time depending on variant - account for this in your timing expectations
