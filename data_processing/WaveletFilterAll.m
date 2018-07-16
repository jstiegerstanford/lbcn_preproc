function WaveletFilterAll(sbj_name, project_name, bn, dirs,elecs,freq_band,span,fs_targ, norm, avgfreq)
%% INPUTS
%   sbj_name: subject name
%   project_name: name of task
%   block_names: blocks to be analyed (cell of strings)
%   dirs: directories pointing to files of interest (generated by InitializeDirs)
%   elecs (optional): can select subset of electrodes to epoch (default: all)
%   freqs (optional): vector containing frequencies at which wavelet is computed (in Hz), or 'HFB'
%   span (optional): span of wavelet (i.e. width of gaussian that forms
%                  wavelet, in units of cycles- specific to each
%                  frequency)
%   fs_targ (optional): target sampling rate of wavelet output
%   norm (optional): normalize amplitude of timecourse within each frequency
%                  band (to eliminate 1/f power drop with frequency)
%   avgfreq (optional): average across frequency dimension to yield single timecourse
%                     (e.g. for computing HFB timecourse). If set to true,
%                     only amplitude information will remain (not phase, since
%                     cannot average phase across frequencies)


if strcmp(freq_band,'HFB')
    freqs = 2.^(5.7:0.05:7.5);
    norm = true;
    avgfreq = true;
    
elseif strcmp(freq_band,'Spec')
    freqs = 2.^([0:0.5:2,2.3:0.3:5,5.2:0.2:8]);
%     freqs = 1:200;
    
elseif strcmp(freq_band,'SpecDense')
    freqs = 2.^([0:0.25:2,2.15:0.15:5,5.1:0.1:8]);
    
elseif nargin < 6 || isempty(freq_band)
    freqs = 2.^([0:0.5:2,2.3:0.3:5,5.2:0.2:8]);
end

if nargin < 7 || isempty(span)
    span = 1;
end

if ~strcmp(freqs,'HFB') && (nargin < 9 || isempty(norm))
    norm = false;
end

if ~strcmp(freqs,'HFB') && (nargin < 10 || isempty(avgfreq))
    avgfreq = false;
end

% Load globalVar
fn = sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,bn);
load(fn,'globalVar');

if strcmp(freq_band,'HFB')
    dir_out = globalVar.HFBData;
else
    dir_out = globalVar.SpecData;
end

% Eletrode definition
if nargin < 5 || isempty(elecs)
    elecs = setdiff(1:globalVar.nchan,globalVar.refChan);
end

if nargin < 8 || isempty(fs_targ)
    if avgfreq
        fs_targ = 500;
    else
        fs_targ = 200;
    end
end

for ei = 1:length(elecs)
    el = elecs(ei);
    load(sprintf('%s/CARiEEG%s_%.2d.mat',globalVar.CARData,bn,el));
    
    data = WaveletFilter(data.wave,data.fsample,fs_targ,freqs,span,norm,avgfreq);
    data.label = globalVar.channame{el};
    if strcmp(freq_band,'HFB')
        fn_out = sprintf('%s/HFBiEEG%s_%.2d.mat',dir_out,bn,el);
    else
        fn_out = sprintf('%s/SpeciEEG%s_%.2d.mat',dir_out,bn,el);
    end
    save(fn_out,'data')
    disp(['Wavelet filtering: Block ', bn,', Elec ',num2str(el)])
end

end