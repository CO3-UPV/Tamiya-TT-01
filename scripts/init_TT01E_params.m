%% Tamiya TT-01E Vehicle Parameter Initialization
% This script initializes all the parameters required for the Simscape
% Multibody model of the Tamiya TT-01E touring car chassis.
%
% Author: Auto-generated
% Date: 2026-02-04

%% Clear workspace
clear all;
clc;

%% General Constants
params.g = 9.81; % Gravitational acceleration [m/s^2]

%% Vehicle Dimensions (based on TT-01E specifications)
% The TT-01E is a 1/10 scale touring car with 257mm wheelbase
params.vehicle.wheelbase = 0.257;        % Wheelbase [m]
params.vehicle.track_front = 0.168;      % Front track width [m]
params.vehicle.track_rear = 0.168;       % Rear track width [m]
params.vehicle.length = 0.440;           % Overall length [m]
params.vehicle.width = 0.200;            % Overall width [m]
params.vehicle.height = 0.130;           % Overall height [m]

%% Chassis/Body Parameters
params.chassis.mass = 1.5;               % Chassis mass [kg] (approximate with battery)
params.chassis.Ixx = 0.015;              % Roll moment of inertia [kg*m^2]
params.chassis.Iyy = 0.030;              % Pitch moment of inertia [kg*m^2]
params.chassis.Izz = 0.035;              % Yaw moment of inertia [kg*m^2]
params.chassis.CoG_height = 0.040;       % Center of gravity height from ground [m]

% Chassis visual dimensions
params.chassis.visual.length = 0.380;    % Visual length [m]
params.chassis.visual.width = 0.190;     % Visual width [m]
params.chassis.visual.height = 0.050;    % Visual height [m]

%% Wheel Parameters
params.wheel.radius = 0.0305;            % Wheel radius [m] (61mm diameter wheels common)
params.wheel.width = 0.026;              % Wheel width [m]
params.wheel.mass = 0.050;               % Mass per wheel [kg]
params.wheel.Ixx = 2.3e-5;               % Wheel moment of inertia (transverse) [kg*m^2]
params.wheel.Iyy = 4.5e-5;               % Wheel moment of inertia (spin axis) [kg*m^2]
params.wheel.Izz = 2.3e-5;               % Wheel moment of inertia (vertical) [kg*m^2]

%% Tire Parameters (Simple Pacejka-like model)
params.tire.stiffness = 15000;           % Vertical tire stiffness [N/m]
params.tire.damping = 150;               % Vertical tire damping [N*s/m]
params.tire.friction_static = 1.1;       % Static friction coefficient [-]
params.tire.friction_kinetic = 0.9;      % Kinetic friction coefficient [-]
params.tire.rolling_resistance = 0.015;  % Rolling resistance coefficient [-]

%% Suspension Parameters (TT-01E uses double wishbone suspension)
% Front Suspension
params.susp.front.spring_rate = 2500;    % Spring rate [N/m]
params.susp.front.damping = 80;          % Damping coefficient [N*s/m]
params.susp.front.travel = 0.025;        % Suspension travel [m]
params.susp.front.camber = -1.0;         % Static camber angle [deg]
params.susp.front.toe = 0.0;             % Toe angle [deg]
params.susp.front.caster = 3.0;          % Caster angle [deg]

% Rear Suspension
params.susp.rear.spring_rate = 2800;     % Spring rate [N/m]
params.susp.rear.damping = 90;           % Damping coefficient [N*s/m]
params.susp.rear.travel = 0.025;         % Suspension travel [m]
params.susp.rear.camber = -1.5;          % Static camber angle [deg]
params.susp.rear.toe = 0.0;              % Toe angle [deg]

%% Motor Parameters (typical 540-size brushed motor)
params.motor.torque_constant = 0.012;    % Torque constant [N*m/A]
params.motor.resistance = 0.05;          % Armature resistance [Ohm]
params.motor.inductance = 0.0001;        % Armature inductance [H]
params.motor.inertia = 5e-6;             % Rotor inertia [kg*m^2]
params.motor.damping = 1e-5;             % Viscous damping [N*m*s/rad]
params.motor.max_voltage = 7.2;          % Maximum voltage [V] (6-cell NiMH)

%% Drivetrain Parameters
% Gear ratios
params.drivetrain.motor_pinion = 23;     % Motor pinion teeth
params.drivetrain.spur_gear = 72;        % Spur gear teeth
params.drivetrain.final_drive = 3.73;    % Final drive ratio
params.drivetrain.overall_ratio = ...
    (params.drivetrain.spur_gear / params.drivetrain.motor_pinion) * ...
    params.drivetrain.final_drive;       % Overall gear ratio

% Differential
params.drivetrain.diff_efficiency = 0.95; % Differential efficiency [-]
params.drivetrain.diff_inertia = 1e-5;   % Differential inertia [kg*m^2]

% Driveshaft/axle parameters
params.drivetrain.shaft_stiffness = 5000; % Shaft torsional stiffness [N*m/rad]
params.drivetrain.shaft_damping = 0.1;   % Shaft damping [N*m*s/rad]

%% Aerodynamic Parameters
params.aero.drag_coeff = 0.35;           % Drag coefficient [-]
params.aero.frontal_area = 0.024;        % Frontal area [m^2]
params.aero.air_density = 1.225;         % Air density [kg/m^3]
params.aero.downforce_coeff = 0.0;       % Downforce coefficient [-] (no wing)

%% Initial Conditions
params.IC.velocity = 0;                  % Initial velocity [m/s]
params.IC.x_pos = 0;                     % Initial x position [m]
params.IC.y_pos = 0;                     % Initial y position [m]
params.IC.yaw = 0;                       % Initial yaw angle [rad]

%% Simulation Parameters
params.sim.time_step = 0.001;            % Fixed step size [s]
params.sim.stop_time = 10;               % Simulation stop time [s]
params.sim.solver = 'ode4';              % Solver type (Runge-Kutta)

%% Control Inputs (Open-Loop)
% Time vector for input signals
params.input.time = [0 1 2 3 10];        % Time points [s]

% Throttle input (0 to 1, where 1 is full throttle)
params.input.throttle = [0 0.5 0.5 0.3 0.3]; % Throttle [-]

% Steering input (-1 to 1, where -1 is full left, 1 is full right)
params.input.steering = [0 0 0.3 0.3 0];  % Steering angle [-]
params.input.steering_ratio = 15;         % Steering ratio (deg of wheel per unit input)

%% Display confirmation
fprintf('TT-01E vehicle parameters loaded successfully.\n');
fprintf('Wheelbase: %.3f m\n', params.vehicle.wheelbase);
fprintf('Total mass: %.2f kg\n', params.chassis.mass);
fprintf('Overall gear ratio: %.2f:1\n', params.drivetrain.overall_ratio);

%% Save to MAT file for easy loading
save('data/TT01E_params.mat', 'params');
fprintf('Parameters saved to data/TT01E_params.mat\n');
