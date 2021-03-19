%% MATLAB script to plot optical density calibration curves from scanned film %%

% Generates data for the GREEN channel
% Note: You don't need to open or run this script, it is called from the CalibrationODtoDose.m script
    % Checks: Make sure it is in the same directory as CalibrationODtoDose.m
% Written by J Yap, Apr 2019 (yapjacinta@gmail.com)

%% Load file - green channel
file = fopen('green.txt','rt');
datag = textscan(file,'%d %s %f %10f %f %f','HeaderLines',1); %skip header line
fclose(file);

%% Definitions %%
format long g
G = datag{3};
ZeroVal = 65535; % grey value from scanner (white pixel) 

DoseColg = datag{2};
dg = split(DoseColg,'.');
DoseValsg = dg(:,1);

MeanValsg = datag{4};
MinValsg = datag{5};
MaxValsg = datag{6};

%% Control

d1g=double(string(DoseValsg)); % convert to numbers
DoseDatag = [d1g, MeanValsg];
indexg = find(DoseDatag==0);
Gcontrol = DoseDatag(indexg,2);

%% Error bars

Diffgreen = [d1g,MeanValsg,MinValsg,MaxValsg];
Diffgreen = sortrows(Diffgreen,1);
controlgreen = Diffgreen(1,:);

%term1
meanUnexpG=controlgreen(2);
minUnexpG=controlgreen(3);
maxUnexpG=controlgreen(4);
uncertaintyUnexposedMing=(meanUnexpG-minUnexpG)^2;
uncertaintyUnexposedMaxg=(meanUnexpG-maxUnexpG)^2;
gterm1=(uncertaintyUnexposedMing+uncertaintyUnexposedMaxg)/2;

%term2
meanExpG=Diffgreen(:,2);
minExpG=Diffgreen(:,3);
maxExpG=Diffgreen(:,4);
varExposedMing=(meanExpG-minExpG).^2./length(meanExpG);
varExposedMaxg=(meanExpG-maxExpG).^2./length(meanExpG);
gterm2=(varExposedMing+varExposedMaxg)./2;

%term3
gterm3=(controlgreen(2)-ZeroVal)^2;

%term4, matrix
gterm4=(Diffgreen(:,2)-ZeroVal).^2;

gerrors=(1/log(10))*sqrt(gterm1/gterm3+gterm2./gterm4);

%% Optical density %%

ODgreen = -log10((Gcontrol-ZeroVal)./(MeanValsg-ZeroVal));
doseGreen = sort(d1g);
Green = sort(ODgreen);
calibDataGreen = [doseGreen,Green];

%% Plotting

%plot(Green,doseGreen);
%errorbar(Green,doseGreen,gerrors,'horizontal');