%% Create TT-01E Simscape Multibody Model
% This script programmatically creates a Simulink/Simscape Multibody model
% for the Tamiya TT-01E open-loop simulation.
%
% Author: Auto-generated
% Date: 2026-02-04
%
% Requirements:
% - MATLAB R2020b or later
% - Simulink
% - Simscape
% - Simscape Multibody

function create_TT01E_model()

%% Initialize
close_system('TT01E_OpenLoop', 0);
model_name = 'TT01E_OpenLoop';

%% Create new model
fprintf('Creating new Simulink model: %s\n', model_name);
new_system(model_name);
open_system(model_name);

%% Configure model settings
fprintf('Configuring model parameters...\n');
set_param(model_name, 'Solver', 'ode4');
set_param(model_name, 'FixedStep', '0.001');
set_param(model_name, 'StopTime', '10');
set_param(model_name, 'SaveFormat', 'Dataset');

% Enable Simscape
set_param(model_name, 'PostLoadFcn', 'init_TT01E_params;');

%% Add main subsystems
fprintf('Adding main subsystems...\n');

% Simscape Multibody Configuration
add_block('sm3dlib/Frames and Transforms/World Frame', ...
    [model_name '/World Frame']);
set_param([model_name '/World Frame'], 'Position', [50, 50, 100, 100]);

% Mechanism Configuration
add_block('sm3dlib/Utilities/Mechanism Configuration', ...
    [model_name '/Mechanism Configuration']);
set_param([model_name '/Mechanism Configuration'], 'Position', [50, 150, 150, 200]);

% Solver Configuration
add_block('nesl_utility/Solver Configuration', ...
    [model_name '/Solver Configuration']);
set_param([model_name '/Solver Configuration'], 'Position', [50, 250, 150, 300]);

%% Add vehicle subsystem
add_block('built-in/Subsystem', [model_name '/Vehicle']);
set_param([model_name '/Vehicle'], 'Position', [300, 100, 400, 200]);

% Populate Vehicle subsystem
vehicle_sys = [model_name '/Vehicle'];
Simulink.SubSystem.deleteContents(vehicle_sys);

% Add Simscape connection ports
add_block('nesl_utility/Simulink-PS Converter', [vehicle_sys '/Throttle_PS']);
add_block('nesl_utility/Simulink-PS Converter', [vehicle_sys '/Steering_PS']);
add_block('nesl_utility/PS-Simulink Converter', [vehicle_sys '/Velocity_SL']);
add_block('nesl_utility/PS-Simulink Converter', [vehicle_sys '/Position_SL']);

% Add input ports
add_block('built-in/Inport', [vehicle_sys '/Throttle']);
add_block('built-in/Inport', [vehicle_sys '/Steering']);

% Add output ports
add_block('built-in/Outport', [vehicle_sys '/Velocity']);
add_block('built-in/Outport', [vehicle_sys '/Position']);

% Add chassis body
add_block('sm3dlib/Body Elements/Solid', [vehicle_sys '/Chassis']);

%% Add input signals
fprintf('Adding input signals...\n');

% Throttle input
add_block('simulink/Sources/From Workspace', [model_name '/Throttle Input']);
set_param([model_name '/Throttle Input'], 'Position', [50, 350, 150, 380]);
set_param([model_name '/Throttle Input'], 'VariableName', '[params.input.time'', params.input.throttle'']');
set_param([model_name '/Throttle Input'], 'OutputAfterFinalValue', 'Extrapolation');

% Steering input
add_block('simulink/Sources/From Workspace', [model_name '/Steering Input']);
set_param([model_name '/Steering Input'], 'Position', [50, 400, 150, 430]);
set_param([model_name '/Steering Input'], 'VariableName', '[params.input.time'', params.input.steering'']');
set_param([model_name '/Steering Input'], 'OutputAfterFinalValue', 'Extrapolation');

%% Add output scopes
fprintf('Adding output displays...\n');

% Velocity scope
add_block('simulink/Sinks/Scope', [model_name '/Velocity Scope']);
set_param([model_name '/Velocity Scope'], 'Position', [500, 100, 530, 130]);

% Position XY Graph
add_block('simulink/Sinks/XY Graph', [model_name '/Position Plot']);
set_param([model_name '/Position Plot'], 'Position', [500, 150, 530, 180]);

%% Add data logging
fprintf('Adding data logging...\n');

% Create signals to log
add_block('built-in/Terminator', [model_name '/Terminator1']);
add_block('built-in/Terminator', [model_name '/Terminator2']);

%% Connect blocks (basic connections)
fprintf('Connecting blocks...\n');
try
    add_line(model_name, 'Throttle Input/1', 'Vehicle/1');
    add_line(model_name, 'Steering Input/1', 'Vehicle/2');
    add_line(model_name, 'Vehicle/1', 'Velocity Scope/1');
catch
    fprintf('Note: Some connections may need manual adjustment.\n');
end

%% Arrange model layout
fprintf('Arranging model layout...\n');
Simulink.BlockDiagram.arrangeSystem(model_name);

%% Save model
model_path = fullfile('models', [model_name '.slx']);
fprintf('Saving model to: %s\n', model_path);

% Create models directory if it doesn't exist
if ~exist('models', 'dir')
    mkdir('models');
end

save_system(model_name, model_path);
fprintf('Model saved successfully.\n');

%% Add model documentation
fprintf('Model creation complete!\n');
fprintf('\n');
fprintf('NEXT STEPS:\n');
fprintf('1. Open the model: open_system(''%s'')\n', model_path);
fprintf('2. Add detailed Simscape Multibody components for:\n');
fprintf('   - Chassis body with proper inertia and geometry\n');
fprintf('   - Suspension system (front and rear)\n');
fprintf('   - Wheels and tires with contact forces\n');
fprintf('   - Drivetrain (motor, gearbox, differential, axles)\n');
fprintf('   - Steering mechanism\n');
fprintf('3. Configure visualization in Mechanics Explorer\n');
fprintf('4. Run the simulation using run_simulation.m\n');
fprintf('\n');

end
