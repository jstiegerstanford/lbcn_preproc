function elect_select_all = concat_elect_select(subjects, task, dirs, vars, column)

vars_selec = {'elect_select', 'act_deact_cond1', 'act_deact_cond2', 'sc1c2_FDR', 'sc1b1_FDR' , 'sc2b2_FDR', ...
        'sc1c2_Pperm', 'sc1b1_Pperm', 'sc2b2_Pperm', 'sc1c2_tstat', 'sc1b1_tstat', 'sc2b2_tstat'};


elect_select_all = table;
for is = 1:length(subjects)
    s = subjects{is};
    fname = sprintf('%sel_selectivity/el_selectivity_%s_%s.mat',dirs.result_dir, s, task);
%     fname = sprintf('%sel_selectivity/el_selectivity_%s_%s_%s.mat',dirs.result_dir, s, task, column);
    load(fname)
    load([dirs.original_data filesep  s filesep 'subjVar_'  s '.mat']);
    subjVar = subjVar.elinfo(:, contains(subjVar.elinfo.Properties.VariableNames, vars));   
    if sum(strcmp(subjVar.Properties.VariableNames, 'DK_long_josef')) == 0
        subjVar.DK_long_josef = repmat({'not done'},size(subjVar,1),1,1);
    else
    end
    el_selectivity_tmp = el_selectivity(:, contains(el_selectivity.Properties.VariableNames, vars_selec));   
    el_selectivity_tmp.sbj_name = repmat({s},size(el_selectivity_tmp,1),1);
    
    % Load subject variable and include variables
    el_selectivity_tmp = [subjVar, el_selectivity_tmp];
    
    %% Add HFO info
    
%     el_selectivity = get_HFO_electrodes(dirs, el_selectivity_tmp, s, task)    
    elect_select_all = [elect_select_all; el_selectivity_tmp];   

    
end

if sum(contains(vars, 'DK_lobe')) > 0
    elect_select_all.DK_lobe_generic = DK_lobe_generic(elect_select_all);
else
end


end



