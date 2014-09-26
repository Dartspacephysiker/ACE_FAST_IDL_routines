filename=['/thayerfs/research/lfm/bzhang/climatology/Dbl/weimer/potential1.txt']

data_weimer=load(filename);
N=length(data_weimer);
Re=1;
for j=0:2:360
    for i=1:81
    data_north(j*81/2+i)=data_weimer(j*81+i,4);
    time_north(j*81/2+i)=data_weimer(j*81+i,2);    
    lati_north(j*81/2+i)=data_weimer(j*81+i,1);       
    end
end


range=[-80 80];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This part of the code sets up colormap and contour levels
% for potential plot, the colormap 'rredblue' is perfect
% for
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
contour_num=12;
color_level=16; % better to be 2^n
                   rb3=rblueTan;%rredblue;%redblue3;%

                   cmap1=[rb3(1:128,:)   
                         rb3(129:256,:)];
                   dlevel=256/color_level;  
                   cmap=zeros(color_level,3);                  
                   for k=1:color_level
                       cmap(k,:)=cmap1(k*dlevel,:);
                   end                     
                   blueTan = colormap_bluetan;
                   cmap=[cmap(1:color_level/2,:)
                         1 1 1
                         1 1 1
                         1 1 1
                         cmap((color_level/2+1):color_level,:)];
                   %cmap=blueTan;
%%%%%%%%%%%%%%%%%%%%End of colormap setting up%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%latitude=data_weimer(1:N/2,1);
%time=data_weimer(1:N/2,2);
%potential=data_weimer(1:N/2,4);

angle=(time_north-6).*pi/12;
rho=1.017*cos(lati_north/180*pi);

x_weimer=rho.*cos(angle);
y_weimer=rho.*sin(angle);
z_weimer=1.017*sin(lati_north*pi/180);

  [th,r]=meshgrid((0:1:360)*pi/180,0:0.005:0.62);
  [X,Y]=pol2cart(th,r); 
  
  [x1,y1]=meshgrid(-0.66:0.005:0.66);
  
  
  figure(3)
  set(figure(3),'position',[6 31 751 748])
  
  h1=subplot(3,3,1,'replace');
  po1=get(h1,'position');
  po1(3)=po1(3)+0.082;
  po1(2)=po1(2)-0.07;
  ps1=0.06;
  subplot(3,3,1,'replace');
  h1=subplot('position',[ps1,po1(2),po1(3),po1(3)]);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  1111111
  box off;
  
                    
  Un=griddata(x_weimer,y_weimer,data_north,X,Y);
  Un=griddata(X,Y,Un,x1,y1);   

  contourf(x1,y1,Un,contour_num,'LineStyle','-','color','w','LineWidth',0.5);hold on; axis off; box off;axis square;
                   view(0,90);set(gca,'DataAspectRatio',[1 1 1]);
                   caxis(range);
                   test=redblue10;
                   colormap(cmap); 
                   %s=colorbar;
                   %set(s,'YTick',[-50 0 50]);
                                      hh=colorbar;
                   set(hh,'position',[0.3020+po1(3)+0.01    0.6406-po1(3)-0.03    0.0296/2    0.2954/2])
                   
                   
  lt=[55,60,70,80];
  tm=0:1:24;

 for k=1:length(lt)
    theta=0:1:360;
    x=1.02*(pi/2-lt(k)/180*pi).*cos(theta/180*pi);
    y=1.02*(pi/2-lt(k)/180*pi).*sin(theta/180*pi);  
    if(k==1)
        str='-';
    else
        str=':';
    end
    plot(x,y,'LineWidth',0.5,'LineStyle',str,'color','k')

 end

for p=1:length(tm)
    rr=((1.02*(pi/2-lt(1)/180*pi))-0.02):0.01:(1.02*(pi/2-lt(1)/180*pi));
    beta=tm(p)*2*pi/24;
    x=rr.*sin(beta)*Re;
    y=rr.*cos(beta)*Re;
    plot(x,y,'LineWidth',0.5,'LineStyle','-','color','k')  
