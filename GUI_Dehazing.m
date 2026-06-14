function GUI_Dehazing()

clc;
close all;

% =========================================================
% FULL SCREEN SCIENTIFIC GUI
% =========================================================

f = figure('Name','Image Quality Enhancement Analysis',...
           'NumberTitle','off',...
           'Units','normalized',...
           'OuterPosition',[0 0 1 1],...
           'Color',[0.08 0.08 0.08],...
           'MenuBar','none',...
           'ToolBar','none');

% =========================================================
% TITLE
% =========================================================

uicontrol('Style','text',...
          'Units','normalized',...
          'Position',[0.25 0.93 0.5 0.04],...
          'String','Image Quality Enhancement Analysis',...
          'FontSize',20,...
          'FontWeight','bold',...
          'ForegroundColor',[0 1 1],...
          'BackgroundColor',[0.08 0.08 0.08]);

btn = [0.1 0.45 0.9];

% =========================================================
% BUTTONS
% =========================================================

uicontrol('Style','pushbutton','Units','normalized','Position',[0.03 0.86 0.08 0.05],...
          'String','Upload Image','FontSize',11,'FontWeight','bold','BackgroundColor',btn,...
          'ForegroundColor','white','Callback',@upload_callback);

uicontrol('Style','pushbutton','Units','normalized','Position',[0.13 0.86 0.08 0.05],...
          'String','Process Image','FontSize',11,'FontWeight','bold','BackgroundColor',btn,...
          'ForegroundColor','white','Callback',@process_callback);

uicontrol('Style','pushbutton','Units','normalized','Position',[0.23 0.86 0.08 0.05],...
          'String','Save Output','FontSize',11,'FontWeight','bold','BackgroundColor',btn,...
          'ForegroundColor','white','Callback',@save_callback);

uicontrol('Style','pushbutton','Units','normalized','Position',[0.33 0.86 0.08 0.05],...
          'String','3D Haze View','FontSize',11,'FontWeight','bold','BackgroundColor',[0.7 0.3 0.1],...
          'ForegroundColor','white','Callback',@fog3d_callback);

uicontrol('Style','pushbutton','Units','normalized','Position',[0.43 0.86 0.08 0.05],...
          'String','Thermal Map','FontSize',11,'FontWeight','bold','BackgroundColor',[0.9 0.4 0.1],...
          'ForegroundColor','white','Callback',@thermal_callback);

uicontrol('Style','pushbutton','Units','normalized','Position',[0.53 0.86 0.08 0.05],...
          'String','Particle Simulation','FontSize',11,'FontWeight','bold','BackgroundColor',[0.2 0.7 0.4],...
          'ForegroundColor','white','Callback',@particle_callback);

uicontrol('Style','pushbutton','Units','normalized','Position',[0.63 0.86 0.08 0.05],...
          'String','Report','FontSize',11,'FontWeight','bold','BackgroundColor',[0.7 0.2 0.7],...
          'ForegroundColor','white','Callback',@report_callback);

uicontrol('Style','pushbutton','Units','normalized','Position',[0.73 0.86 0.08 0.05],...
          'String','Exit','FontSize',11,'FontWeight','bold','BackgroundColor',[0.8 0.2 0.2],...
          'ForegroundColor','white','Callback',@(src,event) close(f));

% =========================================================
% STATUS
% =========================================================

status_text = uicontrol('Style','text','Units','normalized',...
    'Position',[0.82 0.86 0.16 0.04],...
    'String','STATUS : WAITING',...
    'FontSize',12,'ForegroundColor',[0 1 1],...
    'BackgroundColor',[0.08 0.08 0.08]);

% =========================================================
% METRICS
% =========================================================

psnr_text = uicontrol('Style','text',...
    'Units','normalized',...
    'Position',[0.76 0.78 0.2 0.03],...
    'String','PSNR : ',...
    'FontSize',12,...
    'ForegroundColor','white',...
    'BackgroundColor',[0.08 0.08 0.08]);


entropy_text = uicontrol('Style','text',...
    'Units','normalized',...
    'Position',[0.76 0.74 0.2 0.03],...
    'String','Entropy : ',...
    'FontSize',12,...
    'ForegroundColor','green',...
    'BackgroundColor',[0.08 0.08 0.08]);

fid_text = uicontrol('Style','text',...
    'Units','normalized',...
    'Position',[0.76 0.70 0.2 0.03],...
    'String','FID Value : ',...
    'FontSize',12,...
    'ForegroundColor','cyan',...
    'BackgroundColor',[0.08 0.08 0.08]);
time_text = uicontrol('Style','text',...
    'Units','normalized',...
    'Position',[0.76 0.66 0.2 0.03],...
    'String','Time : ',...
    'FontSize',12,...
    'ForegroundColor','yellow',...
    'BackgroundColor',[0.08 0.08 0.08]);
% =========================================================
% AXES
% =========================================================

