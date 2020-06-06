function subjVar_all = ConcatSubjVars(subjects, dirs)

subjVar_all = table;
for is = 1:length(subjects)
    load([dirs.original_data filesep  subjects{is} filesep 'subjVar_'  subjects{is} '.mat']);
    subjVar_tmp = subjVar.elinfo(:, contains(subjVar.elinfo.Properties.VariableNames, {'LvsR', 'MNI_coord'}));
    subjVar_all = [subjVar_all; subjVar_tmp];
end
end

