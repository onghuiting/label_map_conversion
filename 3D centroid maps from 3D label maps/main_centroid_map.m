

% This matlab code is to generate 3D centroid maps from 3D label maps.
% The input folder should consist of multiple sub-folders. 
% Each sub-folder should consist of multiple .TIF files. 
% Each .TIF file should be a z stack (3D label maps).
%
% Written by hui ting, 30 nov 2021


close all;clear all;clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h_sz = 5;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


pathname = uigetdir(cd,'Select main folder that consists of all subfolders');
folders1 = dir(pathname);
dirFlags = [folders1.isdir] & ~strcmp({folders1.name},'.') & ~strcmp({folders1.name},'..');
folders = folders1(dirFlags);
total_folders = length(folders);

res_main = fullfile(pathname,'centroid map');
mkdir(res_main);

for ifolder = 1:total_folders

    foldername = folders(ifolder).name
    files = dir(fullfile(pathname,foldername,'*.TIF'));
    total_files = length(files)

    res_folder = fullfile(res_main,[foldername '_centroid_map']);
    mkdir(res_folder);

    for ifile = 1:total_files

        filename = files(ifile).name

stack_info = imfinfo(fullfile(pathname, foldername,filename));
z_slices = length(stack_info);
img_w = stack_info(1).Width;
img_h = stack_info(1).Height;

stack = nan(img_h,img_w,z_slices);

for z=1:z_slices

stack(:,:,z) = imread(fullfile(pathname,foldername,filename),z);

end

s = regionprops3(stack, "Centroid");
centers = s.Centroid;
centers = round(centers);

centroid_stack = uint8(zeros(img_h,img_w,z_slices));

total_nuc = size(centers,1)

for c=1:total_nuc

    yc=centers(c,2);
    xc=centers(c,1);
    zc=centers(c,3);

    centroid_stack(yc-h_sz:yc+h_sz,xc-h_sz:xc+h_sz,zc)=255;

end


outname = ['centroid_' filename];
imwrite(centroid_stack(:,:,1),fullfile(res_folder,outname));

for z=2:z_slices
  
   imwrite(centroid_stack(:,:,z),fullfile(res_folder,outname),'WriteMode','append');

end



    end

end




























