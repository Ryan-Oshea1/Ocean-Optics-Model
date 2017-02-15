function oceanColor4(inputMatrix)

remoteSensingReflectance = [inputMatrix(1,waterLeavingRadianceLocation)/inputMatrix(1,downwellingIrradianceLocation),inputMatrix(2,waterLeavingRadianceLocation)/inputMatrix(2,downwellingIrradianceLocation)] %440/550
a_coeff=[.3255,-2.7677,2.4409,-1.1288,-.499]
log_10_chla= a_coeff(1)+a_coeff(2)*log10(remoteSensingReflectance(1)/remoteSensingReflectance(2))^1+a_coeff(3)*log10(remoteSensingReflectance(1)/remoteSensingReflectance(2))^2+a_coeff(4)*log10(remoteSensingReflectance(1)/remoteSensingReflectance(2))^3+a_coeff(5)*log10(remoteSensingReflectance(1)/remoteSensingReflectance(2))^4
chl_a_concentration = 10^(log_10_chla) %mg/m^3 or ug/L
outputCell{calculatedConcentration_OC4Loc,2} = chl_a_concentration;

end
