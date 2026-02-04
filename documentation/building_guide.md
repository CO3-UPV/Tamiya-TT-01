# TT-01E Model Building Guide

This guide provides step-by-step instructions for manually building the Simscape Multibody model of the Tamiya TT-01E.

## Prerequisites

Before starting, ensure you have:
- MATLAB R2020b or later installed
- Simscape Multibody license
- Basic familiarity with Simulink and Simscape

## Model Building Steps

### Step 1: Create New Model

1. Open MATLAB
2. Run: `create_model` to generate the basic template
3. Or manually:
   - Type `simulink` in command window
   - Click "Blank Model"
   - Save as `models/TT01E_OpenLoop.slx`

### Step 2: Add Configuration Blocks

These blocks are required for any Simscape Multibody model:

1. **World Frame** (`sm3dlib/Frames and Transforms/World Frame`)
   - Defines the global reference frame
   - Set gravity to -9.81 m/s² in Z direction

2. **Mechanism Configuration** (`sm3dlib/Utilities/Mechanism Configuration`)
   - Configure solver settings
   - Enable visualization

3. **Solver Configuration** (`nesl_utility/Solver Configuration`)
   - Configure Simscape solver
   - Use local solver for better performance

### Step 3: Build Chassis Subsystem

Create a subsystem called "Chassis":

1. **Add Solid Block** (`sm3dlib/Body Elements/Solid`)
   - Geometry: Block (380mm × 190mm × 50mm)
   - Mass: 1.5 kg
   - Inertia: Calculate from parameters

2. **Add Transform** (`sm3dlib/Frames and Transforms/Rigid Transform`)
   - Position chassis at correct height (CoG height)
   - Rotate if needed

3. **Connect to World Frame**
   - Use joints to allow motion
   - 6-DOF Joint for free motion

### Step 4: Build Wheel and Tire Subsystem

Create subsystem "Wheel_Tire" (will be used 4 times):

1. **Wheel Solid**
   - Geometry: Cylinder (radius 30.5mm, width 26mm)
   - Mass: 0.05 kg
   - Inertia: As specified

2. **Tire Force Block**
   - Use `sm3dlib/Forces and Torques/Spatial Contact Force`
   - Or create custom tire force using MATLAB Function
   - Parameters: stiffness, damping, friction coefficients

3. **Revolute Joint**
   - Connect wheel to suspension
   - Allow rotation around wheel axis

### Step 5: Build Suspension Subsystem

Create "Front_Suspension" and "Rear_Suspension":

1. **Upper Wishbone**
   - Rigid bodies for control arms
   - Revolute joints at chassis mounts
   - Ball joints at upright

2. **Lower Wishbone**
   - Similar to upper wishbone
   - Different geometry

3. **Spring-Damper**
   - `sm3dlib/Forces and Torques/Spring and Damper Force`
   - Spring constant from parameters
   - Damping coefficient from parameters

4. **Wheel Upright**
   - Connects to wheel hub
   - Mounts to suspension links

### Step 6: Build Drivetrain Subsystem

Create "Drivetrain" subsystem:

1. **DC Motor**
   - Use `sps/Electrical/Electrical Elements/DC Motor`
   - Or create custom block with motor equations
   - Parameters from init script

2. **Gearbox**
   - `sm3dlib/Gears and Couplings/Common Gear Constraint`
   - First stage: 23:72 ratio
   - Second stage: 3.73:1

3. **Differential**
   - Create using two Common Gear Constraints
   - Or use planetary gear for more realism
   - Efficiency: 0.95

4. **Driveshafts**
   - Revolute joints with rotational damping
   - Connect motor to wheels

### Step 7: Build Steering Subsystem

Create "Steering" subsystem:

1. **Steering Rack**
   - Prismatic joint (linear motion)
   - Input from steering signal

2. **Tie Rods**
   - Rigid bodies connecting rack to uprights
   - Ball joints at each end

3. **Steering Ratio**
   - Gain block to convert input to rack displacement
   - Ratio: 15:1

### Step 8: Add Ground Plane

1. **Ground Solid**
   - Infinite plane or large box
   - Fixed to world frame
   - Friction properties

2. **Contact Forces**
   - Between each tire and ground
   - Use Spatial Contact Force block
   - Set friction model parameters

### Step 9: Create Input Interface

1. **Throttle Input**
   - From Workspace block
   - Variable: `[params.input.time', params.input.throttle']`
   - Convert to voltage for motor

