# Tamiya TT-01E - Simscape Multibody Simulation

Open-loop simulation of the Tamiya TT-01E touring car using MATLAB Simscape Multibody.

## Overview

This project provides a detailed multi-body dynamics simulation of the Tamiya TT-01E 1/10 scale electric touring car chassis. The simulation is built using MATLAB's Simscape Multibody toolbox and includes:

- **Realistic vehicle dynamics**: Chassis, suspension, drivetrain, and tire models
- **Open-loop control**: Direct throttle and steering inputs
- **3D visualization**: Animated vehicle motion in Mechanics Explorer
- **Configurable parameters**: Easy adjustment of vehicle properties

## Features

- ✅ Complete 1/10 scale vehicle model (257mm wheelbase)
- ✅ Double wishbone suspension (front and rear)
- ✅ Electric drivetrain with two-stage gear reduction
- ✅ Realistic tire-ground contact forces
- ✅ Parameterized design for easy modifications
- ✅ Ready-to-run example simulations

## Requirements

- MATLAB R2020b or later
- Simulink
- Simscape
- Simscape Multibody

## Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/CO3-UPV/Tamiya-TT-01.git
   cd Tamiya-TT-01
   ```

2. **Initialize parameters in MATLAB**
   ```matlab
   cd scripts
   init_TT01E_params
   ```

3. **Create the Simulink model** (first time only)
   ```matlab
   create_model
   ```

4. **Run the simulation**
   ```matlab
   run_simulation
   ```

## Repository Structure

```
Tamiya-TT-01/
├── README.md                          # This file
├── documentation/
│   └── model_documentation.md         # Detailed model documentation
├── models/
│   └── TT01E_OpenLoop.slx            # Simulink/Simscape model (generated)
├── scripts/
│   ├── init_TT01E_params.m           # Vehicle parameter initialization
│   ├── create_model.m                 # Model builder script
│   └── run_simulation.m               # Simulation runner and plotting
└── data/
    └── TT01E_params.mat               # Saved parameters (generated)
```

## Model Parameters

The vehicle model includes realistic parameters based on the TT-01E specifications:

### Physical Dimensions
- **Wheelbase**: 257 mm
- **Track Width**: 168 mm
- **Total Mass**: ~1.5 kg (with battery)

### Drivetrain
- **Motor**: 540-size brushed motor
- **Gear Ratio**: 11.6:1 (23T pinion, 72T spur, 3.73:1 final drive)
- **Differential**: Ball differential (rear-wheel drive)

### Suspension
- **Type**: Double wishbone (front and rear)
- **Spring Rate**: 2500 N/m (front), 2800 N/m (rear)
- **Travel**: ±25 mm

All parameters can be modified in `scripts/init_TT01E_params.m`.

## Usage Examples

### Basic Simulation
```matlab
% Run with default parameters
cd scripts
run_simulation
```

### Custom Input Signals
```matlab
% Modify throttle and steering profiles
params.input.time = [0 2 5 8 10];
params.input.throttle = [0 0.8 0.8 0.3 0];
params.input.steering = [0 0 0.5 0.5 0];
save('data/TT01E_params.mat', 'params');
run_simulation
```

### Adjust Vehicle Parameters
```matlab
% Modify chassis mass
params.chassis.mass = 1.8;  % heavier vehicle

% Modify suspension stiffness
params.susp.front.spring_rate = 3000;  % stiffer springs

% Save and run
save('data/TT01E_params.mat', 'params');
run_simulation
```

## Simulation Outputs

The simulation provides:
- Vehicle velocity over time
- 2D trajectory (X-Y position)
- Wheel speeds
- Motor current
- Steering angle
- Throttle position
- 3D animation in Mechanics Explorer

## Extending the Model

### Convert to Closed-Loop Control
Add feedback control by:
1. Implementing velocity/position controllers
2. Adding sensor models
3. Replacing open-loop inputs with controller outputs

See `documentation/model_documentation.md` for details.

### Import CAD Geometry
Use Simscape Multibody Link to import:
- Detailed chassis geometry
- Suspension components
- Wheel assemblies

### Advanced Tire Models
Implement more sophisticated tire models:
- Pacejka Magic Formula
- Temperature-dependent friction
- Combined slip forces

## Documentation

For detailed information about the model architecture, parameters, and usage:
- See [Model Documentation](documentation/model_documentation.md)

## Contributing

Contributions are welcome! Areas for improvement:
- More detailed drivetrain model
- Advanced tire models
- Aerodynamic forces
- Battery and electrical system modeling
- Control algorithms

## License

This project is provided for educational and research purposes.

## References

- [Tamiya TT-01E Product Page](https://www.tamiya.com/english/products/58664tt01type-e/index.htm)
- [MathWorks Simscape Multibody Documentation](https://www.mathworks.com/help/sm/)
- [Vehicle Dynamics Theory](https://www.mathworks.com/solutions/automotive/vehicle-dynamics.html)

## Acknowledgments

- Tamiya Inc. for the TT-01E chassis design
- MathWorks for Simscape Multibody toolbox

---

**Note**: This is a simulation model for educational purposes. The TT-01E trademark belongs to Tamiya Inc.
