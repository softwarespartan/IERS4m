%% IERS4m 
% These classes facilitates the CIO based celestial to terrestrial transformation. 
% The main function is GCRS2ITRS which provides the 3x3 celestial to terrestrial transformation matrix.  
% In order to obtain the necessary EOP information use helper object USNO.m.  
%
% There is a detailed write up in the docs/latex folder which explains this transformation in detail as well as explains the matrix formulation implemented in MATLAB.  
% All relevant references are listed in the References section.  Select papers are avaliable in the docs/refs folder. 
%
% Default 2010 IERS convention.
%
%% Example Usage
% This example is taken from David Vallado's paper listed in the References section.  

% date time UTC: 2004/04/06 07:51:28.386
fMJD_UTC = 53101.3274118751;

% init EOP object
eopobj = USNO(); 

% pull latest EOP data from USNO servers
eopobj = eopobj.initWithFinalsHttp(); 

% interpolate EOP information for date and time
[xp,yp,du,dt] = eopobj.getEOP(fMJD_UTC);

% Vallado et al. 2006, AIAA                        [meters]
X_itrs = [-1033.4793830, 7901.2952754, 6380.3565958]';

% dx,dy = 0                                        [meters]
X_gcrs = [5102.5089592, 6123.0114033, 6378.1369247]';

% compute the 3x3 transformation matrix
GC2IT = IERS.GCRS2ITRS(fMJD_UTC,dt,du,xp,yp);

% perform the coordinate/position conversion: C -> T
X = GC2IT*X_gcrs;

% compute the error in meters
err = sum(sqrt((X-X_itrs).^2))

%% Notes on Transforming Velocity and Acceleration
% Use IERS.wrot(w,GC2IT) to if velocity and accelerations are present to account for the relative rotation of the inertial and noninertial frames.  
% Generally speaking can simply use the nominal earth rotation rate in radians per second (IERS.DS2R).
%

% define earth rotation rate in radians per second about the z-axis (GCRS -> ITRS)
w = [0,0,IERS.DS2R];

% expand to 9x9 matrix to accomodate X = [pos, vel, acc]
GC2IT = IERS.wrot(w,GC2IT);

% reduce transformation matrix to 6x6 for state vectors of position and velocity
GC2IT = GC2IT(1:6,1:6);

%%
% Finally keep in mind that when going in the opposite direction from ITRS to GCRS, the rotation is in the opposite direction and thus must negate the z-axis rotation rate so that w = [0,0,-IERS.DS2R];

%%  References
%
%    IERS 2010 
%      www.iers.org/IERS/EN/Publications/TechnicalNotes/tn36.html
%
%    IERS 2003
%      www.iers.org/IERS/EN/Publications/TechnicalNotes/tn32.html
%
%    IERS FTP
%      ftp://tai.bipm.org/iers/conv2010/chapter5/
%      ftp://maia.usno.navy.mil/conv2010/chapter5/
%
%    SOFA Library
%      
%      Main:  
%        http://www.iausofa.org
%
%      Time Reference Cookbook:
%        http://www.iausofa.org/2012_0301_C/sofa/sofa_ts_c.pdf
%
%      Validation Routines:
%        
%        C:
%          http://www.iausofa.org/2012_0301_C/sofa/t_sofa_c.c
%
%        FORTRAN:
%          http://www.iausofa.org/2012_0301_F/sofa/t_sofa_f.for
%        
%      Tutorial:
%        www.iausofa.org/publications/sofa_pn.pdf
%
%      NOVAS Comparison:
%        www.dtic.mil/cgi-bin/GetTRDoc?AD=ADA543243
%
%
%    David Vallado, Seago J., Seidelmann P., Implementation Issues 
%     Surrounding the New IAU Reference Systems for Astrodynamics, 
%     AIAA, AAS 06-134, 2006
%
%