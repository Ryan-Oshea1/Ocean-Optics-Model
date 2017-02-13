%Summer 2016 Optics Simulation Model
clc;
%clear all;
% update QE, wavelength, radiance, downwelling irradiance for each new run

%set the camera paramters here
fullWellCapacity = 16408;
electronsPerPixel=0;
%exposure = 10*10^-6 + .015

%create arrays 
loopCounter=0
iterations=200
electronsPerPixel_Exposure550=zeros(iterations,10);
sensitivity550=zeros(iterations,10);

%more output array setup
outputCell{1,1}='Exposure time';%'Full Well Capacity';'OverallS SNR';'Absolute Sensitivity']
outputCell{1,2}='Electrons per pixel';
photonCountLoc=2
photonShotNoiseLoc=3
electronCountLoc=4;
fullWellCapExcLoc=5;
absSensLoc=6;
SNRWarningLoc=7;
overallSNRLoc=8;
countedPhotonLoc=9
inputRadianceLoc=10
calculatedRadianceLoc=11
calculatedRrsLoc=12
calculatedConcentration_OC4Loc=13
calculatedConcentration_Camera_OC4Loc=14
calculatedRrsSLoc = 15
calculatedChlaSLoc = 16
calculatedRrsDLoc = 17
calculatedChlaDLoc = 18

outputCell=cell(11,3);
outputCell{1,1}='Water Leaving Radiances From 0 to 50 mg/m^3 using a 1380H Camera';
outputCell{electronCountLoc,1}='Electron Count';%'Full Well Capacity';'OverallS SNR';'Absolute Sensitivity']
outputCell{fullWellCapExcLoc,1}='Full Well Capacity Exceeded?';
outputCell{absSensLoc,1}='Absolute Sensitivity';
outputCell{overallSNRLoc,1}='Overall SNR';
outputCell{SNRWarningLoc,1}='Below 7 SNR ratio?';
outputCell{photonCountLoc,1}='Photon Count';
outputCell{photonShotNoiseLoc,1}='photon shot noise';
outputCell{countedPhotonLoc,1}='Counted photons after bit representation';
outputCell{inputRadianceLoc,1} = 'input radiance';
outputCell{calculatedRadianceLoc,1} = 'calcualted radiance';
outputCell{calculatedRrsLoc,1} = 'calcualted Rrs)';
outputCell{calculatedConcentration_OC4Loc,1} = 'calcualted chl a OC4';
outputCell{calculatedConcentration_Camera_OC4Loc,1} = 'calcualted Chl a From Camera OC4';
outputCell{calculatedRrsSLoc,1} = 'calcualted Rrs Including Shot noise';
outputCell{calculatedChlaSLoc,1} = 'calcualted Chl a Including Shot noise (95%)';

outputCell{calculatedRrsDLoc,1} = 'calcualted Rrs Including Shot noise (-)';
outputCell{calculatedChlaDLoc,1} = 'calcualted Chl a Including Shot noise (95%) (-)';
outputCell{1,2}='440 at 0 ug/L';%'Full Well Capacity';'OverallS SNR';'Absolute Sensitivity']
outputCell{1,3}='550 at 0 ug/L';
outputCell{1,4}='510 at 5 ug/L';
outputCell{1,5}='550 at 5 ug/L';
outputCell{1,6}='510 at 10 ug/L';
outputCell{1,7}='550 at 10 ug/L';
outputCell{1,8}='440 at 1 ug/L';
outputCell{1,9}='550 at 1 ug/L';
outputCell{1,10}='440 at .1 ug/L';
outputCell{1,11}='550 at .1 ug/L';
outputCell{1,12}='440 at .5 ug/L';
outputCell{1,13}='550 at .5 ug/L';

minNumber443=2;
maxNumber443=3;
minNumber550=4;
maxNumber550=5;
minNumber680=6;
maxNumber680=7;
minNumber760=8;
maxNumber760=9;

%Varying Constraints
SNRWarningLevel = 7
%physics dependent variables min/max ar 443, 550, 680, 760 nm
% inputRadiance1=.001; %W/m^2/sr/nm
% inputRadiance2=.045; %W/m^2/sr/nm
% inputRadiance3=.001; %W/m^2/sr/nm
% inputRadiance4=.01;  %W/m^2/sr/nm
% inputRadiance5=.00008;
% inputRadiance6=.01;
% inputRadiance7=.000005;
% inputRadiance8=.003;
% 
%input radiance from graph -at 550 nm over different concentrations
% inputRadiance1=.001; %W/m^2/sr/nm
% inputRadiance2=.002; %W/m^2/sr/nm
% inputRadiance3=.0025; %W/m^2/sr/nm
% inputRadiance4=.0025;  %W/m^2/sr/nm
% inputRadiance5=.003;
% inputRadiance6=.0035;
% inputRadiance7=.01;
% inputRadiance8=.01;

%input radiance from graph -at concentration of 10 micrograms per liter nm over different concentrations
inputRadiance1=.028; %W/m^2/sr/nm 440nm at 0 ug/L 1 5 6 4 2 3 
inputRadiance2=.002; %W/m^2/sr/nm 550n at 0 ug/L
inputRadiance3=.002; %W/m^2/sr/nm 510nm at 5 ug/L 2
inputRadiance4=.003;  %W/m^2/sr/nm 550nm at 5 ug/L
inputRadiance5=.0023; %W/m^2/sr/nm 510n at 10 ug/L 3 
inputRadiance6=.00325; %W/m^2/sr/nm 550n at 10 ug/L
inputRadiance7=.0023; %W/m^2/sr/nm 440 at 1 ug/L 4
inputRadiance8=.0023;  %W/m^2/sr/nm 550 at 1 ug/L
inputRadiance9=.01; %W/m^2/sr/nm 440 at .1 ug/L 5 
inputRadiance10=.00225;  %W/m^2/sr/nm 550 at .1 ug/L
inputRadiance11=.004; %W/m^2/sr/nm 440 at .5 ug/L 6 
inputRadiance12=.0029;  %W/m^2/sr/nm 550 at .5 ug/L



