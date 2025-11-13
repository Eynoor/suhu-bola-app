# MatchCard Widget - Visual Design Reference

## 📐 Layout Breakdown

### Complete Card Structure

```
┌─────────────────────────────────────────────────────────┐
│                   MATCH CARD CONTAINER                  │
│  • BorderRadius: 20px                                   │
│  • Glassmorphism: BackdropFilter blur(10, 10)          │
│  • Padding: 20px all sides                             │
│  • Margin: 12px horizontal, 8px vertical               │
│                                                         │
│  ┌────────────────────────────────────────────────────┐│
│  │           HOME TEAM | SCORE/TIME | AWAY TEAM       ││
│  │                                                    ││
│  │   Logo(56×56)  [Score Box]  Logo(56×56)          ││
│  │   Team Name    Width:100px   Team Name            ││
│  │   [HOME]       Height:Auto   [AWAY]               ││
│  │   (Badge)      BRadius:16px  (Badge)              ││
│  │                                                    ││
│  │   Spacing: 6px (logo to badge)                    ││
│  │   Spacing: 12px (between teams & score)           ││
│  │                                                    ││
│  └────────────────────────────────────────────────────┘│
│                                                         │
│                 SizedBox(height: 16)                    │
│                                                         │
│  ─────────────────────────────────────────────────────  │
│  (Gradient Divider: 1px height)                         │
│                                                         │
│                 SizedBox(height: 12)                    │
│                                                         │
│  ┌────────────────────────────────────────────────────┐│
│  │  Mon, 15 Nov 15:00          [MENDATANG / LIVE]     ││
│  │  (Expanded)                 (Container)             ││
│  │  Font: 12px w600            Padding: 14×6px        ││
│  │  Color: grey[300]           BRadius: 8px           ││
│  └────────────────────────────────────────────────────┘│
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## 🎨 Color Palette

### Status Colors

| Status    | Gradient Colors | Border Color | Text Color | Usage            |
| --------- | --------------- | ------------ | ---------- | ---------------- |
| SELESAI   | cyan(0.2→0.08)  | cyan(0.5)    | cyan       | Finished matches |
| LIVE      | red(0.25→0.1)   | red(0.7)     | red        | Active matches   |
| MENDATANG | blue(0.2→0.08)  | blue(0.5)    | blue       | Upcoming matches |

### Team Badges

| Badge | Gradient       | Border    | Text | Icon Color     |
| ----- | -------------- | --------- | ---- | -------------- |
| HOME  | cyan(0.3→0.15) | cyan(0.5) | cyan | Cyan primary   |
| AWAY  | blue(0.3→0.15) | blue(0.5) | blue | Blue secondary |

### Container Colors

- **Background Gradient**: white(0.04→0.02) normal, white(0.1→0.06) on hover
- **Logo Container**: primary(0.15→0.05) normal, primary(0.25→0.1) on hover
- **Score Box**: primary(0.1→0.05) normal, primary(0.3→0.2) on hover
- **Divider**: gradient primary(0.1→0.3→0.1)

---

## 🔤 Typography System

### Text Elements

#### Team Name

- **Font Size**: 13px
- **Weight**: w700
- **Letter Spacing**: 0.3px
- **Color**: Colors.white
- **Alignment**: Center
- **Max Lines**: 2
- **Overflow**: Ellipsis
- **Line Height**: 1.3

#### Date & Time Display

- **Font Size**: 12px
- **Weight**: w600
- **Letter Spacing**: 0.3px
- **Color**: grey[300]
- **Alignment**: Left
- **Format**: `EEE, dd MMM HH:mm`
- **Example**: `Mon, 15 Nov 15:00`

#### Score/Time Display

- **Font Size**: 22px (normal), 18px (LIVE)
- **Weight**: w900
- **Letter Spacing**: 0.5px
- **Color**: Depends on status (white/cyan/red)
- **Alignment**: Center
- **Shadow**: Glow effect on hover

#### Status Badge Text

- **Font Size**: 11px
- **Weight**: w800
- **Letter Spacing**: 0.6px
- **Color**: Depends on status (cyan/blue/red)
- **Alignment**: Center

#### Badge Labels (HOME/AWAY)

- **Font Size**: 10px
- **Weight**: w800
- **Letter Spacing**: 0.5px
- **Color**: Cyan (HOME) or Blue (AWAY)
- **Alignment**: Center

---

## 🎬 Animation & Interactions

### Hover Effects

```
Normal State                    Hovered State
┌──────────────────────┐       ┌──────────────────────┐
│ Regular containers   │       │ Lifted containers    │
│ Subtle shadows       │  ──>  │ Enhanced shadows     │
│ Normal gradients     │       │ Brighter gradients   │
│ Static position      │       │ Transform: Y -4px    │
└──────────────────────┘       └──────────────────────┘
```

### Logo Container Animation

- **Duration**: 300ms
- **On Hover**:
  - Gradient: More intense (opacity +0.1)
  - Border: Brighter (opacity +0.3)
  - Shadow: Larger blur (8px → 16px), spread +2
  - Width/Height: 56px → 56px (no size change)

### Score Box Animation

- **Duration**: 300ms
- **On Hover**:
  - Gradient: More intense (opacity +0.2)
  - Border: Brighter (opacity +0.2)
  - Shadow: Appears (12px blur)
  - Text Shadow: Glow effect (8px blur)

### Card Container Animation

- **Duration**: 300ms
- **On Hover**:
  - Transform: translateY(-4px) - lifts up
  - Background: Slightly brighter
  - Border: More visible
  - Shadow: Larger and more intense

### Live Dot Animation

```
         ┌─────┐
         │  ●  │  Red glowing indicator
         │     │  6×6px circle
         └─────┘
    Shadow: blur 6px, spread 1px
    Color: #ef4444 with opacity
