load('dependancy_list.mat');

dep_inst = ver;
dep_inst = struct2cell(dep_inst); 
%%
disp('RaPId Toolbox dependancies are: ');
for (i=1:length(dep_list))
    disp(dep_list{i});
    if  ~sum(ismember(dep_inst(1,1,:),dep_list(i)))
        warning(strcat(dep_list{i},' -- not installed!'));
    end
end