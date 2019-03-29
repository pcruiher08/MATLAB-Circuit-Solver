%GUI INITIALIZATION
promt = {'Vm: ', '\theta v','Im: ', '\theta i','R1: ','R2: ', 'C1: ', 'L1: ','omega: '};
title = 'Circuit Values';
dims = [1 30];
definput = {'0','0','0','0','0','0','0','0','0'};
opts.Interpreter = 'tex';
answer = inputdlg(promt,title,dims,definput,opts);

%INPUT VALUES
Vin = str2double(answer{1});
thetaIn = str2double(answer{2});
Iin = str2double(answer{3});
thetaIin = str2double(answer{4});
resistor1 = str2double(answer{5});
resistor2 = str2double(answer{6});
capacitor1 = str2double(answer{7});
inductor1 = str2double(answer{8});
omega = str2double(answer{9});

%IMPEDANCE VALUES
zc1 = -1i /(omega*capacitor1);
zl1 = 1i*omega*inductor1;

%POLAR TO RECTANGULAR
Vin = Vin * (cos(thetaIn*pi/180) + 1i*sin(thetaIn*pi/180)); 
Iin = Iin * (cos(thetaIin*pi/180) + 1i*sin(thetaIin*pi/180));

%SYSTEM OF EQUATIONS
syms NODE1 NODE2
    equation1 = (Vin - NODE2)/resistor1 + (NODE1 - NODE2)/zc1 == Iin;
    equation2 = (NODE1-0)/zl1 == (NODE2-NODE1)/zc1 - (NODE1-Vin)/resistor2;
    %Ix * resistor2 == Vx; 
    %Ix == (NODE1 - Vin)/resistor2;
sol = solve([equation1, equation2],[NODE1,NODE2]);

%Vx and Ix
Vx = Vin - sol.NODE1;
Ix = -Vx/resistor2;

%OUTPUT FORMAT
magnitudeOfVx = abs(Vx); 
angleOfVx = angle(Vx*180/pi);
magnitudeOfIx = abs(Ix); 
angleOfIx = angle(Ix*180/pi);

axis = subplot(2,1,1);
t = linspace(0,3);

Vxequivalent = magnitudeOfVx * cos(omega * t + angleOfVx);
Ixequivalent = magnitudeOfIx * cos(omega * t + angleOfIx);

%OUTPUT VALUES
disp("Vx = " + double(magnitudeOfVx) + "cos(" +omega+ "t + " + double(angleOfVx) * 180 / pi + ")");
disp("Ix = " + double(magnitudeOfIx) + "cos(" +omega+ "t + " + double(angleOfIx) * 180 / pi + ")");

%PLOTTING
plot(axis, t, Vxequivalent);
ylabel(axis,'Vx');
xlabel(axis,'time');

axis2 = subplot(2,1,2);
plot(axis2, t, Ixequivalent);
ylabel(axis2,'Ix');
xlabel(axis2,'time');