radianceMatrix=[inputRadiance1;inputRadiance2; inputRadiance3;inputRadiance4;inputRadiance5;inputRadiance6;inputRadiance7;inputRadiance8;inputRadiance9;inputRadiance10;inputRadiance11;inputRadiance12]%;inputRadiance4;inputRadiance5;inputRadiance6;inputRadiance7;inputRadiance8];
conversionFactor = (1/1000)*(10000/1)*(1/1000)%mW/cm^2/microMeter/sr to W/m^2/sr/nm

%
c=3 * 10^8;
h=6.626 * 10^-34;
wavelengthMatrix = [440;550;510;550;510;550;440;550;440;550;440;550].* 10^-9;
typicalWavespeed = 2.5 ; %m/s speed of oean waves
desiredFOVWidth = 200; %meters

%atmospheric path radiance from ocean optics figure 2 http://www.oceanopticsbook.info/view/remote_sensing/the_atmospheric_correction_problem
atmosphericPathRadianceMatrix = [.005/15;.005/30;.005/30;.005/30;.005/30;.005/30;.005/15;.005/30;.005/15;.005/30;.005/15;.005/30;] % w/m^2/nm
%atmosphericPathRadianceMatrix = [0;0;0;0;0;0;0;0;0;0;0;0;] % w/m^2/nm

%Operationally dependent variables
altitude=100; %meters, the FAAA has a 400 foot maximum currently
numberOfCameras = 2; %system calculations
flightDuration = 1; %hours

%Camera dependent variables
bytesPerPixel = 2;
bitCount= 12;
counts=2^bitCount
electronsPerCount=fullWellCapacity/counts; %correct?

%Interface dependent variables
maxByteRate = 80 * 10^6;