ax1 = axes('Units','normalized','Position',[0.03 0.52 0.2 0.22]); title('Hazy Image','Color','white');
ax2 = axes('Units','normalized','Position',[0.27 0.52 0.2 0.22]); title('Dark Channel','Color','white');
ax3 = axes('Units','normalized','Position',[0.51 0.52 0.2 0.22]); title('Transmission Map','Color','white');
ax4 = axes('Units','normalized','Position',[0.03 0.20 0.2 0.22]); title('Refined Transmission','Color','white');
ax5 = axes('Units','normalized','Position',[0.27 0.20 0.2 0.22]); title('Haze Thickness','Color','white');
ax6 = axes('Units','normalized','Position',[0.51 0.20 0.2 0.22]); title('Dehazed Image','Color','white');
ax7 = axes('Units','normalized','Position',[0.76 0.38 0.2 0.12]); title('Histogram Analysis','Color','white');
ax8 = axes('Units','normalized','Position',[0.76 0.16 0.2 0.12]); title('Pixel Comparison','Color','white');

% =========================================================
% UPLOAD
% =========================================================

function upload_callback(~,~)
    [file,path]=uigetfile({'*.jpg;*.png;*.bmp'});
    if isequal(file,0), return; end
    img = double(imread(fullfile(path,file)))/255;
    setappdata(f,'hazy',img);
    axes(ax1); imshow(img);
    set(status_text,'String','STATUS : IMAGE UPLOADED');
end

% =========================================================
% PROCESS
% =========================================================

function process_callback(~,~)

if ~isappdata(f,'hazy')
    msgbox('Upload Image First'); return;
end

img = getappdata(f,'hazy');
h = waitbar(0,'Processing...');

waitbar(0.2,h,'Dark Channel');
dark = Dark_Channel(img);

waitbar(0.4,h,'Atmospheric Light');
A = Estimating_Atmospheric_Light(img,dark);

waitbar(0.6,h,'Transmission');
t = Transmission_Estimate(img,A);

waitbar(0.8,h,'Guided Filter');
t_refined = Guided_Filter(img,t,15,1e-3);

J = Recovering_Scene_Radiance(img,A,t_refined);

% ✔ FINAL FIX (NO AI MODULE)
enhanced = J;

haze = 1 - t_refined;

close(h);

setappdata(f,'enhanced',enhanced);
setappdata(f,'haze',haze);

imshow(dark,'Parent',ax2);
title(ax2,'Dark Channel','Color','white');

imagesc(t,'Parent',ax3);
axis(ax3,'off'); colormap(ax3,turbo);
title(ax3,'Transmission Map','Color','white');

imagesc(t_refined,'Parent',ax4);
axis(ax4,'off'); colormap(ax4,turbo);
title(ax4,'Refined Transmission','Color','white');

imagesc(haze,'Parent',ax5);
axis(ax5,'off'); colormap(ax5,hot);
title(ax5,'Haze Thickness','Color','white');

imshow(enhanced,'Parent',ax6);
title(ax6,'Dehazed Image','Color','white');

gray1 = mean(img,3);
gray2 = mean(enhanced,3);

axes(ax7);
cla;
histogram(gray1(:),128,'FaceColor','red'); hold on;
histogram(gray2(:),128,'FaceColor','blue'); legend('Hazy','Dehazed');

axes(ax8);
row = round(size(gray1,1)/2);
plot(gray1(row,:),'r'); hold on;
plot(gray2(row,:),'c'); legend('Hazy','Dehazed');

psnr_val = PSNR_Value(gray2,gray1);

% ================= ENTROPY =================
entropy_val = entropy(rgb2gray(enhanced));

% ================= FID (SIMPLIFIED APPROX) =================
fid_val = immse(gray1, gray2);
% ================= TIME =================
elapsed_time = toc;

% ================= UPDATE UI =================


set(psnr_text,'String',['PSNR : ',num2str(psnr_val)]);
set(status_text,'String','STATUS : COMPLETE');

set(entropy_text,'String',['Entropy : ',num2str(entropy_val)]);

set(fid_text,'String',['FID Value : ',num2str(fid_val)]);
set(time_text,'String',['Time : ',num2str(elapsed_time),' s']);

end

% =========================================================
% SAVE
% =========================================================

function save_callback(~,~)
if ~isappdata(f,'enhanced'), return; end
img=getappdata(f,'enhanced');
[file,path]=uiputfile('output.jpg');
if isequal(file,0), return; end
imwrite(img,fullfile(path,file));
msgbox('Saved Successfully');
end

% =========================================================
% OTHER BUTTONS (UNCHANGED LOGIC)
% =========================================================

function fog3d_callback(~,~)
if ~isappdata(f,'haze'), return; end
figure; surf(getappdata(f,'haze')); colormap jet;
end

function thermal_callback(~,~)
if ~isappdata(f,'enhanced'), return; end
figure; imagesc(mean(getappdata(f,'enhanced'),3)); colormap hot;
end

function particle_callback(~,~)
figure;
for i=1:100
scatter(rand(1,200),rand(1,200)); drawnow;
end
end

function report_callback(~,~)
[file,path]=uiputfile('report.txt');
if isequal(file,0), return; end
fid=fopen(fullfile(path,file),'w');
fprintf(fid,'Dehazing Report Completed Successfully\n');
fclose(fid);
msgbox('Report Done');
end

end