end

  V=round(max(Un(:))-min(Un(:)));text(0.4151,-0.5794,[num2str(V),' kV'],'FontSize',14);
 %axis on;xlabel('x')
 %text(-0.55,0.55,'50^o')
 text(-0.51,0.51,'55^o','FontSize',12)
 text(-0.42,0.42,'60^o','FontSize',12) 
 text(-0.33,0.33,'70^o','FontSize',12)  
 text(-0.15,0.68,'12 MLT','FontSize',16)
text(-0.75,-0.04,'18','FontSize',16)
%%
   h2=subplot('position',[ps1+po1(3),po1(2),po1(3),po1(3)]);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  222222
filename=['/thayerfs/research/lfm/bzhang/climatology/Dbl/weimer/potential2.txt']

data_weimer=load(filename);

for j=0:2:360
    for i=1:81
    data_north(j*81/2+i)=data_weimer(j*81+i,4);
    time_north(j*81/2+i)=data_weimer(j*81+i,2);    
    lati_north(j*81/2+i)=data_weimer(j*81+i,1);       
    end
end   
  Un=griddata(x_weimer,y_weimer,data_north,X,Y); 
  Un=griddata(X,Y,Un,x1,y1);   
  contourf(x1,y1,Un,contour_num,'LineStyle','-','color','w','LineWidth',0.5);hold on; axis off; box off;axis square;
                   view(0,90);set(gca,'DataAspectRatio',[1 1 1]);
                   caxis(range);
                   blueTan = colormap_bluetan;
                   colormap(cmap);                   

 for k=1:length(lt)
    theta=0:1:360;
    x=1.02*(pi/2-lt(k)/180*pi).*cos(theta/180*pi);
    y=1.02*(pi/2-lt(k)/180*pi).*sin(theta/180*pi);  
    if(k==1)
        str='-';
    else
        str=':';
    end
    plot(x,y,'LineWidth',0.5,'LineStyle',str,'color','k')

 end

for p=1:length(tm)
    rr=((1.02*(pi/2-lt(1)/180*pi))-0.02):0.01:(1.02*(pi/2-lt(1)/180*pi));
    beta=tm(p)*2*pi/24;
    x=rr.*sin(beta)*Re;
    y=rr.*cos(beta)*Re;
    plot(x,y,'LineWidth',0.5,'LineStyle','-','color','k')  
end

  V=round(max(Un(:))-min(Un(:)));text(0.4151,-0.5794,[num2str(V),' kV'],'FontSize',14);
 %axis on;xlabel('x')
 %text(-0.55,0.55,'50^o')
 text(-0.51,0.51,'55^o','FontSize',12)
 

    h3=subplot('position',[ps1+po1(3)+po1(3),po1(2),po1(3),po1(3)]);%%%%%%%%%%%%%%%%%%%% 33333
filename=['/thayerfs/research/lfm/bzhang/climatology/Dbl/weimer/potential3.txt']

data_weimer=load(filename);

for j=0:2:360
    for i=1:81
    data_north(j*81/2+i)=data_weimer(j*81+i,4);
    time_north(j*81/2+i)=data_weimer(j*81+i,2);    
    lati_north(j*81/2+i)=data_weimer(j*81+i,1);       
    end
end   
  Un=griddata(x_weimer,y_weimer,data_north,X,Y); 
  Un=griddata(X,Y,Un,x1,y1);    
  contourf(x1,y1,Un,contour_num,'LineStyle','-','color','w','LineWidth',0.5);hold on; axis off; box off;axis square;
                   view(0,90);set(gca,'DataAspectRatio',[1 1 1]);
                   caxis(range);
                   blueTan = colormap_bluetan;
                   colormap(cmap);                   

 for k=1:length(lt)
    theta=0:1:360;
    x=1.02*(pi/2-lt(k)/180*pi).*cos(theta/180*pi);
    y=1.02*(pi/2-lt(k)/180*pi).*sin(theta/180*pi);  
    if(k==1)
        str='-';
    else
        str=':';
    end
    plot(x,y,'LineWidth',0.5,'LineStyle',str,'color','k')

 end

