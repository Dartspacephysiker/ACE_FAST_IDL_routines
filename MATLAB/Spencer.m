%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       A simple code to plot dayside flux using the Spencer data
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

datadir = '/SPENCEdata/Research/Cusp/ACE_FAST/MATLAB/'; % specify the data file directory
data_files = dir([datadir,'*.ascii']);   % get the filenames

k=1; % select the first data file, you can also loop the k, e.g., for k=1:length(data_files)
data_fn=fullfile(datadir,data_files(k).name);% get the file name
disp(data_files(k).name);% display the file name in MATLAB command window
data = load(data_fn);% load the ascii file data

MLT = data(:,2); % get MLT
MLAT = data(:,1);% get MLAT
flux = data(:,3);% get flux data

angle=(MLT-6).*pi/12;
rho=1.017*cos(MLAT/180*pi);

x=rho.*cos(angle);
y=rho.*sin(angle);
z=1.017*sin(MLAT*pi/180); % Convert (MLAT,MLT) to (x,y) in the SM coordinate

[th,r]=meshgrid((-30:5:210)*pi/180,(0:1:20)*pi/180*1.0);warning off;
[X,Y]=pol2cart(th,r); 
Un=griddata(x,y,flux,X,Y);% Interpolate the data to a fixed dayside polar grid

figure(1) % plot
set(gcf,'position',[1181 477 736 621]); % set the figure size 

pcolor(X,Y,Un);shading flat;view(0,90); % Pseudo-color plot
t0=title('TITLE HERE','fontsize',16);
set(t0,'position',[0.002 0.4049 1.0001]);
hold on;
axis off;
set(gca,'DataAspectRatio',[1 1 1]);
colorbar('location','southout','position',[ 0.3274 0.2673 0.3750 0.0278]);
t1=text(-0.028,0.3758,'12 MLT','fontsize',14);
t2=text(-0.1999,0.3238,'14','fontsize',14);
t3=text(-0.3398,0.1839,'16','fontsize',14);
t4=text(0.1759,0.3238,'10','fontsize',14);
t5=text(0.3158,0.1839,'08','fontsize',14);
t6=text(-0.3691,-0.0293,'70^\circ','fontsize',14);
t7=text(-0.2745,-0.0293,'75^\circ','fontsize',14);
t8=text(-0.1879,-0.0293,'80^\circ','fontsize',14);
t9=text(-0.076,-0.1692,'[UNITS HERE!]','fontsize',14);

% plot the MLAT-MLT grid
latitude = 70:5:85;
theta = -pi/2:pi/40:pi/2;
r = 1.01*cos(latitude/180*pi);

for i=1:length(r)
    xp = r(i).*cos(theta);
    yp = r(i).*sin(theta);
    plot(yp,xp,'k');hold on
end

theta = -pi/2:pi/12:pi/2;
for i =1:length(theta)
    xp = r.*cos(theta(i));
    yp = r.*sin(theta(i));
    plot(yp,xp,'k');
end
hold off

cptcmap('GMT_wysiwygcont'); % my favorite colormap! see the "cptcmap.m" file for more colormaps, then choose your favorite!