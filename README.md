

<html><body><div class="content"><h1>IERS4m</h1><p>These classes facilitates the CIO based celestial to terrestrial transformation. The main function is GCRS2ITRS which provides the 3x3 celestial to terrestrial transformation matrix. In order to obtain the necessary EOP information use helper object USNO.m.</p><p>There is a detailed writeup (docs/README.pdf) which explains this transformation in more detail as well as explains the matrix formulation implemented in MATLAB. Most relevant references are listed in the References section below.  Select papers are avaliable in the docs/refs folder.</p><p>Default 2010 IERS convention.</p><h2>Contents</h2><div><ul><li><a href="#1">Example Usage</a></li><li><a href="#2">Notes on Transforming Velocity and Acceleration</a></li><li><a href="#4">References</a></li></ul></div><h2>Example Usage<a name="1"></a></h2><p>This example is taken from David Vallado's paper listed in the References section.</p><pre class="codeinput"><span class="comment">% date time UTC: 2004/04/06 07:51:28.386</span>
fMJD_UTC = 53101.3274118751;

<span class="comment">% init EOP object</span>
eopobj = USNO();

<span class="comment">% pull latest EOP data from USNO servers</span>
eopobj = eopobj.initWithFinalsHttp();

<span class="comment">% interpolate EOP information for date and time</span>
[xp,yp,du,dt] = eopobj.getEOP(fMJD_UTC);

<span class="comment">% Vallado et al. 2006, AIAA                        [meters]</span>
X_itrs = [-1033.4793830, 7901.2952754, 6380.3565958]';

<span class="comment">% dx,dy = 0                                        [meters]</span>
X_gcrs = [5102.5089592, 6123.0114033, 6378.1369247]';

<span class="comment">% compute the 3x3 transformation matrix</span>
GC2IT = IERS.GCRS2ITRS(fMJD_UTC,dt,du,xp,yp);

<span class="comment">% perform the coordinate/position conversion: C -&gt; T</span>
X = GC2IT*X_gcrs;

<span class="comment">% compute the error in meters</span>
err = sum(sqrt((X-X_itrs).^2))
</pre><pre class="codeoutput">
err =

0.00038976917267064

</pre><h2>Notes on Transforming Velocity and Acceleration<a name="2"></a></h2><p>Use IERS.wrot(w,GC2IT) to if velocity and accelerations are present to account for the relative rotation of the inertial and noninertial frames. Generally speaking can simply use the nominal earth rotation rate in radians per second (IERS.DS2R).</p><pre class="codeinput"><span class="comment">% define earth rotation rate in radians per second about the z-axis (GCRS -&gt; ITRS)</span>
w = [0,0,IERS.DS2R];

<span class="comment">% expand to 9x9 matrix to accomodate X = [pos, vel, acc]</span>
GC2IT = IERS.wrot(w,GC2IT);

<span class="comment">% reduce transformation matrix to 6x6 for state vectors of position and velocity</span>
GC2IT = GC2IT(1:6,1:6);
</pre><p>Finally keep in mind that when going in the opposite direction from ITRS to GCRS, the rotation is in the opposite direction and thus must negate the z-axis rotation rate so that w = [0,0,-IERS.DS2R];</p><h2>References<a name="4"></a></h2><pre>  IERS 2010
www.iers.org/IERS/EN/Publications/TechnicalNotes/tn36.html</pre><pre>  IERS 2003
www.iers.org/IERS/EN/Publications/TechnicalNotes/tn32.html</pre><pre>  IERS FTP
ftp://tai.bipm.org/iers/conv2010/chapter5/
ftp://maia.usno.navy.mil/conv2010/chapter5/</pre><pre>  SOFA Library</pre><pre>    Main:
http://www.iausofa.org</pre><pre>    Time Reference Cookbook:
http://www.iausofa.org/2012_0301_C/sofa/sofa_ts_c.pdf</pre><pre>    Validation Routines:</pre><pre>      C:
http://www.iausofa.org/2012_0301_C/sofa/t_sofa_c.c</pre><pre>      FORTRAN:
http://www.iausofa.org/2012_0301_F/sofa/t_sofa_f.for</pre><pre>    Tutorial:
www.iausofa.org/publications/sofa_pn.pdf</pre><pre>    NOVAS Comparison:
www.dtic.mil/cgi-bin/GetTRDoc?AD=ADA543243</pre><pre>  David Vallado, Seago J., Seidelmann P., Implementation Issues
Surrounding the New IAU Reference Systems for Astrodynamics,
AIAA, AAS 06-134, 2006</pre><p class="footer"><br><a href="http://www.mathworks.com/products/matlab/">Published with MATLAB&reg; R2015a</a><br></p></div></body></html>