# Troubleshooting Guide

Common issues and solutions for the TT-01E Simscape Multibody simulation.

## Installation Issues

### Problem: "Product not found" or "License checkout failed"

**Cause**: Required MATLAB toolboxes not installed or licensed.

**Solution**:
```matlab
% Check installed toolboxes
ver

% Look for:
% - MATLAB
% - Simulink
% - Simscape
% - Simscape Multibody
```

If missing, install through MATLAB Add-On Manager or contact your license administrator.

### Problem: Scripts not found when running

**Cause**: Not running from correct directory.

**Solution**:
```matlab
% Navigate to repository root
cd /path/to/Tamiya-TT-01

% Or add paths
addpath(genpath('scripts'));
addpath(genpath('models'));
```

## Model Creation Issues

### Problem: `create_model` fails with "Undefined function or variable"

**Cause**: Simscape Multibody blocks not available.

**Solution**:
1. Verify Simscape Multibody is installed: `ver`
2. Try manually adding a block from library browser
3. Check MATLAB version (R2020b+ required)

**Workaround**:
Manually create model using Simulink and add blocks from library browser.

### Problem: "Cannot add block" error

**Cause**: Block library path may have changed in newer MATLAB versions.

**Solution**:
1. Open Simulink Library Browser
2. Locate the block manually
3. Update path in `create_model.m`

Example paths:
```matlab
% If block not found, try alternative paths:
% Old: 'sm3dlib/Body Elements/Solid'
% New: 'sm/Body Elements/Solid'
```

### Problem: Model created but appears empty

**Cause**: Script completed but blocks not connected.

**Solution**:
The `create_model.m` creates a basic template. You need to:
1. Open the model: `open_system('models/TT01E_OpenLoop')`
2. Follow `documentation/building_guide.md` to add details
3. Or manually connect the generated blocks

## Simulation Issues

### Problem: "Model not found" when running simulation

**Cause**: Simulink model file doesn't exist.

**Solution**:
```matlab
% Create the model first
create_model

% Verify it exists
dir('models/*.slx')
```

### Problem: Simulation fails with "Dimension mismatch" error

**Cause**: Input signal dimensions don't match expected format.

**Solution**:
Check input format in `init_TT01E_params.m`:
```matlab
% Inputs must be [time, value] arrays
params.input.time = [0 1 2 3 10];      % 1×5
params.input.throttle = [0 0.5 0.5 0.3 0.3];  % 1×5
% Both must have same length!
```

### Problem: "Algebraic loop" error

**Cause**: Circular dependency in Simscape model.

**Solution**:
1. Check model for circular connections
2. Add appropriate initial conditions
3. Use "Algebraic Constraint" block if needed
4. Review Simscape connection topology

### Problem: Simulation runs but produces NaN or Inf

**Cause**: 
- Numerical instability
- Invalid parameter values
- Division by zero

**Solution**:
```matlab
% Check parameters for zeros or very small values
params.chassis.mass = 1.5;  % Must be > 0
params.wheel.mass = 0.050;   % Must be > 0
params.tire.stiffness = 15000; % Must be > 0

% Check for reasonable inertia values
params.chassis.Ixx > 0
params.chassis.Iyy > 0
params.chassis.Izz > 0
```

### Problem: Simulation is extremely slow

**Causes & Solutions**:

**1. Step size too small**
```matlab
% Increase step size (with caution)
params.sim.time_step = 0.005;  % Instead of 0.001
```

**2. Stiff dynamics**
```matlab
% Try variable-step solver
params.sim.solver = 'ode23t';  % Stiff solver
% Remove FixedStep parameter
```

**3. Complex contact forces**
- Simplify tire model
- Reduce contact model fidelity
- Use lookup tables instead of calculations

**4. Too many logged signals**
- Reduce number of scopes
- Disable unnecessary signal logging

### Problem: "Failed to evaluate InitFcn" error

**Cause**: Error in model initialization function.

**Solution**:
```matlab
% Run initialization script manually to see error
init_TT01E_params

% Check if params structure is created
whos params
```

## Visualization Issues

### Problem: No 3D animation shown

**Cause**: Mechanics Explorer not opened.

**Solution**:
1. Run simulation first
2. Go to: `Simulation > Mechanics Explorer`
3. Or: `View > Mechanics Explorer`
4. Press play button to animate

### Problem: Mechanics Explorer shows nothing

**Cause**: Missing configuration blocks.

**Solution**:
Ensure model has:
- World Frame block
- Mechanism Configuration block
- At least one Solid block with geometry

### Problem: Animation is choppy

**Cause**: 
- Large simulation step size
- Too many frames to render

**Solution**:
```matlab
% Reduce step size
params.sim.time_step = 0.001;

% Or increase playback speed in Mechanics Explorer
```

## Parameter Issues

### Problem: Parameters not loading

**Cause**: MAT file not created or corrupted.

**Solution**:
```matlab
% Regenerate parameters
cd scripts
init_TT01E_params

% Verify file exists
ls ../data/TT01E_params.mat

% Load and inspect
load('../data/TT01E_params.mat')
params
```

### Problem: Changes to parameters have no effect

**Cause**: 
- Parameters not saved
- Model using cached values

**Solution**:
```matlab
% After editing init_TT01E_params.m:
clear all  % Clear workspace
init_TT01E_params  % Reload
% Then run simulation again
```

