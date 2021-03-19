%% MATLAB script to convert scanned film to profile plots %%
% Please see accompanying PDF for protocol to run these scripts

% Written by J Yap, Apr 2019 (yapjacinta@gmail.com)

%% Load file - Enter name of file here without .txt
filenamecal = 'F2'; 

% Just need to run this calibration script once for the first film, comment it out 
% for subsequent analysis (speeds up this script)

%CalibrationODtoDose;

% Only change any of the following if there is a double peak & you need to
% fit a gaussian for the FWHM calculation

%% Read file %%
file = string(filenamecal)+'.txt';
    disptext = ['You are plotting ' char(file)];
    disp(disptext)
filmdata = dlmread(file, '', 1,0); %skip header line

%% Definitions

%columns
posXinch = filmdata(:,1); 
    posXcm = posXinch*25.4; %convert pixel position to cm

    %convert pixel values to dose    
    pixelVals = filmdata(:,2);
    converttoOD = -log10((Rcontrol-ZeroVal)./(pixelVals-ZeroVal));    
    ODtoDose = (fita*exp(fitb.*converttoOD))+(fitc*exp(fitd.*converttoOD));
    
%symmetrical plotting
    centre = max(posXcm)/2;
%invert plot
    %minPixelval = min(converttoOD);
%position (x column for plotting)
    position = posXcm - centre;
%converted dose (y column)
    pixel = ODtoDose;

%% Calculate FWHM

maxy=max(pixel);
halfy=maxy/2;
halfy=str2num(sprintf('%2.f',halfy));
array=[position pixel];
[m,closesty]=min(abs((pixel-halfy)));
index=array(closesty);
fwhms=abs(index)*2; 

% Calc FWHM by fitting a gaussian, if using this method uncomment the 4th line
f = fit(position,pixel,'gauss1');
coeff = coeffvalues(f);
fwhm1=2*sqrt(2*log(2))*(coeff(3));
%fwhms=fwhm1;

%% Graph positioning
figure
hold on
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.2, 0.2, 0.5, 0.6]);
arrangement = [0.27 0.12 0.7 0.8]; % [left bottom width height]
subplot('Position',arrangement);

%% Plot graph
a=plot(position,pixel,'LineWidth',1.2, 'Color',[0,0,1]);
name = [filenamecal ' Profile'];
title(name, 'FontSize',14); % graph title, change here if needed
grid on

set(gca, 'GridLineStyle','--', 'GridColor','[0.3 0.3 0.3]')

xlabel('Radial Position (mm)','fontweight','bold','FontSize',12);
xlim([-50,50]);

yl=ylabel('Dose (Gy)','fontweight','bold','FontSize',12);
    set(get(gca,'ylabel'),'rotation',0); %rotate y title horizontally
    set(yl,'Units','normalized');
    shift=0.15; %shift ylabel left
    set(yl,'Position',get(yl,'position')-[shift 0 0]) %position ylabel
    buffery=1.1*(max(pixel)); %increase y graph
ylim([0,buffery]);

%Uncomment to see fitted double gaussian
%plot(f,position,pixel); legend('FontSize',12,'Location','northwest');

%% FWHM box
annotate= ['FWHM= ' char(string(fwhms)) 'mm'];
annotation('textbox',[0.75 0.75 0.2 0.15],'String',{annotate},'FitBoxToText','on',...
    'FontSize',10, 'LineWidth',1, 'BackgroundColor',[1 1 1]);
disp(annotate)

%% Save as picture
saveasname_dated=filenamecal+"_"+string(date);
saveasname= saveasname_dated+'.png';
saveas(gcf,saveasname);
%print(gcf,'saveasnameHR.png','-dpng','-r600') %high resolution