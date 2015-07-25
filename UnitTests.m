classdef UnitTests < matlab.unittest.TestCase 
%
% Tests consistent with 
%
%      IERS/XYS200A.F
%
%      SOFA/t_sofa_c.c
%
%      www.iausofa.org/publications/sofa_pn.pdf
%
% SEE ALSO:
%
%      www.dtic.mil/cgi-bin/GetTRDoc?AD=ADA543243
%    
    methods(Test)
        
        % IERS
        
        function test_F_1    (testCase) 
            
            % set the time to test (Julian centuries)
            t = 0.80;
            
            % call the function to test
            f = IERS.F(t);
            
            % the answer we should get
            f_truth = [
                     5.132369751108684150
                     6.226797973505507345
                     0.259771136674549952
                     1.946709205396925672
                    -5.973618440951302183
                     5.417338184297289661     % L_Me/Fame
                     3.424900460533758000     % L_Ve/Fave
                     1.744713738913081846     % L_E /Fae
                     3.275506840277781492     % L_Ma/Fama
                     5.275711665202481138     % L_J /Faju
                     5.371574539440827046     % L_Sa/Fasa
                     5.180636450180413523     % L_Ur/Faur
                     2.079343830860413523     % L_Ne/Fane
                     0.019508847622400000     % pA  /Fapa                     
            ]';
            
            % verify results
            testCase.verifyEqual(f_truth,f,'AbsTol',1e-12, ...
                'Failed to verify fundamental arguments of nutation theory to 1e-12');
        end
        
        function test_F_2    (testCase) 
            
            % set the time to test (Julian centuries)
            t = 0.06;
            
            % call the function to test
            f = IERS.F(t);
            
            % the answer we should get
            f_truth = [
                      -0.57778273127681334     
                      -4.4119722715031173E-002
                      -1.30213560757813520     
                       0.24219717463294721     
                       0.15701656982037315     
                      -2.43279029522521740     
                       1.62400690247012850     
                       1.75281357086847580     
                       1.11441424448165450     
                      -2.50549303433358620     
                       2.15381138676000020     
                      -0.35320184377758590     
                      -0.74250080635158611     
                       1.4629243928760000E-003                        
            ]';
        
        
            % normalize between +- pi
            indx = abs(f)>pi; f(indx) = f(indx) - 2*pi*sign(f(indx));
        
            % verify 
            testCase.verifyEqual(f_truth,f,'AbsTol',1e-12, ...
                'Failed to verify fundamental arguments of nutation theory to 1e-12');
        end
        
        function test_XYs_3  (testCase) 
            
            %
            % FORTRAN Example from:
            %
            %  http://www.iausofa.org/publications/sofa_pn.pdf
            %
            
            % the time to test (fMJD referenced to TT)
            t = 54195.500754444445;
            
            % perform the series calculation
            [X,Y,s] = IERS.XYs(t);
            
            % verify [IAU 2006/2000A]
        
            testCase.verifyEqual(X,7.1226388110126224E-004,'AbsTol',1e-16, ...
                'Failed to verify XYs::X to 1e-16');
            
            testCase.verifyEqual(Y,4.4386344068802927E-005,'AbsTol',1e-16, ...
                'Failed to verify XYs::Y to 1e-16');
            
            testCase.verifyEqual(s,-1.0668203203684658E-008,'AbsTol',1e-9, ...
                'Failed to verify XYs::s to 1e-9');
        end
        
        function test_XYs_1  (testCase) 
            
            % the time to test (MJD referenced to UTC)
            t = 53736.0;
                        
            % perform the series calculation
            [X,Y,s] = IERS.XYs(t);
            
            % the answer should be [IERS 2010]
            XYs_truth = [
                          0.000579130848670601
                          0.000040205798167330
                         -0.000000012044040930
            ]';
            
            testCase.verifyEqual([X,Y,s], XYs_truth,'AbsTol',1e-15, ...
                'Failed to verify XYs [IERS 2010] to 1e-15');
            
        end
        
        function test_ERA_1  (testCase) 
            
            % time MJD to test at
            t = 54388.0; du = 0;
            
            % the rotation angle should be
            theta_truth = 0.4022837240028158102;
            
            % compute the earth rotation angle
            theta = IERS.ERA(t,du);
            
            % verify 
            testCase.verifyEqual(theta,theta_truth,'AbsTol',1e-14, ...
                'Failed to verify earth rotation angle (ERA) to 1e-14');
            
        end
        
        function test_ERA_2  (testCase) 
            
            %
            % FORTRAN Example from:
            %
            %  http://www.iausofa.org/publications/sofa_pn.pdf
            %
            
            % set the MJD epoch and UTC-UT1 offset
            t = 54195.5; dut = -0.072073685;
            
            % the answer should be 
            theta_truth = 0.23245155366208792;
            
            % compute the earth rotation angle
            theta = IERS.ERA(t,dut);
            
            % verify 
            testCase.verifyEqual(theta,theta_truth,'AbsTol',1e-14, ...
                'Failed to verify earth rotation angle (ERA) to 1e-16 [radians]');
            
        end
        
        function test_SP00_1 (testCase) 
            
            % set the time to test
            t = 52541.0;
            
            % the value should be
            sp00_truth = -0.6216698469981019309e-11;
            
            % compute the locator
            sp00 = IERS.SP00(t);
            
            % verify 
            testCase.verifyEqual(sp00,sp00_truth,'AbsTol',1e-12, ...
                'Failed to verify TIO locator to 1e-12 [radians]');
        end
        
        function test_SP00_2 (testCase) 
            
            %
            % FORTRAN Example from:
            %
            %  http://www.iausofa.org/publications/sofa_pn.pdf
            %
            
            % set the time to test
            t = 54195.500754444445;
            
            % the value should be
            sp00_truth = -1.6538356582110697E-011;
            
            % compute the locator
            sp00 = IERS.SP00(t);
            
            % verify 
            testCase.verifyEqual(sp00,sp00_truth,'AbsTol',1e-12, ...
                'Failed to verify TIO locator to 1e-16 [radians]');
        end
        
        function test_C2I_1  (testCase) 
            
            X =  0.5791308486706011000e-3;
            Y =  0.4020579816732961219e-4;
            s = -0.1220040848472271978e-7;
    
            % should get ...
            C_truth = [
                0.9999998323037157138      0.5581984869168499149e-9  -0.5791308491611282180e-3;
                -0.2384261642670440317e-7  0.9999999991917468964     -0.4020579110169668931e-4;
                0.5791308486706011000e-3   0.4020579816732961219e-4   0.9999998314954627590   ;
            ];
            
            % compute xformation matrix
            C = IERS.C2I(X,Y,s);
            
            % verify 
            testCase.verifyEqual(C,C_truth,'AbsTol',1e-12, ...
                'Failed to verify celestial-to-intermediate matrix to 1e-12');
        end
        
        function test_POM00_1(testCase) 
            
            % set the test input values
            xp =  2.55060238e-7 ;
            yp =  1.860359247e-6;
            sp = -0.1367174580728891460e-10;
            
            % compute the polar motion matrix
            P = IERS.POM00(xp,yp,sp);
            
            % the answer should be 
            P_truth = [
                0.9999999999999674721     -0.1367174580728846989e-10   0.2550602379999972345e-6 ;
                0.1414624947957029801e-10  0.9999999999982695317      -0.1860359246998866389e-5 ;
               -0.2550602379741215021e-6   0.1860359247002414021e-5    0.9999999999982370039    ;  
            ];
        
            % verify
            testCase.verifyEqual(P,P_truth,'AbsTol',1e-12, ...
                'Failed to verify polar motion matrix from TIRS -> ITRS to 1e-12');
        end
        
        function test_POM00_2(testCase) 
           
            %
            % FORTRAN Example from:
            %
            %  http://www.iausofa.org/publications/sofa_pn.pdf
            %
            
            xp = 1.6933669216530094E-007;
            yp = 2.3431835454324080E-006;
            sp = -1.653835658211070e-11 ;
            
            % the answer should be
            P_truth = [
                       0.99999999999998568      ...       
                      -1.6538356582110461E-011  ... 
                       1.6933669216530012E-007; ...
                       1.6935143532784618E-011  ...
                       0.99999999999725475      ... 
                      -2.3431835454302303E-006; ...
                      -1.6933669212608286E-007  ...  
                       2.3431835454330644E-006  ...
                       0.99999999999724043      ...
            ];
        
            % comput the polar motion matrix
            P = IERS.POM00(xp,yp,sp);
            
            % verify
            testCase.verifyEqual(P,P_truth,'AbsTol',1e-12, ...
                'Failed to verify polar motion matrix from TIRS -> ITRS to 1e-16');
            
        end
        
        function test_GC2IT_1(testCase) 
            
            % set the date [UTC]
            MJD  = 53101;
            
            % set the time [UTC]
            hour = 7; min = 51;  sec = 28.386009;

            % compute the seconds of day
            sod  = hour*3600 + min*60 + sec;

            % EOP information 
            xp = -0.140682;  yp =  0.333309;  du = -0.439962; dt = 32;

            % compute the date+time
            fMJD_UTC = MJD +  sod/86400;

            % Vallado et al. 2006, AIAA NOTE: using IERS 2003~ [meters]
            X_itrs = [-1033.4793830, 7901.2952754, 6380.3565958]';

            % dx,dy = 0                                        [meters]
            X_gcrs = [5102.5089592, 6123.0114033, 6378.1369247]';

            % compute the xformation matrix
            GC2IT = IERS.GCRS2ITRS(fMJD_UTC,dt,du,xp,yp);

            % perform the transformation
            X = GC2IT*X_gcrs;

            % verify
            testCase.verifyEqual(X,X_itrs,'AbsTol',1e-2, ...
                'Failed to verify GCRS2ITRS coordinate transformation to 1e-2');
        end
        
        function test_dXdY_1 (testCase) 
            
            % set the epoch to test MJD ref to TT
            t = 54790.0;

            % the answer should be [radians]
            dX_truth = (-176.04435313062450060./1e6)*IERS.AS2R;
            dY_truth = ( -93.62265658430092685./1e6)*IERS.AS2R; 
            
            % compute the CIO corrections
            [dX,dY] = IERS.dXdY(t);
            
            % make sure differences are small
            %~any(abs([dX dY] - [dX_truth dY_truth])> 1e-12);
            
            % verify
            testCase.verifyEqual([dX dY],[dX_truth dY_truth],'AbsTol',1e-12, ...
                'Failed to verify GCRS2ITRS coordinate transformation to 1e-12');
            
        end
    end
    
    methods(Test)
        
        % USNO
        
        function test_getEOP_1(testCase)                
            
            % set the time to test (UTC)
            t = 53101;
            
            % compute eop info at time t (UTC)
            [xp,yp,du,dt] = USNO().getEOP(t);
            
            % the values should be
            xp_t = -0.1407150;
            yp_t =  0.3335200;
            du_t = -0.4399519;
            dt_t = 32;
            
            testCase.verifyEqual([xp,yp,du,dt],[xp_t,yp_t,du_t,dt_t],'AbsTol',1e-12, ...
                'Failed to verify USNO EOP evaluation to 1e-12');
            
        end
    end
    
    methods(Static, Access = 'public')
    
        function results = exe()
            import matlab.unittest.TestSuite
            results = run(TestSuite.fromFile('UnitTests.m'));
        end
        
    end
    
end

