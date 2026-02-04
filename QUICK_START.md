# Quick Start Guide

Get up and running with the TT-01E simulation in minutes!

## Prerequisites

✅ MATLAB R2020b or later  
✅ Simulink  
✅ Simscape  
✅ Simscape Multibody  

## Installation

```bash
# Clone the repository
git clone https://github.com/CO3-UPV/Tamiya-TT-01.git
cd Tamiya-TT-01
```

## Usage

### Option 1: Quick Test (Automated Model Creation)

```matlab
% Open MATLAB in the repository directory
cd scripts

% Initialize parameters
init_TT01E_params

% Create the Simulink model
create_model

% Run simulation
run_simulation
```

### Option 2: Manual Model Building

For more control over the model:

1. **Initialize parameters**
   ```matlab
   cd scripts
   init_TT01E_params
   ```

2. **Follow the detailed guide**
   - Open `documentation/building_guide.md`
   - Build the Simscape Multibody model step-by-step
   - Save as `models/TT01E_OpenLoop.slx`

3. **Run simulation**
   ```matlab
   run_simulation
   ```

## What You Get

After running the simulation, you'll see:

📊 **Plots**: Velocity, trajectory, steering, and throttle  
🎬 **Animation**: 3D vehicle motion (open Mechanics Explorer)  
💾 **Data**: Simulation results saved to workspace  

## Example Outputs

The simulation generates several plots:
- Vehicle velocity over time
- 2D trajectory (X-Y position)
- Steering angle input
- Throttle input

## Next Steps

### Modify Input Signals

Edit `scripts/init_TT01E_params.m`:

```matlab
% Change these lines:
params.input.time = [0 2 5 8 10];
params.input.throttle = [0 0.8 0.8 0.3 0];
params.input.steering = [0 0 0.5 0.5 0];
```

### Adjust Vehicle Parameters

Modify vehicle properties in `scripts/init_TT01E_params.m`:

```matlab
% Chassis mass
params.chassis.mass = 1.8;  % Heavier vehicle

% Spring rates
params.susp.front.spring_rate = 3000;  % Stiffer

% Gear ratio
params.drivetrain.motor_pinion = 21;  % Different gearing
```

### Run Parameter Sweeps

Study the effect of design changes:

```matlab
cd scripts
parameter_sweep
```

## Visualization

To view the 3D animation:

1. Run the simulation
2. In Simulink, go to: `Simulation > Mechanics Explorer`
3. Click the play button to animate

## Common Issues

### "Model not found" error
**Solution**: Run `create_model` first to generate the Simulink model.

### "License checkout failed"
**Solution**: Ensure you have the required toolboxes installed and licensed.

### Simulation is slow
**Solution**: 
- Increase step size in `params.sim.time_step` (e.g., 0.005)
- Reduce simulation time in `params.sim.stop_time`

### No visualization
**Solution**: 
- Add `Mechanism Configuration` block to your model
- Enable visualization in block parameters

## File Structure

```
Tamiya-TT-01/
├── README.md                    # Main documentation
├── QUICK_START.md              # This file
├── LICENSE                      # License information
├── CONTRIBUTING.md             # Contribution guidelines
├── .gitignore                  # Git ignore rules
│
├── documentation/
│   ├── model_documentation.md  # Detailed model docs
│   └── building_guide.md       # Step-by-step build guide
│
├── scripts/
│   ├── init_TT01E_params.m    # Initialize parameters ⭐
│   ├── create_model.m          # Create Simulink model ⭐
│   ├── run_simulation.m        # Run simulation ⭐
│   └── parameter_sweep.m       # Parameter analysis
│
├── models/
│   └── TT01E_OpenLoop.slx     # Simulink model (generated)
│
└── data/
    └── TT01E_params.mat        # Parameters (generated)
```

⭐ = Most important files to get started

## Learning Resources

### Documentation
- [Model Documentation](documentation/model_documentation.md) - Full technical details
- [Building Guide](documentation/building_guide.md) - Manual model construction
- [Contributing](CONTRIBUTING.md) - How to contribute

### MATLAB/Simulink
- [Simscape Multibody Documentation](https://www.mathworks.com/help/sm/)
- [Vehicle Dynamics Examples](https://www.mathworks.com/help/sdl/examples.html)
- [Simscape Tutorials](https://www.mathworks.com/support/learn-with-matlab-tutorials.html)

### Vehicle Dynamics
- "Race Car Vehicle Dynamics" by Milliken & Milliken
- "Fundamentals of Vehicle Dynamics" by Thomas D. Gillespie

## Support

Need help?

1. 📖 Check the [documentation](documentation/)
2. 🔍 Search [existing issues](https://github.com/CO3-UPV/Tamiya-TT-01/issues)
3. 💬 Open a [new issue](https://github.com/CO3-UPV/Tamiya-TT-01/issues/new)

## Tips

💡 **Start simple**: Use the automated `create_model` script first  
💡 **Test frequently**: Run simulation after each parameter change  
💡 **Save versions**: Use git to save working versions  
💡 **Read logs**: Check MATLAB command window for errors/warnings  
💡 **Visualize**: Use Mechanics Explorer to understand motion  

## What's Next?

Once you have the basic simulation running:

1. ✨ **Customize**: Adjust parameters to match your needs
2. 🎯 **Validate**: Compare with real vehicle data
3. 🎮 **Control**: Add closed-loop controllers
4. 📈 **Analyze**: Run parameter sweeps
5. 🤝 **Contribute**: Share improvements with the community

---

**Ready to simulate? Run these three commands:**

```matlab
init_TT01E_params
create_model
run_simulation
```

Happy simulating! 🚗💨
