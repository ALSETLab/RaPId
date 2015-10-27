function [dep_list] = check_dependancies
curr = pwd;
flist = list_structure(curr); 
dep_list(1) = {'MATLAB'};
dep_inst = ver;
dep_inst = struct2cell(dep_inst); 
for (i=1:length(flist))
   dep_temp = dependencies.toolboxDependencyAnalysis(flist(i));
for (k=1:length(dep_temp)) 
  if cellfun(@isempty,strfind(dep_list,dep_temp{k}))
    dep_list(end+1) = dep_temp(k); 
  end
end
end
%%
disp('RaPId Toolbox dependancies are: ');
for (i=1:length(dep_list))
    disp(dep_list{i});
    if  ~sum(ismember(dep_inst(1,1,:),dep_list(i)))
        warning(strcat(dep_list{i},' -- not installed!'));
    end
end

end