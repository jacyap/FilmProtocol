%% MATLAB script to plot optical density calibration curves from scanned film %%
% This is for the RED channel but will also automatically call the scripts for the blue & green
% Example film is from studies performed at the Clatterbridge Cancer Centre, UK 60 MeV proton therapy beamline
% Please read accompanying protocol PDF for how to run these scripts

% Written by J Yap, Apr 2019 (yapjacinta@gmail.com)
% Updated all scripts Mar, 2021
%% Load file - red channel
filename = 'red'; 
fileID = string(filename)+'.txt';

file = fopen(fileID,'rt');
data = textscan(file,'%d %s %f %10f %f %f','HeaderLines',1); %skip header line
fclose(file);

%% Definitions %%
format long g
A = data{3};
Area = A(1);
ZeroVal = 65535; % grey value from scanner (white pixel) 

DoseCol = data{2};
d = split(DoseCol,'.');
DoseVals = d(:,1);

MeanVals = data{4};
MinVals = data{5};
MaxVals = data{6};

%% Control

d1=double(string(DoseVals)); % convert to numbers
DoseData = [d1, MeanVals];
index = find(DoseData==0);
Rcontrol = DoseData(index,2);

%% Optical density %%

OD = -log10((Rcontrol-ZeroVal)./(MeanVals-ZeroVal));
doseRed = sort(d1);
Red = sort(OD);
calibData = [doseRed,Red];

%% Run blue & green scripts %%

CalibrationBlue;
CalibrationGreen;

%% Interpolate between points for smooth curves %%

f1 = fit(Red,doseRed,'smoothingspline');
f2 = fit(Green,doseGreen,'linear');
f3 = fit(Blue,doseBlue,'linear');

%% Fit to red channel curve %%

x1=Red(2:end);
y1=doseRed(2:end);
f=fit(x1,y1,'exp2'); %type of fit 'exp1'

coeff = coeffvalues(f);

fita = coeff(1);
fitb = coeff(2);
fitc = coeff(3); %comment out for exp1
fitd = coeff(4); %comment out for exp1

%% Error bars

Diffred = [d1,MeanVals,MinVals,MaxVals];
Diffred = sortrows(Diffred,1);
controlred = Diffred(1,:);

%term1, note variance bckg=0
meanUnexpR=controlred(2);
minUnexpR=controlred(3);
maxUnexpR=controlred(4);
uncertaintyUnexposedMinr=(meanUnexpR-minUnexpR)^2;
uncertaintyUnexposedMaxr=(meanUnexpR-maxUnexpR)^2;
rterm1=(uncertaintyUnexposedMinr+uncertaintyUnexposedMaxr)/2;

%term2
meanExpR=Diffred(:,2);
minExpR=Diffred(:,3);
maxExpR=Diffred(:,4);
varExposedMinr=(meanExpR-minExpR).^2./length(meanExpR);
varExposedMaxr=(meanExpR-maxExpR).^2./length(meanExpR);
rterm2=(varExposedMinr+varExposedMaxr)./2;

%term3
rterm3=(controlred(2)-ZeroVal)^2;

%term4
rterm4=(Diffred(:,2)-ZeroVal).^2;

rerrors=(1/log(10))*sqrt(rterm1/rterm3+rterm2./rterm4);

%% Plotting

figure
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.2, 0.2, 0.4, 0.6]);
arrangement = [0.27 0.12 0.7 0.8]; % [left bottom width height]

pr=plot(Red,doseRed,'o');
pr.DisplayName='Red';
pr.Color='red';
pr.MarkerSize=5;
pr.MarkerFaceColor='red';
%interpolated curve
hold on
f1r=plot(f1);
f1r.Color='red';
f1r.LineWidth=1.2;

pg=plot(Green,doseGreen,'o');
pg.DisplayName='Green';
pg.Color='green';
pg.MarkerSize=5;
pg.MarkerFaceColor='green';
%interpolated curve
f2r=plot(f2);
f2r.Color='green';
f2r.LineWidth=1.2;

pb=plot(Blue,doseBlue,'o');
pb.DisplayName='Blue';
pb.Color='blue';
pb.MarkerSize=5;
pb.MarkerFaceColor='blue';
%interpolated curve
f3r=plot(f3);
f3r.Color='blue';
f3r.LineWidth=1.2;

%plot fitted curve (comment out to hide in plot)
pf=plot(f,'black');
pf.LineWidth=1;
pf.DisplayName='Fit';

rer=errorbar(Red,doseRed,rerrors,'.','horizontal','CapSize',4);
rer.Bar.LineStyle='dotted';
reg=errorbar(Green,doseGreen,gerrors,'.','horizontal','CapSize',4);
reg.Bar.LineStyle='dotted';
reb=errorbar(Blue,doseBlue,berrors,'.','horizontal','CapSize',4);
reb.Bar.LineStyle='dotted';
hold off

title('Optical Density Calibration', 'FontSize',14); % graph title, change here if needed
grid on
ylabel('Dose (Gy)','fontweight','bold','FontSize',12);
ylim([0,60]);
xlabel('Net OD','fontweight','bold','FontSize',12);
xlim([0,inf])
xticks([0:0.05:0.5]);

% legend
lgd=legend;
lgd.FontSize=12;
lgd.Title.String = 'Channel';
lgd.Location='northwest';
legend([pr pg pb pf]);
%legend([pr pg pb]);

%% Save as picture

savefilename = string(date)+'_CalibrationCurve.png';
saveas(gcf,savefilename);
%print(gcf,savefilename,'-dpng','-r600') %high resolution