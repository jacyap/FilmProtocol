%% MATLAB script to plot optical density calibration curves from scanned film %%

% Generates data for the BLUE channel
% Note: You don't need to open or run this script, it is called from the CalibrationODtoDose.m script
    % Checks: Make sure it is in the same directory as CalibrationODtoDose.m
% Written by J Yap, Apr 2019 (yapjacinta@gmail.com)

%% Load file - blue channel
file = fopen('blue.txt','rt');
datab = textscan(file,'%d %s %f %10f %f %f','HeaderLines',1); %skip header line
fclose(file);

%% Definitions %%
format long g
B = datab{3};
ZeroVal = 65535; % grey value from scanner (white pixel) 

DoseColb = datab{2};
db = split(DoseColb,'.');
DoseValsb = db(:,1);

MeanValsb = datab{4};
MinValsb = datab{5};
MaxValsb = datab{6};

%% Control

d1b=double(string(DoseValsb)); % convert to numbers
DoseDatab = [d1b, MeanValsb];
indexb = find(DoseDatab==0);
Bcontrol = DoseDatab(indexb,2);

%% Error bars

Diffblue = [d1b,MeanValsb,MinValsb,MaxValsb];
Diffblue = sortrows(Diffblue,1);
controlblue = Diffblue(1,:);

%term1
meanUnexpB=controlblue(2);
minUnexpB=controlblue(3);
maxUnexpB=controlblue(4);
uncertaintyUnexposedMinb=(meanUnexpB-minUnexpB)^2;
uncertaintyUnexposedMaxb=(meanUnexpB-maxUnexpB)^2;
bterm1=(uncertaintyUnexposedMinb+uncertaintyUnexposedMaxb)/2;

%term2
meanExpB=Diffblue(:,2);
minExpB=Diffblue(:,3);
maxExpB=Diffblue(:,4);
varExposedMinb=(meanExpB-minExpB).^2./length(meanExpB);
varExposedMaxb=(meanExpB-maxExpB).^2./length(meanExpB);
bterm2=(varExposedMinb+varExposedMaxb)./2;

%term3
bterm3=(controlblue(2)-ZeroVal)^2;

%term4, matrix
bterm4=(Diffblue(:,2)-ZeroVal).^2;

berrors=(1/log(10))*sqrt(bterm1/bterm3+bterm2./bterm4);

%% Optical density %%

ODblue = -log10((Bcontrol-ZeroVal)./(MeanValsb-ZeroVal));
doseBlue = sort(d1b);
Blue = sort(ODblue);
calibDataBlue = [doseBlue,Blue];

%% Plotting

%plot(Blue,doseBlue);
%errorbar(Blue,doseBlue,berrors,'horizontal');