%Light Sensor dependent variables
pixelWidth= 6.45*10^-6; %meters. generally 5-10 um, same height/width
pixelHeight= pixelWidth;%125*10^-6;
pixelArea=pixelWidth^2;%*pixelHeight; %meters
transmissionCoefficient= 80; %paper said generally 70-90% (aka optical efficiency of the sensor
opticalElementEfficiency=.92*.93*.93*.62*.85%percent of light that gets through the optical elements (window (n-bk7 92%),dichroic (93%),bandpass,lens (93%),IRfilter)
sensorHeight = 6.6*10^-3;
sensorWidth  = 8.8*10^-3;
pixelCount=1384*1036;
quantumEfficiency525 = .65;
quantumEfficiency=[.61,.62,.64,.62,.64,.62,.61,.62,.61,.62,.61,.62] %icx285 http://blog.astrofotky.cz/pavelpech/files/2013/03/QE_PBernhard.jpg at 510/550/440/550
%quantumEfficiency = [quantumEfficiency525*.7;quantumEfficiency525*.7;quantumEfficiency525;quantumEfficiency525;quantumEfficiency525*.75;quantumEfficiency525*.75;quantumEfficiency525*.5;quantumEfficiency525*.5]
%fullWellCapacity = 16408;
electronCurrent=5 ;%electrons/second, dependent on temperature
readNoise = 11.9;
%readNoise = 0
%Optics dependent variables
focalLength = 25*10^-3; %meters Larger focal length gives better resolution
fNumber=1.4;
diameterOfAperture = focalLength/fNumber;
viewingAngle= 2*atan(sensorWidth/(2*focalLength))*180/pi/2; %atleast 114.2 degrees for f = .005
filterBandwidth = 10; %nanometers
%exposure = 5*10^-3;

% calculated geometries
FOVWidth=altitude*tan(viewingAngle/180*pi*2/2)*2;
FOVHeight = FOVWidth*40.16/52.06
FOVDiagonal = sqrt(FOVWidth^2+FOVHeight^2)
stationaryResolution= FOVWidth^2/(pixelCount)*10000;%centimeters squared per pixel

%Optimal focal length calculator
 magnification=sensorWidth/FOVWidth;
 calculatedRequiredFocalLength = (sensorWidth*altitude)/(desiredFOVWidth);
 finiteFNumber=fNumber*(magnification+1);
 
 if(finiteFNumber>fNumber*1.05)
     disp('Warning: Finite F Number significantly larger than infinite fNumber');
 end
 
 focalLength400 = .98*focalLength;
 focalLength550 = 1.005*focalLength;
 focalLength700 = 1.02*focalLength;
 focalLengthDifference=focalLength700-focalLength400;
 
 %power consumption calculator
 microcontrollerPowerConsumption=5; %watts
 cameraPowerConsumption = 3.5; %watts
 hardwarePowerConsumption = 1.5 %watts, exaggerated
 
 totalPowerConsumption=numberOfCameras*(cameraPowerConsumption)+ hardwarePowerConsumption + microcontrollerPowerConsumption*numberOfCameras; %watts

 totalEnergy = totalPowerConsumption*flightDuration; %watt*hours (Joules)
 
 %goes through multiple exposure values
% electronsPerPixel_Exposure{loopCounter+1,2} = 0;
%while(exposure < .03*200/150)
%setup of output matrix

%downwelling radiance at the ocean surface for 30 degrees from zenith,
%calculated from input
downwellingIrradiance_30 = [1.15, 1.45, 1.45, 1.45,1.45, 1.45, 1.15, 1.45,1.15, 1.45,1.15, 1.45]%W per meter squared per nanometer. 510, 550, 680, 760,,, 510 =1.45

remoteSensingReflectance = [radianceMatrix(1)/downwellingIrradiance_30(1),radianceMatrix(2)/downwellingIrradiance_30(2)] %440/550
a_coeff=[.3255,-2.7677,2.4409,-1.1288,-.499]
log_10_chla= a_coeff(1)+a_coeff(2)*log10(remoteSensingReflectance(1)/remoteSensingReflectance(2))^1+a_coeff(3)*log10(remoteSensingReflectance(1)/remoteSensingReflectance(2))^2+a_coeff(4)*log10(remoteSensingReflectance(1)/remoteSensingReflectance(2))^3+a_coeff(5)*log10(remoteSensingReflectance(1)/remoteSensingReflectance(2))^4
chl_a_concentration = 10^(log_10_chla) %mg/m^3 or ug/L
outputCell{calculatedConcentration_OC4Loc,2} = chl_a_concentration;

remoteSensingReflectance = [radianceMatrix(3)/downwellingIrradiance_30(3),radianceMatrix(4)/downwellingIrradiance_30(4)] %440/550
a_coeff=[.3255,-2.7677,2.4409,-1.1288,-.499]
log_10_chla= a_coeff(1)+a_coeff(2)*log10(remoteSensingReflectance(1)/remoteSensingReflectance(2))^1+a_coeff(3)*log10(remoteSensingReflectance(1)/remoteSensingReflectance(2))^2+a_coeff(4)*log10(remoteSensingReflectance(1)/remoteSensingReflectance(2))^3+a_coeff(5)*log10(remoteSensingReflectance(1)/remoteSensingReflectance(2))^4
chl_a_concentration = 10^(log_10_chla) %mg/m^3 or ug/L
outputCell{calculatedConcentration_OC4Loc,4} = chl_a_concentration;

remoteSensingReflectance = [radianceMatrix(5)/downwellingIrradiance_30(5),radianceMatrix(6)/downwellingIrradiance_30(6)] %440/550
a_coeff=[.3255,-2.7677,2.4409,-1.1288,-.499]
log_10_chla= a_coeff(1)+a_coeff(2)*log10(remoteSensingReflectance(1)/remoteSensingReflectance(2))^1+a_coeff(3)*log10(remoteSensingReflectance(1)/remoteSensingReflectance(2))^2+a_coeff(4)*log10(remoteSensingReflectance(1)/remoteSensingReflectance(2))^3+a_coeff(5)*log10(remoteSensingReflectance(1)/remoteSensingReflectance(2))^4
chl_a_concentration = 10^(log_10_chla) %mg/m^3 or ug/L
outputCell{calculatedConcentration_OC4Loc,6} = chl_a_concentration;

remoteSensingReflectance = [radianceMatrix(7)/downwellingIrradiance_30(7),radianceMatrix(8)/downwellingIrradiance_30(8)] %440/550
a_coeff=[.3255,-2.7677,2.4409,-1.1288,-.499]
log_10_chla= a_coeff(1)+a_coeff(2)*log10(remoteSensingReflectance(1)/remoteSensingReflectance(2))^1+a_coeff(3)*log10(remoteSensingReflectance(1)/remoteSensingReflectance(2))^2+a_coeff(4)*log10(remoteSensingReflectance(1)/remoteSensingReflectance(2))^3+a_coeff(5)*log10(remoteSensingReflectance(1)/remoteSensingReflectance(2))^4
chl_a_concentration = 10^(log_10_chla) %mg/m^3 or ug/L
outputCell{calculatedConcentration_OC4Loc,8} = chl_a_concentration;

remoteSensingReflectance = [radianceMatrix(9)/downwellingIrradiance_30(9),radianceMatrix(10)/downwellingIrradiance_30(10)] %440/550
a_coeff=[.3255,-2.7677,2.4409,-1.1288,-.499]
log_10_chla= a_coeff(1)+a_coeff(2)*log10(remoteSensingReflectance(1)/remoteSensingReflectance(2))^1+a_coeff(3)*log10(remoteSensingReflectance(1)/remoteSensingReflectance(2))^2+a_coeff(4)*log10(remoteSensingReflectance(1)/remoteSensingReflectance(2))^3+a_coeff(5)*log10(remoteSensingReflectance(1)/remoteSensingReflectance(2))^4
chl_a_concentration = 10^(log_10_chla) %mg/m^3 or ug/L
outputCell{calculatedConcentration_OC4Loc,10} = chl_a_concentration;

remoteSensingReflectance = [radianceMatrix(11)/downwellingIrradiance_30(11),radianceMatrix(12)/downwellingIrradiance_30(12)] %440/550
a_coeff=[.3255,-2.7677,2.4409,-1.1288,-.499]
log_10_chla= a_coeff(1)+a_coeff(2)*log10(remoteSensingReflectance(1)/remoteSensingReflectance(2))^1+a_coeff(3)*log10(remoteSensingReflectance(1)/remoteSensingReflectance(2))^2+a_coeff(4)*log10(remoteSensingReflectance(1)/remoteSensingReflectance(2))^3+a_coeff(5)*log10(remoteSensingReflectance(1)/remoteSensingReflectance(2))^4
chl_a_concentration = 10^(log_10_chla) %mg/m^3 or ug/L
outputCell{calculatedConcentration_OC4Loc,12} = chl_a_concentration;

exposure=10*10^-3

for(matrixValue=1:length(radianceMatrix))
    
darkNoise=(electronCurrent*exposure)^.5;
   %darkNoise=0
%Calculated energy/power quantities
powerPerPixel = (radianceMatrix(matrixValue)+atmosphericPathRadianceMatrix(matrixValue))*stationaryResolution/10000*transmissionCoefficient/100*opticalElementEfficiency*pi*diameterOfAperture^2/(4*altitude^2)*filterBandwidth   %Watts
energyPerPixel = powerPerPixel*exposure
energyOfAPhoton = c*h/wavelengthMatrix(matrixValue)
photonsPerPixel = energyPerPixel/energyOfAPhoton
photonShotNoiseRandom=round(normrnd(0,sqrt(photonsPerPixel)))
electronsPerPixel = (photonsPerPixel)*quantumEfficiency(matrixValue)+darkNoise+readNoise % add in photon shot noise


%reconstruction
totalSignalAsBits = round(electronsPerPixel/electronsPerCount) %round for integer number 
%totalSignalAsBits = (electronsPerPixel/electronsPerCount) %round for integer number 
bitsToElectrons = round(totalSignalAsBits*electronsPerCount) 
%bitsToElectrons = (totalSignalAsBits*electronsPerCount) 

electronsToPhotons = bitsToElectrons/quantumEfficiency(matrixValue) %
%outputCell{countedPhotonLoc,matrixValue+1} = electronsToPhotons(matrixValue);
calculatedEnergyPerPixel= energyOfAPhoton*electronsToPhotons
calculatedPowerPerPixel = calculatedEnergyPerPixel/exposure
radianceFromPower = calculatedPowerPerPixel/(stationaryResolution/10000*transmissionCoefficient/100*opticalElementEfficiency*pi*diameterOfAperture^2/(4*altitude^2)*filterBandwidth)
calculatedRemoteSensingReflectance = radianceFromPower/downwellingIrradiance_30(matrixValue)

    %including the photon shot noise
    electronsPerPixelS = (photonsPerPixel+1.96*sqrt(photonsPerPixel))*quantumEfficiency(matrixValue)+darkNoise+readNoise % add in photon shot noise

    totalSignalAsBitsS = round(electronsPerPixelS/electronsPerCount) %round for integer number 
    bitsToElectronsS = round(totalSignalAsBitsS*electronsPerCount) 
    electronsToPhotonsS = bitsToElectronsS/quantumEfficiency(matrixValue) %
    %outputCell{countedPhotonLoc,matrixValue+1} = electronsToPhotons(matrixValue);
    calculatedEnergyPerPixelS= energyOfAPhoton*electronsToPhotonsS
    calculatedPowerPerPixelS = calculatedEnergyPerPixelS/exposure
    radianceFromPowerS = calculatedPowerPerPixelS/(stationaryResolution/10000*transmissionCoefficient/100*opticalElementEfficiency*pi*diameterOfAperture^2/(4*altitude^2)*filterBandwidth)
    calculatedRemoteSensingReflectanceS = radianceFromPowerS/downwellingIrradiance_30(matrixValue)



    %including the photon shot noise
    electronsPerPixelD = (photonsPerPixel-1.96*sqrt(photonsPerPixel))*quantumEfficiency(matrixValue)+darkNoise+readNoise % add in photon shot noise

    totalSignalAsBitsD = round(electronsPerPixelD/electronsPerCount) %round for integer number 
    bitsToElectronsD = round(totalSignalAsBitsD*electronsPerCount) 
    electronsToPhotonsD = bitsToElectronsD/quantumEfficiency(matrixValue) %
    %outputCell{countedPhotonLoc,matrixValue+1} = electronsToPhotons(matrixValue);
    calculatedEnergyPerPixelD= energyOfAPhoton*electronsToPhotonsD
    calculatedPowerPerPixelD = calculatedEnergyPerPixelD/exposure
    radianceFromPowerD = calculatedPowerPerPixelD/(stationaryResolution/10000*transmissionCoefficient/100*opticalElementEfficiency*pi*diameterOfAperture^2/(4*altitude^2)*filterBandwidth)
    calculatedRemoteSensingReflectanceD = radianceFromPowerD/downwellingIrradiance_30(matrixValue)




% electronsPerPixel_Exposure[loopCounter,loopCounter]=[exposure,electronsPerPixel]
    electronsPerPixel_Exposure550(loopCounter+1,1) = exposure;
    sensitivity550(loopCounter+1,1)=exposure;
    electronsPerPixel_Exposure550(loopCounter+1,matrixValue+1)= electronsPerPixel;
    
%calculated noise and SNR
diffractionLimit =1/(fNumber*wavelengthMatrix(matrixValue)*1000); %line pairs/mm
airyDiskDiameter=2.44*fNumber*wavelengthMatrix(matrixValue); %size of the bright spot in the center of the image, pixel size should be larger than this
if( airyDiskDiameter > pixelWidth)
    disp('Airy Disk Diameter limited');
end
nyquistFrequency = 1/(pixelWidth*2);                %line pairs per mm
snrOfLight=photonsPerPixel^.5 ;                %accurate? from sensitivity of digital
snrOfImage=quantumEfficiency(matrixValue)^.5*snrOfLight;    %accurate? from sensitivity of digital
snrMax = fullWellCapacity^.5;                  %accurate? from sensitivity of digital

%noise sources and SNR
darkNoise=(electronCurrent*exposure)^.5;
photonShotNoise = (quantumEfficiency(matrixValue)*photonsPerPixel)^.5;
% add in random photon shot noise
photonShotNoiseRandGauss =round(normrnd(photonsPerPixel,photonsPerPixel)) %photon shot noise is a gaussian distributed signal
%
effectiveTotalNoise = (darkNoise^2+photonShotNoise^2+readNoise^2)^.5;
%overallSNR = photonsPerPixel/effectiveTotalNoise; %MOST accurate
overallSNR = photonsPerPixel*quantumEfficiency(matrixValue)/(photonsPerPixel*quantumEfficiency(matrixValue)+electronCurrent*exposure+readNoise)^.5; %FROM https://micro.magnet.fsu.edu/primer/digitalimaging/concepts/ccdsnr.html
absoluteSensitivity = effectiveTotalNoise/quantumEfficiency(matrixValue); %minimum photon countfor signal to match noise level, accurate?

sensitivity550(loopCounter+1,matrixValue+1)=effectiveTotalNoise*(counts/fullWellCapacity)*(radianceMatrix(matrixValue)/(counts));

electronsPerPixel_Exposure550(loopCounter+1,10)= effectiveTotalNoise;
%calculated interface values
maximumFPS = maxByteRate/(numberOfCameras*pixelCount*bytesPerPixel);

%Sanity Checks
if(electronsPerPixel>fullWellCapacity)
    fullWellCapacityExceeded = 'Yes';
    disp('Full well capacity exceeded')
else
     fullWellCapacityExceeded = 'No';
    disp('Within full well capacity bound')
end

if(overallSNR<SNRWarningLevel)
    SNRWarningLevelExceeded = 'Yes';
    disp('SNR Warning Level exceeded')
else
     SNRWarningLevelExceeded = 'No';
    disp('Within SNR Warning Level')
end

outputCell{electronCountLoc,matrixValue+1} = electronsPerPixel;
outputCell{fullWellCapExcLoc,matrixValue+1} = fullWellCapacityExceeded;
outputCell{absSensLoc,matrixValue+1} = absoluteSensitivity;
outputCell{overallSNRLoc,matrixValue+1} = overallSNR;
outputCell{SNRWarningLoc,matrixValue+1} = SNRWarningLevelExceeded;
outputCell{photonCountLoc,matrixValue+1} = photonsPerPixel;
outputCell{photonShotNoiseLoc,matrixValue+1} = photonShotNoiseRandom;
outputCell{inputRadianceLoc,matrixValue+1} = radianceMatrix(matrixValue);
outputCell{calculatedRadianceLoc,matrixValue+1} = radianceFromPower;
outputCell{calculatedRrsLoc,matrixValue+1} = calculatedRemoteSensingReflectance;

outputCell{calculatedRrsSLoc,matrixValue+1} = calculatedRemoteSensingReflectanceS;
outputCell{calculatedRrsDLoc,matrixValue+1} = calculatedRemoteSensingReflectanceD;
end

%Calculated chl concentration with quantization, noise, and atmospheric
%path radiance
%calculated from camera
calculatedRemoteSensingReflectance =[outputCell{calculatedRrsLoc,2},outputCell{calculatedRrsLoc,3}]
a_coeff=[.3255,-2.7677,2.4409,-1.1288,-.499]
log_10_chla= a_coeff(1)+a_coeff(2)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^1+a_coeff(3)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^2+a_coeff(4)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^3+a_coeff(5)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^4
chl_a_concentration_calculated = 10^(log_10_chla) %mg/m^3 or ug/L
outputCell{calculatedConcentration_Camera_OC4Loc,2} = chl_a_concentration_calculated;
%calculated from camera
calculatedRemoteSensingReflectance =[outputCell{calculatedRrsLoc,4},outputCell{calculatedRrsLoc,5}]
a_coeff=[.3255,-2.7677,2.4409,-1.1288,-.499]
log_10_chla= a_coeff(1)+a_coeff(2)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^1+a_coeff(3)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^2+a_coeff(4)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^3+a_coeff(5)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^4
chl_a_concentration_calculated = 10^(log_10_chla) %mg/m^3 or ug/L
outputCell{calculatedConcentration_Camera_OC4Loc,4} = chl_a_concentration_calculated;
%calculated from camera
calculatedRemoteSensingReflectance =[outputCell{calculatedRrsLoc,6},outputCell{calculatedRrsLoc,7}]
a_coeff=[.3255,-2.7677,2.4409,-1.1288,-.499]
log_10_chla= a_coeff(1)+a_coeff(2)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^1+a_coeff(3)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^2+a_coeff(4)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^3+a_coeff(5)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^4
chl_a_concentration_calculated = 10^(log_10_chla) %mg/m^3 or ug/L
outputCell{calculatedConcentration_Camera_OC4Loc,6} = chl_a_concentration_calculated;
%calculated from camera
calculatedRemoteSensingReflectance =[outputCell{calculatedRrsLoc,8},outputCell{calculatedRrsLoc,9}]
a_coeff=[.3255,-2.7677,2.4409,-1.1288,-.499]
log_10_chla= a_coeff(1)+a_coeff(2)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^1+a_coeff(3)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^2+a_coeff(4)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^3+a_coeff(5)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^4
chl_a_concentration_calculated = 10^(log_10_chla) %mg/m^3 or ug/L
outputCell{calculatedConcentration_Camera_OC4Loc,8} = chl_a_concentration_calculated;
%calculated from camera
calculatedRemoteSensingReflectance =[outputCell{calculatedRrsLoc,10},outputCell{calculatedRrsLoc,11}]
a_coeff=[.3255,-2.7677,2.4409,-1.1288,-.499]
log_10_chla= a_coeff(1)+a_coeff(2)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^1+a_coeff(3)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^2+a_coeff(4)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^3+a_coeff(5)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^4
chl_a_concentration_calculated = 10^(log_10_chla) %mg/m^3 or ug/L
outputCell{calculatedConcentration_Camera_OC4Loc,10} = chl_a_concentration_calculated;
%calculated from camera
calculatedRemoteSensingReflectance =[outputCell{calculatedRrsLoc,12},outputCell{calculatedRrsLoc,13}]
a_coeff=[.3255,-2.7677,2.4409,-1.1288,-.499]
log_10_chla= a_coeff(1)+a_coeff(2)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^1+a_coeff(3)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^2+a_coeff(4)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^3+a_coeff(5)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^4
chl_a_concentration_calculated = 10^(log_10_chla) %mg/m^3 or ug/L
outputCell{calculatedConcentration_Camera_OC4Loc,12} = chl_a_concentration_calculated;

%including shot noise (positive)
%calculated from camera
calculatedRemoteSensingReflectance =[outputCell{calculatedRrsSLoc,2},outputCell{calculatedRrsSLoc,3}]
a_coeff=[.3255,-2.7677,2.4409,-1.1288,-.499]
log_10_chla= a_coeff(1)+a_coeff(2)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^1+a_coeff(3)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^2+a_coeff(4)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^3+a_coeff(5)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^4
chl_a_concentration_calculated = 10^(log_10_chla) %mg/m^3 or ug/L
outputCell{calculatedChlaSLoc,2} = chl_a_concentration_calculated;
%calculated from camera
calculatedRemoteSensingReflectance = [outputCell{calculatedRrsSLoc,4},outputCell{calculatedRrsSLoc,5}];
a_coeff=[.3255,-2.7677,2.4409,-1.1288,-.499]
log_10_chla= a_coeff(1)+a_coeff(2)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^1+a_coeff(3)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^2+a_coeff(4)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^3+a_coeff(5)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^4
chl_a_concentration_calculated = 10^(log_10_chla) %mg/m^3 or ug/L
outputCell{calculatedChlaSLoc,4} = chl_a_concentration_calculated;
%calculated from camera
calculatedRemoteSensingReflectance =[outputCell{calculatedRrsSLoc,6},outputCell{calculatedRrsSLoc,7}]
a_coeff=[.3255,-2.7677,2.4409,-1.1288,-.499]
log_10_chla= a_coeff(1)+a_coeff(2)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^1+a_coeff(3)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^2+a_coeff(4)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^3+a_coeff(5)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^4
chl_a_concentration_calculated = 10^(log_10_chla) %mg/m^3 or ug/L
outputCell{calculatedChlaSLoc,6} = chl_a_concentration_calculated;
%calculated from camera
calculatedRemoteSensingReflectance =[outputCell{calculatedRrsSLoc,8},outputCell{calculatedRrsSLoc,9}]
a_coeff=[.3255,-2.7677,2.4409,-1.1288,-.499]
log_10_chla= a_coeff(1)+a_coeff(2)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^1+a_coeff(3)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^2+a_coeff(4)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^3+a_coeff(5)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^4
chl_a_concentration_calculated = 10^(log_10_chla) %mg/m^3 or ug/L
outputCell{calculatedChlaSLoc,8} = chl_a_concentration_calculated;
%calculated from camera
calculatedRemoteSensingReflectance =[outputCell{calculatedRrsSLoc,10},outputCell{calculatedRrsSLoc,11}]
a_coeff=[.3255,-2.7677,2.4409,-1.1288,-.499]
log_10_chla= a_coeff(1)+a_coeff(2)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^1+a_coeff(3)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^2+a_coeff(4)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^3+a_coeff(5)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^4
chl_a_concentration_calculated = 10^(log_10_chla) %mg/m^3 or ug/L
outputCell{calculatedChlaSLoc,10} = chl_a_concentration_calculated;
%calculated from camera
calculatedRemoteSensingReflectance =[outputCell{calculatedRrsSLoc,12},outputCell{calculatedRrsSLoc,13}]
a_coeff=[.3255,-2.7677,2.4409,-1.1288,-.499]
log_10_chla= a_coeff(1)+a_coeff(2)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^1+a_coeff(3)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^2+a_coeff(4)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^3+a_coeff(5)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^4
chl_a_concentration_calculated = 10^(log_10_chla) %mg/m^3 or ug/L
outputCell{calculatedChlaSLoc,12} = chl_a_concentration_calculated;

%including shot noise (negative)
%calculated from camera
calculatedRemoteSensingReflectance =[outputCell{calculatedRrsDLoc,2},outputCell{calculatedRrsDLoc,3}]
a_coeff=[.3255,-2.7677,2.4409,-1.1288,-.499]
log_10_chla= a_coeff(1)+a_coeff(2)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^1+a_coeff(3)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^2+a_coeff(4)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^3+a_coeff(5)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^4
chl_a_concentration_calculated = 10^(log_10_chla) %mg/m^3 or ug/L
outputCell{calculatedChlaDLoc,2} = chl_a_concentration_calculated;
%calculated from camera
calculatedRemoteSensingReflectance =[outputCell{calculatedRrsDLoc,4},outputCell{calculatedRrsDLoc,5}]
a_coeff=[.3255,-2.7677,2.4409,-1.1288,-.499]
log_10_chla= a_coeff(1)+a_coeff(2)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^1+a_coeff(3)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^2+a_coeff(4)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^3+a_coeff(5)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^4
chl_a_concentration_calculated = 10^(log_10_chla) %mg/m^3 or ug/L
outputCell{calculatedChlaDLoc,4} = chl_a_concentration_calculated;
%calculated from camera
calculatedRemoteSensingReflectance =[outputCell{calculatedRrsDLoc,6},outputCell{calculatedRrsDLoc,7}]
a_coeff=[.3255,-2.7677,2.4409,-1.1288,-.499]
log_10_chla= a_coeff(1)+a_coeff(2)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^1+a_coeff(3)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^2+a_coeff(4)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^3+a_coeff(5)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^4
chl_a_concentration_calculated = 10^(log_10_chla) %mg/m^3 or ug/L
outputCell{calculatedChlaDLoc,6} = chl_a_concentration_calculated;
%calculated from camera
calculatedRemoteSensingReflectance =[outputCell{calculatedRrsDLoc,8},outputCell{calculatedRrsDLoc,9}]
a_coeff=[.3255,-2.7677,2.4409,-1.1288,-.499]
log_10_chla= a_coeff(1)+a_coeff(2)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^1+a_coeff(3)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^2+a_coeff(4)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^3+a_coeff(5)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^4
chl_a_concentration_calculated = 10^(log_10_chla) %mg/m^3 or ug/L
outputCell{calculatedChlaDLoc,8} = chl_a_concentration_calculated;
%figure
%calculated from camera
calculatedRemoteSensingReflectance =[outputCell{calculatedRrsDLoc,10},outputCell{calculatedRrsDLoc,11}]
a_coeff=[.3255,-2.7677,2.4409,-1.1288,-.499]
log_10_chla= a_coeff(1)+a_coeff(2)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^1+a_coeff(3)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^2+a_coeff(4)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^3+a_coeff(5)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^4
chl_a_concentration_calculated = 10^(log_10_chla) %mg/m^3 or ug/L
outputCell{calculatedChlaDLoc,10} = chl_a_concentration_calculated;
%figure
%calculated from camera
calculatedRemoteSensingReflectance =[outputCell{calculatedRrsDLoc,12},outputCell{calculatedRrsDLoc,13}]
a_coeff=[.3255,-2.7677,2.4409,-1.1288,-.499]
log_10_chla= a_coeff(1)+a_coeff(2)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^1+a_coeff(3)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^2+a_coeff(4)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^3+a_coeff(5)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^4
chl_a_concentration_calculated = 10^(log_10_chla) %mg/m^3 or ug/L
outputCell{calculatedChlaDLoc,12} = chl_a_concentration_calculated;
figure


chlaOC4_including_path_and_binary=[outputCell{calculatedConcentration_Camera_OC4Loc,2},outputCell{calculatedConcentration_Camera_OC4Loc,4},outputCell{calculatedConcentration_Camera_OC4Loc,6},outputCell{calculatedConcentration_Camera_OC4Loc,8},outputCell{calculatedConcentration_Camera_OC4Loc,10},outputCell{calculatedConcentration_Camera_OC4Loc,12}]
chlaOC4_ed_and_Lu=[outputCell{calculatedConcentration_OC4Loc,2},outputCell{calculatedConcentration_OC4Loc,4},outputCell{calculatedConcentration_OC4Loc,6},outputCell{calculatedConcentration_OC4Loc,8},outputCell{calculatedConcentration_OC4Loc,10},outputCell{calculatedConcentration_OC4Loc,12}]
x=[.01,5,10,1,.1,.5]
errorBarSizeUp=[(outputCell{calculatedConcentration_Camera_OC4Loc,2}-outputCell{calculatedChlaSLoc,2}),(outputCell{calculatedConcentration_Camera_OC4Loc,4}-outputCell{calculatedChlaSLoc,4}),(outputCell{calculatedConcentration_Camera_OC4Loc,6}-outputCell{calculatedChlaSLoc,6}),(outputCell{calculatedConcentration_Camera_OC4Loc,8}-outputCell{calculatedChlaSLoc,8}),(outputCell{calculatedConcentration_Camera_OC4Loc,10}-outputCell{calculatedChlaSLoc,10}),(outputCell{calculatedConcentration_Camera_OC4Loc,12}-outputCell{calculatedChlaSLoc,12})]
errorBarSizeDown = [(outputCell{calculatedConcentration_Camera_OC4Loc,2}-outputCell{calculatedChlaDLoc,2}),(outputCell{calculatedConcentration_Camera_OC4Loc,4}-outputCell{calculatedChlaDLoc,4}),(outputCell{calculatedConcentration_Camera_OC4Loc,6}-outputCell{calculatedChlaDLoc,6}),(outputCell{calculatedConcentration_Camera_OC4Loc,8}-outputCell{calculatedChlaDLoc,8}),(outputCell{calculatedConcentration_Camera_OC4Loc,10}-outputCell{calculatedChlaDLoc,10}),(outputCell{calculatedConcentration_Camera_OC4Loc,12}-outputCell{calculatedChlaDLoc,12})]
HNew=scatter(x(2:6),chlaOC4_ed_and_Lu(2:6),36,'filled', 'LineWidth',15)
set(gca,'xscale','log')
set(gca,'yscale','log')
%keyboard %dbcont
hold on
%ENew=errorbar(x(2:6),chlaOC4_including_path_and_binary(2:6),errorBarSizeUp(2:6),errorBarSizeDown(2:6),'vertical','o')
%keyboard %dbcont
set(HNew,'SizeData', 100)
%set(ENew,'MarkerSize', 10,'MarkerFaceColor', [0 1 1], ...
%    'MarkerEdgeColor', [0 .5 0])
%errorbar_tick(ENew, 30);
%scatter(x,chlaOC4_including_shot_and_path_and_binary)
hold off
xlabel('Measured Concentration of Chl a (\mug/L)','FontSize', 24)
ylabel('Simulated Concentration of Chl a  (\mug/L)','FontSize', 24)
%title('Saturation of Full Well Capacity at 550 nm as a Function of Exposure Time')
%h_legend=legend('Without noise and environmental effects','With noise and environmental effects')
%set(h_legend,'FontSize',12);
%axis([-.1 12 -1 10])

title('OC4 Calculated Chl A Concentration: Ideal Case')%; 'with Noise and Environmental Factors'},'FontSize', 18)