```

---

## 📱 Responsive Sizing

### Fixed Dimensions

- **Logo Container**: 56×56px
- **Live Dot**: 6×6px
- **Divider Height**: 1px
- **Card Border Radius**: 20px
- **Status Badge Border Radius**: 8px
- **Logo Border Radius**: 14px

### Adaptive Dimensions

- **Card Width**: Full available width - 24px margin
- **Team Display**: Expanded (flex) - flexible width
- **Score Box**: Fixed 100px width
- **Date Section**: Expanded (flex) - takes remaining space

### Spacing System

| Element              | Spacing                |
| -------------------- | ---------------------- |
| Card Padding         | 20px                   |
| Card Margin          | 12px (h), 8px (v)      |
| Logo to Badge        | 6px (SizedBox height)  |
| Badge to Divider     | 16px (SizedBox height) |
| Divider to Date      | 12px (SizedBox height) |
| Badge Padding        | 10×3px (h/v)           |
| Status Badge Padding | 14×6px (h/v)           |
| Score Box Padding    | 16×12px (h/v)          |

---

## 🔄 Status State Display

### MENDATANG (Upcoming)

```
┌─────────────┐
│   15:00     │  ← Time only
│             │
└─────────────┘
[MENDATANG]    ← Blue badge
```

### LIVE (In Progress)

```
┌─────────────┐
│    LIVE     │  ← Red text, 18px
│    ●        │  ← Red pulsing dot
└─────────────┘
[LIVE]         ← Red badge
```

### SELESAI (Finished)

```
┌─────────────┐
│   2 - 1     │  ← Score, cyan text
│             │
└─────────────┘
[SELESAI]      ← Cyan badge
```

---

## 📐 Logo Container Details

### Container Styling

```
┌─────────────────────┐
│  BorderRadius: 14px │
│  Size: 56×56px      │
│  Padding: 8px       │
│  Border: 2px        │
│                     │
│  ┌───────────────┐  │
│  │   LOGO IMAGE  │  │ ← 40×40px actual image
│  │               │  │    fit: BoxFit.contain
│  └───────────────┘  │
│                     │
└─────────────────────┘
```

### Gradient

- **Normal**: primary(0.15 → 0.05)
- **Hover**: primary(0.25 → 0.1)
- **Direction**: topLeft → bottomRight

### Border

- **Normal**: primary(0.3 opacity), 2px
- **Hover**: primary(0.6 opacity), 2px
- **Color**: Dynamic based on hover

---

## 🔗 Team Badge Styling

### HOME Badge

```
┌──────────────┐
│    HOME      │  ← 10px text, cyan
│              │  ← Padding: 10×3px
└──────────────┘  ← Border: 1px cyan(0.5)
                  ← BRadius: 6px
Gradient: cyan(0.3 → 0.15)
```

### AWAY Badge

```
┌──────────────┐
│    AWAY      │  ← 10px text, blue
│              │  ← Padding: 10×3px
└──────────────┘  ← Border: 1px blue(0.5)
                  ← BRadius: 6px
Gradient: blue(0.3 → 0.15)
```

---

## 📅 Date Format Examples

### Input Processing

```
MatchModel:
  date: "2025-11-15"
  time: "15:00"

Processing:
  Parse → DateTime(2025, 11, 15, 15, 0)
  Format → DateFormat('EEE, dd MMM HH:mm')
  Output → "Mon, 15 Nov 15:00"
```

### Display Examples

| Date       | Time  | Display           |
| ---------- | ----- | ----------------- |
| 2025-11-10 | 19:00 | Mon, 10 Nov 19:00 |
| 2025-11-15 | 14:30 | Sat, 15 Nov 14:30 |
| 2025-11-22 | 20:00 | Sat, 22 Nov 20:00 |
| 2025-11-23 | 15:00 | Sun, 23 Nov 15:00 |
| 2025-12-01 | 12:00 | Mon, 01 Dec 12:00 |

---

## ✅ Quality Checklist

- ✅ HOME/AWAY badges visible and properly styled
- ✅ Date displays day name (EEE format)
- ✅ Time shown in HH:mm format
- ✅ LIVE status with red indicator dot
- ✅ Status badges (SELESAI/LIVE/MENDATANG)
- ✅ Proper spacing and layout
- ✅ Hover animations working
- ✅ Color consistency across states
- ✅ Zero compile errors
- ✅ Applied across all screens

---

**Last Updated**: November 13, 2025
**Status**: ✨ Production Ready