for p=1:length(tm)
    rr=((1.02*(pi/2-lt(1)/180*pi))-0.02):0.01:(1.02*(pi/2-lt(1)/180*pi));
    beta=tm(p)*2*pi/24;
    x=rr.*sin(beta)*Re;
    y=rr.*cos(beta)*Re;
    plot(x,y,'LineWidth',0.5,'LineStyle','-','color','k')  
end

  V=round(max(Un(:))-min(Un(:)));text(0.4151,-0.5794,[num2str(V),' kV'],'FontSize',14);
 %axis on;xlabel('x')
 %text(-0.55,0.55,'50^o')
 text(-0.51,0.51,'55^o','FontSize',12)

  h4=subplot('position',[ps1,po1(2)-po1(3),po1(3),po1(3)]);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 44444
filename=['/thayerfs/research/lfm/bzhang/climatology/Dbl/weimer/potential4.txt']

data_weimer=load(filename);

for j=0:2:360
    for i=1:81
    data_north(j*81/2+i)=data_weimer(j*81+i,4);
    time_north(j*81/2+i)=data_weimer(j*81+i,2);    
    lati_north(j*81/2+i)=data_weimer(j*81+i,1);       
    end
end   
  Un=griddata(x_weimer,y_weimer,data_north,X,Y); 
  Un=griddata(X,Y,Un,x1,y1);    
  contourf(x1,y1,Un,contour_num,'LineStyle','-','color','w','LineWidth',0.5);hold on; axis off; box off;axis square;
                   view(0,90);set(gca,'DataAspectRatio',[1 1 1]);
                   caxis(range);
                   blueTan = colormap_bluetan;
                   colormap(cmap);                   

 for k=1:length(lt)
    theta=0:1:360;
    x=1.02*(pi/2-lt(k)/180*pi).*cos(theta/180*pi);
    y=1.02*(pi/2-lt(k)/180*pi).*sin(theta/180*pi);  
    if(k==1)
        str='-';
    else
        str=':';
    end
    plot(x,y,'LineWidth',0.5,'LineStyle',str,'color','k')

 end

for p=1:length(tm)
    rr=((1.02*(pi/2-lt(1)/180*pi))-0.02):0.01:(1.02*(pi/2-lt(1)/180*pi));
    beta=tm(p)*2*pi/24;
    x=rr.*sin(beta)*Re;
    y=rr.*cos(beta)*Re;
    plot(x,y,'LineWidth',0.5,'LineStyle','-','color','k')  
end

  V=round(max(Un(:))-min(Un(:)));text(0.4151,-0.5794,[num2str(V),' kV'],'FontSize',14);
 %axis on;xlabel('x')
 %text(-0.55,0.55,'50^o')
 text(-0.51,0.51,'55^o','FontSize',12)
 
    h6=subplot('position',[ps1+po1(3)+po1(3),po1(2)-po1(3),po1(3),po1(3)]);%%%%%%%%%%%%% 66666
filename=['/thayerfs/research/lfm/bzhang/climatology/Dbl/weimer/potential6.txt']

data_weimer=load(filename);

for j=0:2:360
    for i=1:81
    data_north(j*81/2+i)=data_weimer(j*81+i,4);
    time_north(j*81/2+i)=data_weimer(j*81+i,2);    
    lati_north(j*81/2+i)=data_weimer(j*81+i,1);       
    end
end   
  Un=griddata(x_weimer,y_weimer,data_north,X,Y); 
  Un=griddata(X,Y,Un,x1,y1);    
  contourf(x1,y1,Un,contour_num,'LineStyle','-','color','w','LineWidth',0.5);hold on; axis off; box off;axis square;
                   view(0,90);set(gca,'DataAspectRatio',[1 1 1]);
                   caxis(range);
                   blueTan = colormap_bluetan;
                   colormap(cmap);                   

 for k=1:length(lt)
    theta=0:1:360;
    x=1.02*(pi/2-lt(k)/180*pi).*cos(theta/180*pi);
    y=1.02*(pi/2-lt(k)/180*pi).*sin(theta/180*pi);  
    if(k==1)
        str='-';
    else
        str=':';
    end
    plot(x,y,'LineWidth',0.5,'LineStyle',str,'color','k')

 end