%APE_Noise = (chlaOC4_including_path_and_binary-chlaOC4_ed_and_Lu)./chlaOC4_ed_and_Lu*100
%APE_Path = (chlaOC4_including_path_and_binary-chlaOC4_ed_and_Lu)./chlaOC4_ed_and_Lu*100
%APE_PSNU = (errorBarSizeUp)./chlaOC4_ed_and_Lu*100
%APE_PSNL = (errorBarSizeDown)./chlaOC4_ed_and_Lu*100
 set(gca,'fontsize',13) 
 
hline = refline([1 0]);
hline.Color = 'r';
%%
%capturedElectrons=[outputCell{4,2},outputCell{4,3}]
totalSignalAsBits = round(electronsPerPixel/electronsPerCount)
bitsToElectrons = round(totalSignalAsBits*electronsPerCount)
electronsToPhotons = bitsToElectrons/quantumEfficiency(1)
outputCell{countedPhotonLoc,matrixValue+1} = electronsToPhotons(matrixValue);
calculatedEnergyPerPixel= energyOfAPhoton*electronsToPhotons
calculatedPowerPerPixel = calculatedEnergyPerPixel/exposure
radianceFromPower = calculatedPowerPerPixel/(stationaryResolution/10000*transmissionCoefficient/100*opticalElementEfficiency*pi*diameterOfAperture^2/(4*altitude^2)*filterBandwidth)
calculatedRemoteSensingReflectance = [radianceFromPower(1)/downwellingIrradiance_30(1),radianceFromPower(2)/downwellingIrradiance_30(2)] %440/550

