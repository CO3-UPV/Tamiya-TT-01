# TT-01E Vehicle Architecture

This document provides visual representations of the Tamiya TT-01E architecture and simulation structure.

## Vehicle Layout (Top View)

```
                    Front
                      ↑
         ╔═══════════════════════╗
         ║    ⊙           ⊙     ║  ← Front wheels
         ║    │           │     ║
         ║  ┌─┴───────────┴─┐   ║
         ║  │   Chassis     │   ║  ← Main chassis
         ║  │   & Battery   │   ║
         ║  │      CoG      │   ║
         ║  └─┬───────────┬─┘   ║
         ║    │           │     ║
         ║    ⊙           ⊙     ║  ← Rear wheels (driven)
         ╚═══════════════════════╝
                      
    Left ←─────────────────→ Right
    
    Legend:
    ⊙ = Wheels
    CoG = Center of Gravity
```

## Vehicle Layout (Side View)

```
              Antenna
                 │
    ┌────────────┼────────────┐
    │     Body Shell          │
    └───────────────────────┬─┘
                           ╱
                    ┌─────╱
                    │ CoG
         ┌──────────┴──────────┐
         │      Chassis        │
        ╱│                     │╲
      ╱  └─────────────────────┘ ╲
    ═╧═                          ═╧═
    Front                       Rear
    Wheel                       Wheel
    
    Ground ═══════════════════════════
```

## Drivetrain Schematic

```
  ┌─────────┐
  │  Motor  │
  │ (540)   │
  └────┬────┘
       │ Pinion (23T)
       ↓
  ┌────⊙────┐
  │ Spur    │  72T
  │ Gear    │
  └────┬────┘
       │
       ↓
  ┌────⊙────┐
  │  Final  │  3.73:1
  │  Drive  │
  └────┬────┘
       │
       ↓
  ┌────⊙────┐
  │  Ball   │
  │  Diff   │
  └──┬───┬──┘
     │   │
     ↓   ↓
    LR   RR  (Left/Right Rear wheels)
    
  Total Ratio: ~11.6:1
```

## Suspension System (Front - One Side)

```
    Chassis Mount
         │
         ⊙ ← Upper ball joint
        ╱│╲
       ╱ │ ╲ Upper A-arm
      ╱  │  ╲
     ⊙   │   ⊙
         │
      ╔══╧══╗
      ║  │  ║ ← Upright
      ║  │  ║
      ║  ⊙  ║ ← Wheel hub
      ╚═════╝
         │
     ⊙   │   ⊙
      ╲  │  ╱
       ╲ │ ╱ Lower A-arm
        ╲│╱
         ⊙ ← Lower ball joint
         │
    Chassis Mount
    
    Spring/Damper ║
                  ║
                 ═╧═
```

## Steering System

```
    Steering Input
         │
         ↓
    ┌────────┐
    │Servo   │
    │Motor   │
    └───┬────┘
        │
        ↓
    ┌───⊙────┐
    │Steering│
    │ Rack   │ ←→ (Linear motion)
    └─┬───┬──┘
      │   │
      │   │ Tie Rods
      ↓   ↓
     LF   RF  (Left/Right Front wheels)
```

## Coordinate System

```
         Z (Up)
         │
         │
         │
         └──────── Y (Left)
        ╱
       ╱
      ╱
     X (Forward)
     
  Origin: Ground plane at vehicle center
```

## Simulation Data Flow

```
┌─────────────────────────────────────────────┐
│          Input Signals                      │
│  ┌──────────┐        ┌──────────┐          │
│  │Throttle  │        │Steering  │          │
│  │ (0-1)    │        │ (-1 to 1)│          │
│  └────┬─────┘        └────┬─────┘          │
└───────┼───────────────────┼─────────────────┘
        │                   │
        ↓                   ↓
┌───────────────────────────────────────────────┐
│         Vehicle Model (Simscape)              │
│  ┌─────────────────────────────────────────┐ │
│  │  ┌──────────┐    ┌──────────┐          │ │
│  │  │Drivetrain│    │Steering  │          │ │
│  │  └────┬─────┘    └────┬─────┘          │ │
│  │       │               │                 │ │
│  │       ↓               ↓                 │ │
│  │  ┌─────────────────────────┐           │ │
│  │  │      Chassis Body       │           │ │
│  │  │  (Mass, Inertia, CoG)   │           │ │
│  │  └─────┬─────────────┬─────┘           │ │
│  │        │             │                  │ │
│  │        ↓             ↓                  │ │
│  │  ┌─────────┐   ┌─────────┐             │ │
│  │  │  Front  │   │  Rear   │             │ │
│  │  │  Susp.  │   │  Susp.  │             │ │
│  │  └────┬────┘   └────┬────┘             │ │
│  │       │             │                   │ │
│  │       ↓             ↓                   │ │
│  │  ┌────────────────────────┐            │ │
│  │  │    Wheels & Tires      │            │ │
│  │  │   (Contact Forces)     │            │ │
│  │  └──────────┬─────────────┘            │ │
│  │             │                           │ │
│  │             ↓                           │ │
│  │      Ground Contact                    │ │
│  └─────────────────────────────────────────┘ │
└───────┬───────────────────────────────────────┘
        │
        ↓
┌─────────────────────────────────────────────┐
│            Output Signals                    │
│  • Position (x, y, z)                       │
│  • Velocity (vx, vy, vz)                    │
│  • Orientation (roll, pitch, yaw)           │
│  • Wheel speeds                             │
│  • Motor current                            │
│  • Suspension travel                        │
│  • Contact forces                           │
└─────────────────────────────────────────────┘
```

