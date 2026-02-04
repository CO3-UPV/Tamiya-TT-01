# Tamiya TT-01E Simscape Multibody Model Documentation

## Overview

This document describes the Simscape Multibody open-loop simulation model for the Tamiya TT-01E touring car chassis. The model provides a realistic multi-body dynamics simulation of the vehicle, including chassis, suspension, drivetrain, and tires.

## Model Architecture

### Main Components

1. **Chassis/Body**
   - Rigid body representing the main chassis
   - Mass: ~1.5 kg (including battery and electronics)
   - Includes realistic inertia properties
   - Center of gravity positioned appropriately for a touring car

2. **Suspension System**
   - Front: Double wishbone suspension
   - Rear: Double wishbone suspension
   - Configurable spring rates and damping
   - Adjustable camber, caster, and toe angles

3. **Wheels and Tires**
   - Four wheels with realistic inertia
   - Tire radius: 30.5mm (61mm diameter)
   - Contact force model for ground interaction
   - Friction model (static and kinetic)

4. **Drivetrain**
   - Electric motor (540-size brushed motor)
   - Two-stage gear reduction:
     * First stage: Motor pinion (23T) to spur gear (72T)
     * Second stage: Final drive (3.73:1)
     * Overall ratio: ~11.6:1
   - Ball differential for rear axle
   - Driveshafts with torsional compliance

5. **Steering System**
   - Rack and pinion steering (simplified)
   - Steering ratio: 15:1
   - Input range: -1 (full left) to +1 (full right)

## Vehicle Parameters

### Dimensions
- Wheelbase: 257 mm
- Track width: 168 mm (front and rear)
- Overall length: 440 mm
- Overall width: 200 mm

### Mass Properties
- Total mass: ~1.5 kg
- Roll inertia (Ixx): 0.015 kg⋅m²
- Pitch inertia (Iyy): 0.030 kg⋅m²
- Yaw inertia (Izz): 0.035 kg⋅m²

### Suspension
- Front spring rate: 2500 N/m
- Rear spring rate: 2800 N/m
- Damping: 80-90 N⋅s/m
- Travel: ±25 mm

### Motor
- Torque constant: 0.012 N⋅m/A
- Resistance: 0.05 Ω
- Maximum voltage: 7.2 V (6-cell NiMH)

## Simulation Setup

### Prerequisites
- MATLAB R2020b or later
- Simulink
- Simscape
- Simscape Multibody

### File Structure
```
Tamiya-TT-01/
├── README.md
├── documentation/
│   └── model_documentation.md (this file)
├── models/
│   └── TT01E_OpenLoop.slx (Simulink model)
├── scripts/
│   ├── init_TT01E_params.m (parameter initialization)
│   ├── create_model.m (model builder script)
│   └── run_simulation.m (simulation runner)
└── data/
    └── TT01E_params.mat (saved parameters)
```

### Running the Simulation

1. **Initialize Parameters**
   ```matlab
   cd scripts
   init_TT01E_params
   ```

2. **Create Model (First Time Only)**
   ```matlab
   create_model
   ```
   Note: This creates a basic model template. You'll need to add detailed
   Simscape Multibody components manually or using the Simscape Multibody Link
   plugin with CAD data.

3. **Run Simulation**
   ```matlab
   run_simulation
   ```

### Input Signals

The open-loop simulation accepts two input signals:

1. **Throttle** (0 to 1)
   - 0 = No throttle (coasting)
   - 1 = Full throttle
   - Negative values for braking (if implemented)

2. **Steering** (-1 to 1)
   - -1 = Full left turn
   - 0 = Straight
   - +1 = Full right turn

Default input profiles are defined in `init_TT01E_params.m`:
- Acceleration phase (0-1s): Throttle ramps to 50%
- Constant speed (1-2s): Throttle held at 50%
- Turn initiation (2-3s): Steering input applied while maintaining throttle
- Deceleration (3-10s): Reduced throttle

## Model Details

### Coordinate System
- X-axis: Forward (vehicle longitudinal)
- Y-axis: Left (vehicle lateral)
- Z-axis: Up (vertical)
- Origin: Ground plane at initial position

### Solver Configuration
- Solver: Fixed-step ODE4 (Runge-Kutta)
- Step size: 1 ms (0.001 s)
- Simulation time: 10 seconds (configurable)

### Visualization
The model includes Simscape Multibody visualization:
- 3D animation of vehicle motion
- Ground plane
- Wheel rotation visualization
- Optional trajectory traces

To view animation:
1. Run simulation
2. Open Mechanics Explorer: `View > Mechanics Explorer`
3. Play animation

## Extending the Model

### Adding Closed-Loop Control
To convert to closed-loop control:
1. Add sensor blocks for:
   - Wheel speeds (encoders)
   - Vehicle velocity
   - Yaw rate (gyroscope)
   - Steering angle (potentiometer)
2. Implement control algorithms:
   - Throttle controller (e.g., cruise control)
   - Traction control
   - Electronic stability control
3. Replace open-loop inputs with controller outputs

### Adding More Realistic Components
1. **Detailed Chassis Geometry**
   - Import CAD model using Simscape Multibody Link
   - Add battery pack as separate body
   - Include detailed weight distribution

2. **Advanced Tire Model**
   - Pacejka Magic Formula tire model
   - Temperature-dependent friction
   - Combined slip forces

3. **Detailed Drivetrain**
   - Multi-body motor model
   - Gear backlash and compliance
   - Differential with locking characteristics
   - Transmission losses

4. **Aerodynamics**
   - Drag force proportional to velocity squared
   - Adjustable rear wing for downforce
   - Side force in crosswinds

## Validation

### Expected Behavior
1. **Acceleration**: Vehicle should accelerate smoothly when throttle applied
2. **Turning**: Vehicle should turn in response to steering input
3. **Stability**: No unrealistic oscillations or instabilities
4. **Physical Limits**: Results should be within realistic bounds for a 1/10 scale RC car

### Performance Metrics
- Top speed: ~8-12 m/s (depending on gearing and battery)
- 0-5 m/s acceleration: ~1-2 seconds
- Turning radius: ~1-2 meters at moderate speed

## References

1. Tamiya TT-01E Product Manual
2. MathWorks Simscape Multibody Documentation
3. MATLAB Vehicle Dynamics Blockset Examples
4. "Race Car Vehicle Dynamics" by Milliken & Milliken
5. "Fundamentals of Vehicle Dynamics" by Thomas D. Gillespie

## Troubleshooting

### Common Issues

**Problem**: Model won't open
- Solution: Ensure all Simscape products are installed
- Check MATLAB version compatibility

**Problem**: Simulation runs but no visualization
- Solution: Open Mechanics Explorer manually
- Check that World Frame and Mechanism Configuration blocks are present

**Problem**: Vehicle behaves unrealistically
- Solution: Check parameter values in `init_TT01E_params.m`
- Verify units (SI units used throughout)
- Check tire-ground contact force settings

**Problem**: Simulation is too slow
- Solution: Increase fixed step size (with caution)
- Simplify tire contact model
- Reduce visualization detail

## Version History

- v1.0 (2026-02-04): Initial model creation
  - Basic vehicle structure
  - Open-loop simulation capability
  - Default parameter set

## License

This model is provided as-is for educational and research purposes.

## Contact

For questions or contributions, please open an issue on the GitHub repository.