%%

a_coeff=[.3255,-2.7677,2.4409,-1.1288,-.499]
log_10_chla= a_coeff(1)+a_coeff(2)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^1+a_coeff(3)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^2+a_coeff(4)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^3+a_coeff(5)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^4
chl_a_concentration_calculated = 10^(log_10_chla) %mg/m^3 or ug/L
%calculate the chlorophyll concentration from the input radiances
%%
% plotting the errors
load('Errors saved as APE.mat')
x=[.01,5,10,1,.1,.5]
figure


x_reorder = x(:, [ 1 5 6 4 2 3])
HNew=scatter(x(2:6),APE_PSNU(2:6),36,'filled', 'LineWidth',15) %1 5 6 4 2 3 
hold on

HNew2=scatter(x(2:6),APE_PSNL(2:6),36,'filled', 'LineWidth',15)

%plot(x,APE_PSNL,'-x')
HNew3=scatter(x(2:6),APE_Path(2:6),36,'filled', 'LineWidth',15)

HNew4=scatter(x(2:6),APE_Noise(2:6),36,'filled', 'LineWidth',15)


plot(x_reorder(2:6),APE_PSNU(:,[  5 6 4 2 3]),'b','LineWidth',1.5)

plot(x_reorder(2:6),APE_PSNL(:,[  5 6 4 2 3]),'Color', [1 .3 0],'LineWidth',1.5)

