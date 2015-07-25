

<html><head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>IERS4m</title>
<meta name="generator" content="MATLAB 8.5">
<link rel="schema.DC" href="http://purl.org/dc/elements/1.1/">
<meta name="DC.date" content="2015-07-25"><meta name="DC.source" content="Example.m"><style type="text/css">
html,body,div,span,applet,object,iframe,h1,h2,h3,h4,h5,h6,p,blockquote,pre,a,abbr,acronym,address,big,cite,code,del,dfn,em,font,img,ins,kbd,q,s,samp,small,strike,strong,sub,sup,tt,var,b,u,i,center,dl,dt,dd,ol,ul,li,fieldset,form,label,legend,table,caption,tbody,tfoot,thead,tr,th,td{margin:0;padding:0;border:0;outline:0;font-size:100%;vertical-align:baseline;background:transparent}body{line-height:1}ol,ul{list-style:none}blockquote,q{quotes:none}blockquote:before,blockquote:after,q:before,q:after{content:'';content:none}:focus{outine:0}ins{text-decoration:none}del{text-decoration:line-through}table{border-collapse:collapse;border-spacing:0}

html { min-height:100%; margin-bottom:1px; }
html body { height:100%; margin:0px; font-family:Arial, Helvetica, sans-serif; font-size:10px; color:#000; line-height:140%; background:#fff none; overflow-y:scroll; }
html body td { vertical-align:top; text-align:left; }

h1 { padding:0px; margin:0px 0px 25px; font-family:Arial, Helvetica, sans-serif; font-size:1.5em; color:#d55000; line-height:100%; font-weight:normal; }
h2 { padding:0px; margin:0px 0px 8px; font-family:Arial, Helvetica, sans-serif; font-size:1.2em; color:#000; font-weight:bold; line-height:140%; border-bottom:1px solid #d6d4d4; display:block; }
h3 { padding:0px; margin:0px 0px 5px; font-family:Arial, Helvetica, sans-serif; font-size:1.1em; color:#000; font-weight:bold; line-height:140%; }

a { color:#005fce; text-decoration:none; }
a:hover { color:#005fce; text-decoration:underline; }
a:visited { color:#004aa0; text-decoration:none; }

p { padding:0px; margin:0px 0px 20px; }
img { padding:0px; margin:0px 0px 20px; border:none; }
p img, pre img, tt img, li img, h1 img, h2 img { margin-bottom:0px; } 

ul { padding:0px; margin:0px 0px 20px 23px; list-style:square; }
ul li { padding:0px; margin:0px 0px 7px 0px; }
ul li ul { padding:5px 0px 0px; margin:0px 0px 7px 23px; }
ul li ol li { list-style:decimal; }
ol { padding:0px; margin:0px 0px 20px 0px; list-style:decimal; }
ol li { padding:0px; margin:0px 0px 7px 23px; list-style-type:decimal; }
ol li ol { padding:5px 0px 0px; margin:0px 0px 7px 0px; }
ol li ol li { list-style-type:lower-alpha; }
ol li ul { padding-top:7px; }
ol li ul li { list-style:square; }

.content { font-size:1.2em; line-height:140%; padding: 20px; }

pre, code { font-size:12px; }
tt { font-size: 1.2em; }
pre { margin:0px 0px 20px; }
pre.codeinput { padding:10px; border:1px solid #d3d3d3; background:#f7f7f7; }
pre.codeoutput { padding:10px 11px; margin:0px 0px 20px; color:#4c4c4c; }
pre.error { color:red; }

@media print { pre.codeinput, pre.codeoutput { word-wrap:break-word; width:100%; } }

span.keyword { color:#0000FF }
span.comment { color:#228B22 }
span.string { color:#A020F0 }
span.untermstring { color:#B20000 }
span.syscmd { color:#B28C00 }

.footer { width:auto; padding:10px 0px; margin:25px 0px 0px; border-top:1px dotted #878787; font-size:0.8em; line-height:140%; font-style:italic; color:#878787; text-align:left; float:none; }
.footer p { margin:0px; }
.footer a { color:#878787; }
.footer a:hover { color:#878787; text-decoration:underline; }
.footer a:visited { color:#878787; }

table th { padding:7px 5px; text-align:left; vertical-align:middle; border: 1px solid #d6d4d4; font-weight:bold; }
table td { padding:7px 5px; text-align:left; vertical-align:top; border:1px solid #d6d4d4; }





</style></head><body><div class="content"><h1>IERS4m</h1><p>These classes facilitates the CIO based celestial to terrestrial transformation. The main function is GCRS2ITRS which provides the 3x3 celestial to terrestrial transformation matrix. In order to obtain the necessary EOP information use helper object USNO.m.</p><p>There is a detailed write up in the docs/latex folder which explains this transformation in detail as well as explains the matrix formulation implemented in MATLAB. All relevant references are listed in the References section.  Select papers are avaliable in the docs/refs folder.</p><p>Default 2010 IERS convention.</p><h2>Contents</h2><div><ul><li><a href="#1">Example Usage</a></li><li><a href="#2">Notes on Transforming Velocity and Acceleration</a></li><li><a href="#4">References</a></li></ul></div><h2>Example Usage<a name="1"></a></h2><p>This example is taken from David Vallado's paper listed in the References section.</p><pre class="codeinput"><span class="comment">% date time UTC: 2004/04/06 07:51:28.386</span>
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