## Model Hierarchy

```
TT01E_OpenLoop.slx
│
├── Configuration
│   ├── World Frame
│   ├── Mechanism Configuration
│   └── Solver Configuration
│
├── Inputs
│   ├── Throttle Input (From Workspace)
│   └── Steering Input (From Workspace)
│
├── Vehicle
│   ├── Chassis
│   │   └── Solid Body (mass, inertia, geometry)
│   │
│   ├── Front Suspension (x2)
│   │   ├── Upper A-arm
│   │   ├── Lower A-arm
│   │   ├── Spring-Damper
│   │   ├── Upright
│   │   └── Wheel & Tire
│   │
│   ├── Rear Suspension (x2)
│   │   ├── Upper A-arm
│   │   ├── Lower A-arm
│   │   ├── Spring-Damper
│   │   ├── Upright
│   │   └── Wheel & Tire
│   │
│   ├── Drivetrain
│   │   ├── Motor
│   │   ├── First Gear Stage (23:72)
│   │   ├── Final Drive (3.73:1)
│   │   ├── Differential
│   │   └── Driveshafts
│   │
│   └── Steering
│       ├── Rack (prismatic joint)
│       └── Tie Rods
│
└── Outputs
    ├── Sensors
    │   ├── Position Sensor
    │   ├── Velocity Sensor
    │   ├── Wheel Speed Sensors
    │   └── Joint Sensors
    │
    └── Visualization
        ├── Scopes
        ├── XY Graph
        └── Mechanics Explorer
```

## Parameter Flow

```
init_TT01E_params.m
        │
        ↓
   params struct
        │
        ↓
TT01E_params.mat ──→ MATLAB Workspace
        │                   │
        │                   ↓
        │          Simulink Model
        │           (references params)
        │                   │
        │                   ↓
        └──────────→  Simulation
                           │
                           ↓
                      Results
                     (simOut)
                           │
                           ↓
                    run_simulation.m
                    (plotting & analysis)
```

## Key Components Detail

### Chassis Inertia Tensor

```
    ┌              ┘
    │ Ixx   0    0  │  Roll inertia
I = │  0   Iyy   0  │  Pitch inertia
    │  0    0   Izz │  Yaw inertia
    └              ┘
    
Ixx = 0.015 kg⋅m²  (Roll around X-axis)
Iyy = 0.030 kg⋅m²  (Pitch around Y-axis)
Izz = 0.035 kg⋅m²  (Yaw around Z-axis)
```

### Tire Contact Model

```
    Normal Force (Fz)
         ↑
         │
    ┌────┴────┐
    │  Tire   │
    └────┬────┘
         │
    ─────┴───── Ground
    ←───→
  Friction Forces (Fx, Fy)
  
Fz = k_tire × deflection + c_tire × velocity
Fx = μ × Fz (longitudinal)
Fy = μ × Fz (lateral)
```

## Dimensions (mm)

```
┌─────────────────────────────────────────────┐
│                                             │
│     168                                     │
│   ←─────→                                   │
│   ●     ●                                   │
│   │     │                                   │
│   │ 257 │                                   │ 200
│   │  ↕  │                                   │ ↕
│   │     │                                   │
│   ●     ●                                   │
│                                             │
│←───────────────440────────────────────────→│
│                                             │
└─────────────────────────────────────────────┘

Wheelbase: 257 mm
Track width: 168 mm
Overall length: 440 mm
Overall width: 200 mm
Height: 130 mm
Wheel diameter: 61 mm
```

## Notes

- All diagrams are ASCII representations for quick reference
- See documentation for detailed component specifications
- Coordinate system follows right-hand rule
- Simscape uses SI units throughout (m, kg, s, N, etc.)
- Double wishbone suspension on all four corners
- Rear-wheel drive configuration
- Open differential (no limited-slip)

---

For interactive 3D visualization, run the simulation and open Mechanics Explorer in Simulink.
