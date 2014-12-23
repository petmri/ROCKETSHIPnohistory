function [newIMG, scaleSlope, scaleIntercept] = double2uint16Scale(IMG)

% Prep image to store as DICOM

uint16max = 65535;

scaleIntercept = min(IMG(:));

scaleSlope     = (max(IMG(:))-scaleIntercept)/uint16max;

% Convert IMG to "uint16" space

newIMG = (IMG-scaleIntercept)./scaleSlope;

newIMG = uint16(newIMG);
