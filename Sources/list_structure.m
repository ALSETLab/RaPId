function [flist]=list_structure(directory)
flist = {};
files_folders = dir(directory);

%Go to subfolders
for (i=1:length(files_folders))
if isdir(files_folders(i).name) &&   ~strcmp(files_folders(i).name,'.')...
        && ~strcmp(files_folders(i).name,'..')
     bottom_list = list_structure(strcat(directory,'\',files_folders(i).name));
     if ~isempty(bottom_list)
      flist = [flist bottom_list ];
     end
end
%Add files in a folder to the list
if strcmp(files_folders(i).name(find(files_folders(i).name=='.',1,'last'):end),'.m')
   if exist('flist')
    flist(end+1) = cellstr(strcat(directory,'\',files_folders(i).name)); 
   else
    flist(1) = cellstr(strcat(directory,'\',files_folders(i).name));
   end
end
end
end