2. **Steering Input**
   - From Workspace block  
   - Variable: `[params.input.time', params.input.steering']`
   - Convert to rack displacement

### Step 10: Add Sensors and Outputs

1. **Transform Sensor** (`sm3dlib/Sensing/Transform Sensor`)
   - Measure chassis position and velocity
   - Connect to Scope

2. **Joint Sensor** (`sm3dlib/Sensing/Joint Sensor`)
   - Measure wheel speeds
   - Measure suspension travel

3. **Scopes and Displays**
   - Add scope blocks for key signals
   - Configure logging to workspace

### Step 11: Configure Model Settings

1. **Solver Configuration**
   - Fixed-step: ode4
   - Step size: 0.001 s
   - Stop time: 10 s

2. **Data Logging**
   - Enable signal logging
   - Save format: Dataset

3. **Visualization**
   - Enable Mechanics Explorer
   - Add visual geometries to bodies
   - Set colors and transparency

### Step 12: Initialize and Test

1. **Run Init Script**
   ```matlab
   init_TT01E_params
   ```

2. **Open Model**
   ```matlab
   open_system('models/TT01E_OpenLoop')
   ```

3. **Run Simulation**
   ```matlab
   sim('TT01E_OpenLoop')
   ```

4. **View Animation**
   - Open Mechanics Explorer
   - Play animation
   - Adjust camera view

## Simplified Alternative

For a quicker start, create a simplified model:

1. **Single Body Model**
   - One rigid body for entire vehicle
   - Point mass wheels (no suspension detail)
   - Simple tire forces

2. **Bicycle Model**
   - Two wheels instead of four
   - Simplified steering
   - Faster simulation

3. **Gradually Add Detail**
   - Start simple, add complexity incrementally
   - Test after each addition
   - Compare results with expectations

## Common Blocks Used

### Simscape Multibody Library
- `sm3dlib/Body Elements/Solid`
- `sm3dlib/Joints/Revolute Joint`
- `sm3dlib/Joints/Prismatic Joint`
- `sm3dlib/Joints/6-DOF Joint`
- `sm3dlib/Forces and Torques/Spring and Damper Force`
- `sm3dlib/Forces and Torques/Spatial Contact Force`
- `sm3dlib/Sensing/Transform Sensor`
- `sm3dlib/Sensing/Joint Sensor`

### Simulink Standard Library
- `simulink/Sources/From Workspace`
- `simulink/Sinks/Scope`
- `simulink/Sinks/To Workspace`
- `simulink/Math Operations/Gain`

### Simscape Utilities
- `nesl_utility/Simulink-PS Converter`
- `nesl_utility/PS-Simulink Converter`
- `nesl_utility/Solver Configuration`

## Tips and Best Practices

1. **Start Simple**: Build incrementally, test frequently
2. **Use Subsystems**: Organize model hierarchically
3. **Consistent Units**: Always use SI units (m, kg, s)
4. **Parameter Files**: Use init script for all parameters
5. **Version Control**: Save versions before major changes
6. **Documentation**: Add comments and descriptions to blocks
7. **Visualization**: Add geometries for better understanding
8. **Validation**: Compare results with known behavior

## Troubleshooting

### Model Won't Simulate
- Check all blocks are connected properly
- Verify Simscape connection lines (solid lines)
- Ensure Solver Configuration is present
- Check for algebraic loops

### Unrealistic Behavior  
- Verify parameter values and units
- Check initial conditions
- Inspect contact force settings
- Review constraint configurations

### Slow Simulation
- Increase step size (carefully)
- Simplify contact models
- Reduce number of bodies
- Use local solver

## Next Steps

After building the basic model:

1. **Tune Parameters**: Adjust to match real vehicle behavior
2. **Validate**: Compare with test data if available
3. **Add Sensors**: Implement realistic sensor models
4. **Add Controllers**: Convert to closed-loop control
5. **Optimize**: Improve simulation speed
6. **Document**: Update model documentation

## Resources

- [Simscape Multibody User's Guide](https://www.mathworks.com/help/sm/)
- [Modeling Mechanical Systems](https://www.mathworks.com/help/sm/modeling-mechanical-systems.html)
- [Vehicle Dynamics Examples](https://www.mathworks.com/help/sdl/examples.html)

## Getting Help

If you encounter issues:
1. Check MATLAB documentation
2. Review model_documentation.md
3. Open an issue on GitHub
4. Contact the development team