for p=1:length(tm)
    rr=((1.02*(pi/2-lt(1)/180*pi))-0.02):0.01:(1.02*(pi/2-lt(1)/180*pi));
    beta=tm(p)*2*pi/24;
    x=rr.*sin(beta)*Re;
    y=rr.*cos(beta)*Re;
    plot(x,y,'LineWidth',0.5,'LineStyle','-','color','k')  
end

  V=round(max(Un(:))-min(Un(:)));text(0.4151,-0.5794,[num2str(V),' kV'],'FontSize',14);
 %axis on;xlabel('x')
 %text(-0.55,0.55,'50^o')
 text(-0.51,0.51,'55^o','FontSize',12)

 
    h7=subplot('position',[ps1,po1(2)-po1(3)-po1(3),po1(3),po1(3)]);%%%%%%%%%%%%%%%%%%%%%  77777
filename=['/thayerfs/research/lfm/bzhang/climatology/Dbl/weimer/potential7.txt']

data_weimer=load(filename);

for j=0:2:360
    for i=1:81
    data_north(j*81/2+i)=data_weimer(j*81+i,4);
    time_north(j*81/2+i)=data_weimer(j*81+i,2);    
    lati_north(j*81/2+i)=data_weimer(j*81+i,1);       
    end
end   
  Un=griddata(x_weimer,y_weimer,data_north,X,Y); 
  Un=griddata(X,Y,Un,x1,y1);    
  contourf(x1,y1,Un,contour_num,'LineStyle','-','color','w','LineWidth',0.5);hold on; axis off; box off;axis square;
                   view(0,90);set(gca,'DataAspectRatio',[1 1 1]);
                   caxis(range);
                   blueTan = colormap_bluetan;
                   colormap(cmap);                   

 for k=1:length(lt)
    theta=0:1:360;
    x=1.02*(pi/2-lt(k)/180*pi).*cos(theta/180*pi);
    y=1.02*(pi/2-lt(k)/180*pi).*sin(theta/180*pi);  
    if(k==1)
        str='-';
    else
        str=':';
    end
    plot(x,y,'LineWidth',0.5,'LineStyle',str,'color','k')

 end

for p=1:length(tm)
    rr=((1.02*(pi/2-lt(1)/180*pi))-0.02):0.01:(1.02*(pi/2-lt(1)/180*pi));
    beta=tm(p)*2*pi/24;
    x=rr.*sin(beta)*Re;
    y=rr.*cos(beta)*Re;
    plot(x,y,'LineWidth',0.5,'LineStyle','-','color','k')  
end

  V=round(max(Un(:))-min(Un(:)));text(0.4151,-0.5794,[num2str(V),' kV'],'FontSize',14);
 %axis on;xlabel('x')
 %text(-0.55,0.55,'50^o')
 text(-0.51,0.51,'55^o','FontSize',12)
 
    h8=subplot('position',[ps1+po1(3),po1(2)-po1(3)-po1(3),po1(3),po1(3)]);%%%%%%%%%%%%%%%  88888
filename=['/thayerfs/research/lfm/bzhang/climatology/Dbl/weimer/potential8.txt']

data_weimer=load(filename);

for j=0:2:360
    for i=1:81
    data_north(j*81/2+i)=data_weimer(j*81+i,4);
    time_north(j*81/2+i)=data_weimer(j*81+i,2);    
    lati_north(j*81/2+i)=data_weimer(j*81+i,1);       
    end
end   
  Un=griddata(x_weimer,y_weimer,data_north,X,Y); 
  Un=griddata(X,Y,Un,x1,y1);    
  contourf(x1,y1,Un,contour_num,'LineStyle','-','color','w','LineWidth',0.5);hold on; axis off; box off;axis square;
                   view(0,90);set(gca,'DataAspectRatio',[1 1 1]);
                   caxis(range);
                   blueTan = colormap_bluetan;
                   colormap(cmap);                   

 for k=1:length(lt)
    theta=0:1:360;
    x=1.02*(pi/2-lt(k)/180*pi).*cos(theta/180*pi);
    y=1.02*(pi/2-lt(k)/180*pi).*sin(theta/180*pi);  
    if(k==1)
        str='-';
    else
        str=':';
    end
    plot(x,y,'LineWidth',0.5,'LineStyle',str,'color','k')

 end

