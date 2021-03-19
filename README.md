# FilmProtocol
Protocol & scripts for plotting calibration curves and beam profiles from film with MATLAB &amp; ImageJ

Written by Jacinta Yap (April, 2019), revised Mar 2021 (yapjacinta@gmail.com)

This was developed for general film analysis at the Clatterbridge Cancer Centre, UK, 60 MeV proton therapy beamline. Any settings specific to the facility (i.e. scanner dpi, zero value and pixel range) can be easily modified within the code.

These scripts will automate the generation of a calibration curve, fit and beam profile plots for irradiated Gafchromic film. This material has been fully documented and is developed into a package for self-directe: please read the PDF for how to use these scripts. 

This repository contains the following:

- **FilmProtocol_MATLAB_ImageJ_JYAP** (user guide)
- **MatlabScripts**
  - CalibrationODtoDose, PlotProfileofScannedFilmWithOD, CalibrationGreen, CalibrationBlue
- **Examples**
  - CalibrationCurve.png
  - red, green, blue .txt files
  - F2 & F8 (.tif scans, .txt film pixel files and .png corresponding generated profiles)
- **2018_CCC_Calibration_FilmScans**
  - .tif scans of beam spots of varying doses

<br />
<p float="left">
<img src="https://github.com/jacyap/FilmProtocol/blob/main/Examples/F2_19-Mar-2021.png" width="500"/> 
<img src="https://github.com/jacyap/FilmProtocol/blob/main/Examples/19-Mar-2021_CalibrationCurve.png" width="400"/>
</p>
