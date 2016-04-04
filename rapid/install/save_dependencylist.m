function []= save_dependencylist()
%Save dependency list for Rapid in ascii

cell_list=check_dependencies();
nrows= length(cell_list);
filename = 'rapid_dep_list.txt';
fid = fopen(filename, 'w');
for row=1:nrows
    fprintf(fid, '%s\n', cell_list{row}); %write new line+content row
end
end