for p=1:length(tm)
    rr=((1.02*(pi/2-lt(1)/180*pi))-0.02):0.01:(1.02*(pi/2-lt(1)/180*pi));
    beta=tm(p)*2*pi/24;
    x=rr.*sin(beta)*Re;
    y=rr.*cos(beta)*Re;
    plot(x,y,'LineWidth',0.5,'LineStyle','-','color','k')  
end

  V=round(max(Un(:))-min(Un(:)));text(0.4151,-0.5794,[num2str(V),' kV'],'FontSize',14);
 %axis on;xlabel('x')
 %text(-0.55,0.55,'50^o')
 text(-0.51,0.51,'55^o','FontSize',12) 
 
   h9=subplot('position',[ps1+po1(3)+po1(3),po1(2)-po1(3)-po1(3),po1(3),po1(3)]);%%%%%%%%%%%  99999
filename=['/thayerfs/research/lfm/bzhang/climatology/Dbl/weimer/potential9.txt']

data_weimer=load(filename);

for j=0:2:360
    for i=1:81
    data_north(j*81/2+i)=data_weimer(j*81+i,4);
    time_north(j*81/2+i)=data_weimer(j*81+i,2);    
    lati_north(j*81/2+i)=data_weimer(j*81+i,1);       
    end
end   
  Un=griddata(x_weimer,y_weimer,data_north,X,Y); 
  Un=griddata(X,Y,Un,x1,y1);    
  contourf(x1,y1,Un,contour_num,'LineStyle','-','color','w','LineWidth',0.5);hold on; axis off; box off;axis square;
                   view(0,90);set(gca,'DataAspectRatio',[1 1 1]);
                   caxis(range);
                   blueTan = colormap_bluetan;
                   colormap(cmap);                   

 for k=1:length(lt)
    theta=0:1:360;
    x=1.02*(pi/2-lt(k)/180*pi).*cos(theta/180*pi);
    y=1.02*(pi/2-lt(k)/180*pi).*sin(theta/180*pi);  
    if(k==1)
        str='-';
    else
        str=':';
    end
    plot(x,y,'LineWidth',0.5,'LineStyle',str,'color','k')

 end

for p=1:length(tm)
    rr=((1.02*(pi/2-lt(1)/180*pi))-0.02):0.01:(1.02*(pi/2-lt(1)/180*pi));
    beta=tm(p)*2*pi/24;
    x=rr.*sin(beta)*Re;
    y=rr.*cos(beta)*Re;
    plot(x,y,'LineWidth',0.5,'LineStyle','-','color','k')  
end

  V=round(max(Un(:))-min(Un(:)));text(0.4151,-0.5794,[num2str(V),' kV'],'FontSize',14);
 %axis on;xlabel('x')
 %text(-0.55,0.55,'50^o')
 text(-0.51,0.51,'55^o','FontSize',12)
%%   
   h5=subplot('position',[ps1+po1(3),po1(2)-po1(3),po1(3),po1(3)]);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 55555
   fac=0.4;
   
u=fac*[1 0.7 0 -0.7 -1 -0.7 0 0.7];
v=fac*[0 0.7 1 0.7 0 -0.7 -1 -0.7];

for i=1:length(u)
h=quiver(u(i),v(i),'color','k');hold on
end
box on;%axis tight;
axis off;
t1=text(0.55,1.8,'+Z','FontSize',16);
t2=text(1.75,0.95,'+Y','FontSize',16);
t3=text(0.95,0.12,'-Z','FontSize',16);
t4=text(0.08,0.95,'-Y','FontSize',16);
    
set(t1,'position',[1.0242    1.3065   17.3205]);
set(t2,'position',[1.2812    1.0419   17.3205]);
set(t3,'position',[1.0194    0.6419   17.3205]);
set(t4,'position',[0.6315    1.0484   17.3205]);
%%
t=text( 1.42,0.6127,'kV','Fontsize',14)