Or:
```matlab
% Save parameters after modification
save('data/TT01E_params.mat', 'params');
```

### Problem: Unrealistic behavior

**Cause**: Parameter values incorrect or inconsistent.

**Solution**:
Check key parameters:

```matlab
% Mass should be reasonable
params.chassis.mass  % ~1.5 kg for 1/10 scale

% Wheel radius should match scale
params.wheel.radius  % ~0.030 m (30mm)

% Gear ratio should be reasonable
params.drivetrain.overall_ratio  % ~10-15:1

% Spring rates should support weight
F = params.chassis.mass * params.g;  % Weight [N]
deflection = F / params.susp.front.spring_rate;  % Should be reasonable
```

## Data Output Issues

### Problem: No plots generated

**Cause**: 
- Simulation outputs not configured
- Signals not logged

**Solution**:
1. Check that simulation completed successfully
2. Verify `simOut` exists in workspace
3. Update `run_simulation.m` to match your model's logged signals

### Problem: "Field not found" when plotting

**Cause**: Expected signal name doesn't match logged signal.

**Solution**:
```matlab
% Check what's actually in simOut
simOut

% List logged signals
simOut.who

% Update plotting code to use correct names
```

## Platform-Specific Issues

### Windows

**Problem**: Path separators cause issues

**Solution**:
Use `fullfile()` function:
```matlab
model_path = fullfile('models', 'TT01E_OpenLoop.slx');
```

### macOS

**Problem**: Case sensitivity in filenames

**Solution**:
Ensure exact case matches:
- `TT01E_OpenLoop.slx` not `tt01e_openloop.slx`

### Linux

**Problem**: Display issues with Mechanics Explorer

**Solution**:
```matlab
% Try software rendering
opengl('software')
% Then restart MATLAB
```

## Advanced Debugging

### Enable verbose output

```matlab
% In run_simulation.m, use SimulationInput
simin = Simulink.SimulationInput(model_name);
simin = simin.setModelParameter('StopTime', '10');
simin = simin.setModelParameter('SimulationMode', 'normal');
out = sim(simin);
```

### Check model consistency

```matlab
% Open model
open_system('models/TT01E_OpenLoop');

% Run model advisor
modeladvisor('models/TT01E_OpenLoop');

% Update diagram
Simulink.BlockDiagram.updateModel('models/TT01E_OpenLoop');
```

### Debug Simscape issues

```matlab
% Enable Simscape logging
set_param(model_name, 'SimscapeLogType', 'all');
set_param(model_name, 'SimscapeLogToSDI', 'on');

% Run simulation
sim(model_name);

% View logs in Simulation Data Inspector
Simulink.sdi.view
```

### Profile simulation performance

```matlab
% Enable profiling
profile on

% Run simulation
run_simulation

% View results
profile viewer
```

## Getting Help

### Before asking for help, collect this information:

1. **MATLAB version**: `ver`
2. **Installed toolboxes**: `ver`
3. **Error message**: Full text including stack trace
4. **What you tried**: Steps taken before error
5. **Expected vs actual**: What should happen vs what happens

### Where to get help:

1. **Documentation**: 
   - Check `documentation/` folder
   - Review MATLAB help: `doc simscape`

2. **Examples**:
   - MATLAB Vehicle Dynamics examples
   - Simscape Multibody examples

3. **Community**:
   - GitHub Issues (this repository)
   - MATLAB Answers forum
   - Stack Overflow (tag: matlab, simscape)

4. **Official Support**:
   - MathWorks Support (if you have license)
   - MathWorks documentation

## Common Error Messages

### "The model 'TT01E_OpenLoop' does not exist"
→ Run `create_model` first

### "Unable to load parameters"
→ Run `init_TT01E_params` first

### "Block diagram contains errors"
→ Check model connections, use `Ctrl+D` to update

### "Simulation failed to converge"
→ Check solver settings, reduce step size, check parameters

### "Out of memory"
→ Reduce simulation time, increase step size, close other apps

### "Invalid dimension for signal"
→ Check input signal dimensions in parameters

### "License checkout failed"
→ Check license, restart MATLAB, contact admin

## Still Having Issues?

1. **Reset to defaults**:
   ```bash
   git checkout scripts/init_TT01E_params.m
   ```

2. **Start fresh**:
   ```matlab
   clear all
   close all
   clc
   cd scripts
   init_TT01E_params
   create_model
   ```

3. **Minimal test**:
   ```matlab
   % Create simplest possible model
   new_system('test_model');
   add_block('sm3dlib/Frames and Transforms/World Frame', 'test_model/World');
   save_system('test_model', 'test_model.slx');
   open_system('test_model');
   ```

4. **Report bug**:
   - Open GitHub issue
   - Include error details
   - Describe steps to reproduce
   - Mention MATLAB version

---

**Remember**: Most issues are due to:
- Missing initialization (`init_TT01E_params`)
- Missing model file (run `create_model`)
- Incorrect directory (must be in repository root)
- Parameter errors (check values and units)

**Quick checklist**:
- [ ] MATLAB R2020b or later
- [ ] Simscape Multibody installed
- [ ] In correct directory
- [ ] Ran `init_TT01E_params`
- [ ] Ran `create_model` (first time)
- [ ] Parameters are valid (no zeros, NaN, or Inf)
