%% Run TT-01E Simscape Multibody Simulation
% This script initializes parameters and runs the open-loop simulation
% of the Tamiya TT-01E touring car.
%
% Author: Auto-generated
% Date: 2026-02-04

%% Initialize
clear all;
close all;
clc;

%% Add paths
addpath(genpath('scripts'));
addpath(genpath('models'));
addpath(genpath('data'));

%% Load vehicle parameters
fprintf('Loading TT-01E vehicle parameters...\n');
init_TT01E_params;

%% Check if model exists
model_name = 'TT01E_OpenLoop';
if exist(['models/' model_name '.slx'], 'file') ~= 4
    warning('Simulink model %s.slx not found in models/ directory.', model_name);
    fprintf('Please create the Simscape Multibody model first.\n');
    return;
end

%% Open the model (optional - comment out if running in batch mode)
fprintf('Opening Simulink model...\n');
open_system(['models/' model_name]);

%% Configure simulation parameters
fprintf('Configuring simulation...\n');
set_param(model_name, 'StopTime', num2str(params.sim.stop_time));
set_param(model_name, 'FixedStep', num2str(params.sim.time_step));
set_param(model_name, 'Solver', params.sim.solver);

%% Run simulation
fprintf('Running simulation for %.1f seconds...\n', params.sim.stop_time);
simOut = sim(model_name);

%% Plot results (if available)
fprintf('Simulation complete!\n');
fprintf('Post-processing results...\n');

% Create figure for results
figure('Name', 'TT-01E Simulation Results', 'Position', [100 100 1200 800]);

% Note: The actual plotting code depends on the signals logged in the model
% This is a template that should be updated based on the actual model outputs

% Try to extract common signals
try
    % Velocity
    subplot(3,2,1);
    if exist('simOut', 'var') && isfield(simOut, 'velocity')
        plot(simOut.velocity.Time, simOut.velocity.Data);
        xlabel('Time [s]');
        ylabel('Velocity [m/s]');
        title('Vehicle Velocity');
        grid on;
    else
        text(0.5, 0.5, 'Velocity data not available', 'HorizontalAlignment', 'center');
    end
    
    % Position
    subplot(3,2,2);
    if exist('simOut', 'var') && isfield(simOut, 'position')
        plot(simOut.position.Data(:,1), simOut.position.Data(:,2));
        xlabel('X Position [m]');
        ylabel('Y Position [m]');
        title('Vehicle Trajectory');
        grid on;
        axis equal;
    else
        text(0.5, 0.5, 'Position data not available', 'HorizontalAlignment', 'center');
    end
    
    % Wheel speeds
    subplot(3,2,3);
    text(0.5, 0.5, 'Configure wheel speed logging in model', 'HorizontalAlignment', 'center');
    title('Wheel Speeds');
    
    % Motor current
    subplot(3,2,4);
    text(0.5, 0.5, 'Configure motor current logging in model', 'HorizontalAlignment', 'center');
    title('Motor Current');
    
    % Steering angle
    subplot(3,2,5);
    if exist('simOut', 'var') && isfield(simOut, 'steering')
        plot(simOut.steering.Time, simOut.steering.Data);
        xlabel('Time [s]');
        ylabel('Steering Angle [deg]');
        title('Steering Input');
        grid on;
    else
        plot(params.input.time, params.input.steering * params.input.steering_ratio);
        xlabel('Time [s]');
        ylabel('Steering Angle [deg]');
        title('Steering Input (Commanded)');
        grid on;
    end
    
    % Throttle
    subplot(3,2,6);
    plot(params.input.time, params.input.throttle * 100);
    xlabel('Time [s]');
    ylabel('Throttle [%]');
    title('Throttle Input');
    grid on;
    ylim([0 105]);
    
catch ME
    fprintf('Warning: Could not plot all results.\n');
    fprintf('Error: %s\n', ME.message);
    fprintf('Update the plotting section based on your model outputs.\n');
end

fprintf('Done!\n');
