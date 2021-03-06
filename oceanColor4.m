function chlConcentration=oceanColor4(inputMatrix,waterLeavingRadianceLocation,downwellingIrradianceLocation,calculatedConcentration_OC4Loc,outputCell,location,calculatedRrsMatrix,shotNoise,ideal)
    if(ideal==1)
        remoteSensingReflectance = [inputMatrix(location,waterLeavingRadianceLocation)/inputMatrix(location,downwellingIrradianceLocation),inputMatrix(location+1,waterLeavingRadianceLocation)/inputMatrix(location+1,downwellingIrradianceLocation)] %440/550
        a_coeff=[.3255,-2.7677,2.4409,-1.1288,-.499]
        log_10_chla= a_coeff(1)+a_coeff(2)*log10(remoteSensingReflectance(1)/remoteSensingReflectance(2))^1+a_coeff(3)*log10(remoteSensingReflectance(1)/remoteSensingReflectance(2))^2+a_coeff(4)*log10(remoteSensingReflectance(1)/remoteSensingReflectance(2))^3+a_coeff(5)*log10(remoteSensingReflectance(1)/remoteSensingReflectance(2))^4
        chl_a_concentration = 10^(log_10_chla) %mg/m^3 or ug/L
        chlConcentration=chl_a_concentration;
    else
        calculatedRemoteSensingReflectance =[calculatedRrsMatrix(location,shotNoise),calculatedRrsMatrix(location+1,shotNoise)]
        a_coeff=[.3255,-2.7677,2.4409,-1.1288,-.499]
        log_10_chla= a_coeff(1)+a_coeff(2)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^1+a_coeff(3)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^2+a_coeff(4)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^3+a_coeff(5)*log10(calculatedRemoteSensingReflectance(1)/calculatedRemoteSensingReflectance(2))^4
        chl_a_concentration_calculated = 10^(log_10_chla) %mg/m^3 or ug/L
        chlConcentration= chl_a_concentration_calculated;
    end
end
