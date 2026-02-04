%% Parameter Sweep Example for TT-01E
% This script demonstrates how to run multiple simulations with different
% parameter values to study the effect of various design choices.
%
% Author: Auto-generated
% Date: 2026-02-04

%% Initialize
clear all;
close all;
clc;

fprintf('TT-01E Parameter Sweep Analysis\n');
fprintf('================================\n\n');

%% Load base parameters
init_TT01E_params;
base_params = params;

%% Check if model exists
model_name = 'TT01E_OpenLoop';
if exist(['models/' model_name '.slx'], 'file') ~= 4
    warning('Simulink model %s.slx not found.', model_name);
    fprintf('Please create the model first using create_model.m\n');
    return;
end

%% Example 1: Sweep Spring Stiffness
fprintf('Example 1: Spring Stiffness Sweep\n');
fprintf('----------------------------------\n');

% Define spring stiffness values to test
spring_rates = [2000, 2500, 3000, 3500, 4000]; % N/m
n_configs = length(spring_rates);

% Preallocate results
results.spring_rate = spring_rates;
results.max_velocity = zeros(1, n_configs);
results.settling_time = zeros(1, n_configs);

% Run simulations
for i = 1:n_configs
    fprintf('Testing spring rate: %.0f N/m ... ', spring_rates(i));
    
    % Update parameters
    params = base_params;
    params.susp.front.spring_rate = spring_rates(i);
    params.susp.rear.spring_rate = spring_rates(i) * 1.1; % Keep 10% stiffer rear
    
    % Save parameters
    save('data/TT01E_params.mat', 'params');
    
    % Run simulation (suppress output)
    try
        simOut = sim(model_name, 'StopTime', num2str(params.sim.stop_time));
        
        % Extract results (adjust based on your model outputs)
        % This is example code - modify based on actual logged signals
        if isfield(simOut, 'velocity')
            results.max_velocity(i) = max(simOut.velocity.Data);
        else
            results.max_velocity(i) = NaN;
        end
        
        fprintf('Done\n');
    catch ME
        fprintf('Failed: %s\n', ME.message);
        results.max_velocity(i) = NaN;
    end
end

% Plot results
figure('Name', 'Spring Stiffness Analysis', 'Position', [100 100 800 600]);
subplot(2,1,1);
plot(spring_rates, results.max_velocity, 'o-', 'LineWidth', 2);
xlabel('Spring Rate [N/m]');
ylabel('Max Velocity [m/s]');
title('Effect of Spring Stiffness on Maximum Velocity');
grid on;

%% Example 2: Sweep Gear Ratio
fprintf('\nExample 2: Gear Ratio Sweep\n');
fprintf('---------------------------\n');

% Define gear ratios to test (motor pinion teeth)
pinion_teeth = [19, 21, 23, 25, 27];
n_configs = length(pinion_teeth);

% Preallocate
results.pinion = pinion_teeth;
results.top_speed = zeros(1, n_configs);
results.acceleration = zeros(1, n_configs);

for i = 1:n_configs
    fprintf('Testing pinion: %d teeth ... ', pinion_teeth(i));
    
    % Update parameters
    params = base_params;
    params.drivetrain.motor_pinion = pinion_teeth(i);
    params.drivetrain.overall_ratio = ...
        (params.drivetrain.spur_gear / params.drivetrain.motor_pinion) * ...
        params.drivetrain.final_drive;
    
    save('data/TT01E_params.mat', 'params');
    
    % Run simulation
    try
        simOut = sim(model_name, 'StopTime', '5'); % Shorter sim
        
        % Extract results
        if isfield(simOut, 'velocity')
            vel_data = simOut.velocity.Data;
            results.top_speed(i) = max(vel_data);
            
            % Calculate 0-3 m/s acceleration time
            idx = find(vel_data >= 3, 1, 'first');
            if ~isempty(idx)
                results.acceleration(i) = simOut.velocity.Time(idx);
            else
                results.acceleration(i) = NaN;
            end
        end
        
        fprintf('Done\n');
    catch ME
        fprintf('Failed: %s\n', ME.message);
    end
end

% Plot results
figure('Name', 'Gear Ratio Analysis', 'Position', [200 100 1000 600]);

subplot(1,2,1);
yyaxis left
plot(pinion_teeth, results.top_speed, 'o-', 'LineWidth', 2);
ylabel('Top Speed [m/s]');
yyaxis right
plot(pinion_teeth, results.acceleration, 's-', 'LineWidth', 2);
ylabel('0-3 m/s Time [s]');
xlabel('Motor Pinion Teeth');
title('Effect of Gear Ratio');
grid on;
legend('Top Speed', 'Acceleration Time', 'Location', 'best');

subplot(1,2,2);
overall_ratios = (72 ./ pinion_teeth) * 3.73;
plot(overall_ratios, results.top_speed, 'o-', 'LineWidth', 2);
xlabel('Overall Gear Ratio');
ylabel('Top Speed [m/s]');
title('Gear Ratio vs Top Speed');
grid on;
set(gca, 'XDir', 'reverse'); % Higher ratio = lower number

%% Example 3: Sweep Vehicle Mass
fprintf('\nExample 3: Mass Sweep\n');
fprintf('---------------------\n');

masses = [1.2, 1.35, 1.5, 1.65, 1.8]; % kg
n_configs = length(masses);

results.mass = masses;
results.accel_time = zeros(1, n_configs);
results.braking_dist = zeros(1, n_configs);

for i = 1:n_configs
    fprintf('Testing mass: %.2f kg ... ', masses(i));
    
    params = base_params;
    params.chassis.mass = masses(i);
    % Scale inertia with mass (approximate)
    scale = masses(i) / base_params.chassis.mass;
    params.chassis.Ixx = base_params.chassis.Ixx * scale;
    params.chassis.Iyy = base_params.chassis.Iyy * scale;
    params.chassis.Izz = base_params.chassis.Izz * scale;
    
    save('data/TT01E_params.mat', 'params');
    
    try
        simOut = sim(model_name, 'StopTime', '5');
        
        if isfield(simOut, 'velocity')
            vel = simOut.velocity.Data;
            time = simOut.velocity.Time;
            
            % Find 0-5 m/s time
            idx = find(vel >= 5, 1, 'first');
            if ~isempty(idx)
                results.accel_time(i) = time(idx);
            end
        end
        
        fprintf('Done\n');
    catch ME
        fprintf('Failed: %s\n', ME.message);
    end
end

% Plot mass effect
figure('Name', 'Mass Analysis', 'Position', [300 100 800 600]);
plot(masses, results.accel_time, 'o-', 'LineWidth', 2);
xlabel('Vehicle Mass [kg]');
ylabel('0-5 m/s Acceleration Time [s]');
title('Effect of Vehicle Mass on Acceleration');
grid on;

%% Restore original parameters
params = base_params;
save('data/TT01E_params.mat', 'params');
fprintf('\nOriginal parameters restored.\n');

%% Summary
fprintf('\n================================\n');
fprintf('Parameter Sweep Analysis Complete\n');
fprintf('================================\n');
fprintf('\nGenerated %d figures with results.\n', get(gcf, 'Number'));
fprintf('Modify this script to analyze other parameters.\n');

%% Export Results
% Save results to file for later analysis
save('data/parameter_sweep_results.mat', 'results');
fprintf('Results saved to data/parameter_sweep_results.mat\n');
