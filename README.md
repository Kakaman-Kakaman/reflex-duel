# Reflex Duel 🎯

A 2-player arcade shooting game built on the **Basys 3 FPGA** for the EE-172 / CS-130 / CE-222 Digital Logic and Design course (Spring 2026).

---

## Overview

Two players each have a **3×3 grid of LDR/LED pairs**. A random LED lights up on both grids simultaneously — whoever blocks their corresponding LDR first scores a point. Scores and reaction times are displayed live on a **VGA monitor**.

```
Player 1           FPGA (Basys 3)         Player 2
┌─────────┐       ┌──────────────┐       ┌─────────┐
│ 3×3 LDR │──────▶│  Game Logic  │◀──────│ 3×3 LDR │
│ array   │       │  FSM         │       │ array   │
└─────────┘       │              │       └─────────┘
                  │  VGA FSM     │──────▶ Monitor
                  │  Score Track │         (640×480)
                  └──────────────┘
```

---

## Team

| Name     | Role                        |
|----------|-----------------------------|
| [You]    | FPGA lead, Verilog, VGA     |
| Abbas    | Documentation & reports     |
| Nafay    | Hardware, LDR/LED circuits  |
| Daniyal  | Hardware, GPIO interfacing  |

---

## Hardware Requirements

- Basys 3 FPGA board (Artix-7)
- 2× 3×3 LDR (light-dependent resistor) arrays
- 2× 3×3 LED arrays (one LED per LDR pair)
- LM393 (or similar) voltage comparators — 9 per player
- VGA monitor with DB-15 cable
- Resistors, breadboard / protoboard, jumper wires
- 5V power supply for LED driver circuits

---

## Features

- 🎮 Random LED selection using an LFSR (Linear Feedback Shift Register)
- ⚡ Reaction time measurement in milliseconds (displayed on screen)
- 🏆 Live scoreboard on VGA (640×480 @ 60 Hz)
- 🔄 Deterministic FSM-based game state machine
- 7-segment display fallback for score

---

## Project Structure

```
reflex-duel/
├── src/                  # Verilog source files
│   ├── top.v             # Top-level module (board pin assignments)
│   ├── fsm_game_mode.v   # FSM 1: Game mode controller
│   ├── fsm_game_logic.v  # FSM 2: Core game logic (hit detection, LED select)
│   ├── vga_controller.v  # FSM 3: VGA sync + pixel renderer
│   ├── lfsr.v            # Pseudo-random LED selector
│   ├── reaction_timer.v  # Millisecond reaction time counter
│   └── score_tracker.v   # P1 / P2 score counters
├── constraints/
│   └── basys3.xdc        # Vivado pin constraints for Basys 3
├── sim/
│   └── tb_top.v          # Testbench for top-level simulation
├── hardware/
│   ├── schematics/       # LDR/LED comparator circuit diagrams
│   └── component-list.md # Bill of materials
├── docs/
│   ├── proposal/         # Milestone 1 deliverable
│   ├── progress-report/  # Milestone 2 deliverable
│   └── final-report/     # Milestone 3 deliverable
└── media/
    └── demo/             # Demo photos and video
```

---

## FSM Design

### FSM 1 — Game Mode Controller
```
IDLE ──(start)──▶ COUNTDOWN ──▶ PLAYING ──(max score)──▶ GAME_OVER
                                   │                         │
                                   └──(all rounds done)──────┘
```

### FSM 2 — Game Logic
```
WAIT_FOR_START ──▶ SELECT_LED ──▶ ARMED ──(hit detected)──▶ HIT_DETECTED ──▶ ROUND_DONE
                      ▲                                                            │
                      └────────────────────────────────────────────────────────────┘
```

### FSM 3 — VGA Controller
```
FRONT_PORCH ──▶ HSYNC ──▶ BACK_PORCH ──▶ ACTIVE_VIDEO ──┐
     ▲                                                    │
     └────────────────────────────────────────────────────┘
```

---

## Milestones

| Milestone | Due     | Status |
|-----------|---------|--------|
| M0: Team formation         | Week 6  | ✅ Done |
| M1: Project proposal       | Week 7  | 🔄 In progress |
| M2: Early prototype + report | Week 11 | ⏳ Upcoming |
| M3: Final demo + report    | TBA     | ⏳ Upcoming |

---

## Getting Started

### Prerequisites
- [Xilinx Vivado Webpack](https://www.xilinx.com/support/download.html) (free)
- Basys 3 board with USB cable

### Simulate
1. Open Vivado → Create project → Add sources from `src/`
2. Set `tb_top.v` as the simulation source
3. Run Behavioral Simulation

### Synthesize & Program
1. Add `constraints/basys3.xdc` to the project
2. Set `top.v` as the top module
3. Run Synthesis → Implementation → Generate Bitstream
4. Open Hardware Manager → Program Device

---

## VGA Display Layout

```
┌──────────────────────────────────────┐
│         REFLEX  DUEL                 │
│                                      │
│   PLAYER 1          PLAYER 2         │
│   ┌────────┐        ┌────────┐       │
│   │   5    │        │   3    │       │
│   └────────┘        └────────┘       │
│                                      │
│   Last reaction:    Last reaction:   │
│      142 ms            209 ms        │
│                                      │
│         Round: 4 / 10                │
└──────────────────────────────────────┘
```

---

## License

This project is developed for academic purposes as part of the DLD course at FAST-NUCES.