plot(x_reorder(2:6),APE_Path(:,[  5 6 4 2 3]), 'Color', [.9 .7 0],'LineWidth',1.5)

plot(x_reorder(2:6),APE_Noise(:,[  5 6 4 2 3]), 'Color', [.5 0 0.9],'LineWidth',1.5)

%set(gca,'xscale','log')
%set(gca,'yscale','log')
%hold on
set(HNew,'SizeData', 150)
set(HNew2,'SizeData', 150)
set(HNew3,'SizeData', 150)
set(HNew4,'SizeData', 150)
%set(ENew,'MarkerSize', 10,'MarkerFaceColor', [0 1 1], ...
%    'MarkerEdgeColor', [0 .5 0])
hold off
xlabel('Measured Concentration of Chl a (\mug/L)','FontSize', 24)
ylabel('Percent Error from Ideal Case','FontSize', 24)
h_legend=legend('Photon shot noise (upper 95%)','Photon shot noise (lower 95%)','Atmospheric path radiance','Camera noise and quantization')
set(h_legend,'FontSize',11);
title({'Effects of Path Radiance and Camera Noise' ;'Sources on Calculated Chl Concentration'},'FontSize', 18)
set(gca,'xscale','log')
hline = refline([0 0]);
hline.Color = 'k';
 set(gca,'fontsize',13) 
