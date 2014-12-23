function results = D_fit_voxels_batch_func(Ddatabatch)

% Load dataset variables
number_cpus = Ddatabatch.number_cpus ;
xdata = Ddatabatch.xdata       ;
numvoxels = Ddatabatch.numvoxels  ;
dce_model= Ddatabatch.dce_model   ;
number_rois = Ddatabatch.number_rois;
roi_name = Ddatabatch.roi_name;
roi_list = Ddatabatch.roi_list;
neuroecon = Ddatabatch.neuroecon;
close_pool = Ddatabatch.close_pool;
rootname  = Ddatabatch.rootname;
hdr = Ddatabatch.hdr;
outputft = Ddatabatch.outputft;
res = Ddatabatch.res;
sliceloc = Ddatabatch.sliceloc; % Known issue, may need to handle slice loc in output dcm, but ignore for now


fit_voxels = Ddatabatch.fit_voxels  ;
tumind = Ddatabatch.timind      ;
dynam_name = Ddatabatch.dynam_name  ;
PathName = Ddatabatch.PathName ;
time_smoothing = Ddatabatch.time_smoothing  ;
time_smoothing_window =Ddatabatch.smoothing_window  ;
currentimg = Ddatabatch.currentimg ;
results_a_path= Ddatabatch.results_a_path ;
results_b_path =Ddatabatch.results_b_path  ;

if dce_model.fxr   
    T1TUM=Ddatabatch.T1TUM ;
    relaxivity=Ddatabatch.relaxivity;
end



if number_rois
    roi_series_original= Ddatabatch.roi_series_original ;
    roi_series=Ddatabatch.roi_series;
    roi_r1=Ddatabatch.roi_r1;
    
    if dce_model.auc
        roi_series_signal=Ddatabatch.roi_series_signal;
    end
end



%% Run fit
cur_dce_model_list = {};

if dce_model.aif
    cur_dce_model_list{end+1} = 'aif';
end
if dce_model.aif_vp
    cur_dce_model_list{end+1} = 'aif_vp';
end
if dce_model.fxr
    cur_dce_model_list{end+1} = 'fxr';
end

if dce_model.fractal
    cur_dce_model_list{end+1} = 'fractal';
end
if dce_model.auc
    cur_dce_model_list{end+1} = 'auc';
end

% Run a for loop for every model.
for i = 1:numel(cur_dce_model_list)
    %fit_voxels = 0; %% DEBUG
    clear fitting_results;
    cur_dce_model = cur_dce_model_list{i};
    disp('  ');
    disp(['Begin making maps for ' cur_dce_model '...']);
    
    if(neuroecon)
        if strcmp(cur_dce_model, 'fxr')
            xdata{1}.R1o = 1./T1TUM;
            xdata{1}.R1i = 1./T1TUM;
            xdata{1}.relaxivity = relaxivity;
        end
        
        fitting_results = run_neuroecon_job(number_cpus, xdata, numvoxels, cur_dce_model);
        % x(STARTEND(k,1):STARTEND(k,2),:) = cell2mat(results);
    else
        if number_rois~=0
            disp(['Starting fitting for ' num2str(number_rois) ' ROIs...']);
            
            roi_data{1}.Cp = xdata{1}.Cp;
            roi_data{1}.timer = xdata{1}.timer;
            roi_data{1}.Ct = roi_series;
            
            if strcmp(cur_dce_model, 'fxr')
                roi_data{1}.R1o = roi_r1;
                roi_data{1}.R1i = roi_r1;
                roi_data{1}.relaxivity = relaxivity;
            end
            
            if strcmp(cur_dce_model, 'auc')
                roi_data{1}.Sttum = roi_series_signal;
            end
            
            [roi_results, roi_residuals] = FXLfit_generic(roi_data, number_rois, cur_dce_model);
            
            disp('ROI fitting done')
            disp(' ')
        end
        if fit_voxels
            disp(['Starting fitting for ' num2str(numvoxels) ' voxels...']);
            
            if strcmp(cur_dce_model, 'fxr')
                xdata{1}.R1o = 1./T1TUM;
                xdata{1}.R1i = 1./T1TUM;
                xdata{1}.relaxivity = relaxivity;
            end
            
            [fitting_results, voxel_residuals] = FXLfit_generic(xdata, numvoxels, cur_dce_model);
            
            disp('Voxel fitting done')
        end
    end
    % processing_time = toc;
    % disp(['processing completed in ' datestr(processing_time/86400, 'HH:MM:SS') ' (hr:min:sec)']);
    if close_pool
        matlabpool close;
    end
    
    % c) Save file
    %************************
    fit_data.fit_voxels = fit_voxels;
    fit_data.tumind = tumind;
    fit_data.dynam_name = dynam_name;
    fit_data.PathName = PathName;
    fit_data.time_smoothing = time_smoothing;
    fit_data.time_smoothing_window =time_smoothing_window;
    fit_data.model_name =cur_dce_model;
    fit_data.number_rois = number_rois;
    xdata{1}.dimensions = size(currentimg);
    
    if number_rois~=0
        xdata{1}.roi_series = roi_series;
        xdata{1}.roi_series_original = roi_series_original;
        fit_data.roi_results = roi_results;
        fit_data.roi_residuals = roi_residuals;
        fit_data.roi_name = roi_name;
        
        if strcmp(cur_dce_model, 'fxr')
            xdata{1}.roi_r1 = roi_r1;
            xdata{1}.relaxivity = relaxivity;
        end
        
        if strcmp(cur_dce_model, 'auc')
            xdata{1}.roi_series_signal = roi_series_signal;
        end
        
    end
    if fit_voxels
        fit_data.fitting_results  = fitting_results;
        fit_data.voxel_residuals = voxel_residuals;
    end
    
%     Ddata.xdata = xdata;
%     Ddata.fit_data = fit_data;
%     Ddata.results_a_path = results_a_path;
%     Ddata.results_b_path = results_b_path;
    
    save(fullfile(PathName, ['D_' rootname cur_dce_model '_fit_voxels.mat']),  'xdata','fit_data','results_a_path','results_b_path')
    results = fullfile(PathName, ['D_' rootname cur_dce_model '_fit_voxels.mat']);
    Opt.Input = 'file';
    mat_md5 = DataHash(results, Opt);
    disp(' ')
    disp('MAT results saved to: ')
    disp(results)
    disp(['File MD5 hash: ' mat_md5])
    
    % d) Check if physiologically possible, if not, remove
    %************************
    % checkind = find(x(:,1) < 0);
    % x(checkind,:) = [];
    % tumind(checkind) = [];
    
    % ve > 1
    % checkind = find(x(:,2) > 1);
    % x(checkind,:) = [];
    % tumind(checkind) = [];
    %
    % % ve < 0
    % checkind = find(x(:,2) < 0);
    % x(checkind,:) = [];
    % tumind(checkind) = [];
    %
    % % vp > 1
    % checkind = find(x(:,3) > 1);
    % x(checkind,:) = [];
    % tumind(checkind) = [];
    %
    % % vp < 0
    % checkind = find(x(:,3) < 0);
    % x(checkind,:) = [];
    % tumind(checkind) = [];
    %
    % % Ktrans > 3
    % checkind = find(x(:,1) > 3);
    % x(checkind,:) = [];
    % tumind(checkind) = [];
    %
    % % Ktrans < 0
    % checkind = find(x(:,1) < 0);
    % x(checkind,:) = [];
    % tumind(checkind) = [];
    %
    % %% d.2) Check R2 fit
    %
    % checkind = find(x(:,4) < r2filter);
    % x(checkind,:)    = [];
    % tumind(checkind) = [];
    
    
    % f) Make maps and Save image files
    %************************
    %fit_voxels = 0; %% DEBUG
    %[discard, actual] = fileparts(strrep(dynam_name, '\', '/'));
    
    if strcmp(cur_dce_model, 'aif')
        dce_model_name = 'aif';
        % Write ROI results
        if number_rois~=0
            headings = {'ROI path', 'ROI', 'Ktrans', 'Ve','Residual', 'Ktrans 95% low', ...
                'Ktrans 95% high', 'Ve 95% low', 'Ve 95% high'};
            roi_results(:,3) = []; %erase vp column
            xls_results = [roi_list roi_name mat2cell(roi_results,ones(1,size(roi_results,1)),ones(1,size(roi_results,2)))];
            xls_results = [headings; xls_results];
            xls_path = fullfile(PathName, [rootname dce_model_name '_rois.xls']);
            xlswrite(xls_path,xls_results);
        end
        % Write voxel results
        if fit_voxels
            % Parameter name
            paramname = {'Ktrans'; 've'; 'residual'; 'ktrans_ci_low'; 'ktrans_ci_high'; 've_ci_low';'ve_ci_high'};
            
            % Setup img files
            
            for k = 1:numel(paramname)
                curimg = zeros(size(currentimg));
                curimg(tumind) = fitting_results(:,k);
                OUTPUT(k).IMG = curimg;
            end
            
            if outputft == 1
                % NIFTI
                KtransROI = zeros(size(currentimg));
                veROI     = zeros(size(currentimg));
                residual  = zeros(size(currentimg));
                ci_95_low_ktrans	= zeros(size(currentimg));
                ci_95_high_ktrans	= zeros(size(currentimg));
                ci_95_low_ve		= zeros(size(currentimg));
                ci_95_high_ve		= zeros(size(currentimg));
                
                KtransROI(tumind) = fitting_results(:,1);
                veROI(tumind)     = fitting_results(:,2);
                residual(tumind)  = fitting_results(:,4);
                ci_95_low_ktrans(tumind)	= fitting_results(:,5);
                ci_95_high_ktrans(tumind)	= fitting_results(:,6);
                ci_95_low_ve(tumind)		= fitting_results(:,7);
                ci_95_high_ve(tumind)		= fitting_results(:,8);
                
                nii_path{1} = fullfile(PathName, [rootname dce_model_name '_Ktrans.nii']);
                nii_path{2} = fullfile(PathName, [rootname dce_model_name '_ve.nii']);
                nii_path{3} = fullfile(PathName, [rootname dce_model_name '_residual.nii']);
                nii_path{4} = fullfile(PathName, [rootname dce_model_name '_ktrans_ci_low.nii']);
                nii_path{5} = fullfile(PathName, [rootname dce_model_name '_ktrans_ci_high.nii']);
                nii_path{6} = fullfile(PathName, [rootname dce_model_name '_ve_ci_low.nii']);
                nii_path{7} = fullfile(PathName, [rootname dce_model_name '_ve_ci_high.nii']);
                
                save_nii(make_nii(KtransROI, res, [1 1 1]), nii_path{1});
                save_nii(make_nii(veROI, res, [1 1 1]), nii_path{2});
                save_nii(make_nii(residual, res, [1 1 1]), nii_path{3});
                save_nii(make_nii(ci_95_low_ktrans, res, [1 1 1]), nii_path{4});
                save_nii(make_nii(ci_95_high_ktrans, res, [1 1 1]), nii_path{5});
                save_nii(make_nii(ci_95_low_ve, res, [1 1 1]), nii_path{6});
                save_nii(make_nii(ci_95_high_ve, res, [1 1 1]), nii_path{7});
            elseif outputft == 2
                % 3D DICOM
                
                for k = 1:numel(paramname)
                    
                    nii_path{k} = fullfile(PathName, [rootname dce_model_name '_' paramname{k} '.dcm']);
                    curimg = OUTPUT(k).IMG;
                    
                    [newIMG, slope, intercept] = double2uint16Scale(curimg);
                    
                    if isDICOMhdr(hdr)
                        % Then we write using the dicom hdr from before
                        dicomwrite(reshape(uint16(newIMG), [size(curimg,1) size(curimg,2) 1 size(curimg,3)]),nii_path{k}, ...
                            'RescaleIntercept', intercept, 'RescaleSlope', slope, ...
                            'PixelSpacing', res(1:2)', 'SliceThickness', res(3), hdr, 'MultiframeSingleFile', 1);
                    else
                        % Then we write using the dicom hdr from before
                        dicomwrite(reshape(uint16(newIMG), [size(curimg,1) size(curimg,2) 1 size(curimg,3)]),nii_path{k}, ...
                            'RescaleIntercept', intercept, 'RescaleSlope', slope, ...
                            'PixelSpacing', res(1:2)', 'SliceThickness', res(3),  'MultiframeSingleFile', 1);
                    end
                    
                end
            elseif outputft == 3
                
                for k = 1:numel(paramname)
                    
                    nii_path{k} = fullfile(PathName, [rootname dce_model_name '_' paramname{k} '.dcm']);
                    curimg = OUTPUT(k).IMG;
                    
                    [newIMG, slope, intercept] = double2uint16Scale(curimg);
                    
                    if isDICOMhdr(hdr)
                        % Then we write using the dicom hdr from before
                        dicomwrite(reshape(uint16(newIMG), [size(curimg,1) size(curimg,2) 1 size(curimg,3)]),nii_path{k}, ...
                            'ObjectType', 'MR Image Storage', 'RescaleIntercept', intercept, 'RescaleSlope', slope, ...
                            'PixelSpacing', res(1:2)', 'SliceThickness', res(3), hdr, 'MultiframeSingleFile', 0);
                    else
                        % Then we write using the dicom hdr from before
                        dicomwrite(reshape(uint16(newIMG), [size(curimg,1) size(curimg,2) 1 size(curimg,3)]),nii_path{k}, ...
                            'ObjectType', 'MR Image Storage', 'RescaleIntercept', intercept, 'RescaleSlope', slope, ...
                            'PixelSpacing', res(1:2)', 'SliceThickness', res(3),  'MultiframeSingleFile', 0);
                    end
                    
                end
            end
        end
    elseif strcmp(cur_dce_model, 'aif_vp')
        dce_model_name = 'aif_vp';
        % Write ROI results
        if number_rois~=0
            headings = {'ROI path', 'ROI', 'Ktrans', 'Ve','Vp','Residual', 'Ktrans 95% low', ...
                'Ktrans 95% high', 'Ve 95% low', 'Ve 95% high','Vp 95% low','Vp 95% high'};
            xls_results = [roi_list roi_name mat2cell(roi_results,ones(1,size(roi_results,1)),ones(1,size(roi_results,2)))];
            xls_results = [headings; xls_results];
            xls_path = fullfile(PathName, [rootname dce_model_name '_rois.xls']);
            xlswrite(xls_path,xls_results);
        end
        % Write voxel results
        if fit_voxels
            
            % Parameter name
            paramname = {'Ktrans'; 've'; 'vp'; 'residual'; 'ktrans_ci_low'; 'ktrans_ci_high'; 've_ci_low';'ve_ci_high'; 'vp_ci_low'; 'vp_ci_high'};
            
            % Setup img files
            
            for k = 1:numel(paramname)
                curimg = zeros(size(currentimg));
                curimg(tumind) = fitting_results(:,k);
                OUTPUT(k).IMG = curimg;
            end
            
            if outputft == 1
                % NIFTI
                KtransROI = zeros(size(currentimg));
                veROI     = zeros(size(currentimg));
                vpROI     = zeros(size(currentimg));
                residual  = zeros(size(currentimg));
                ci_95_low_ktrans	= zeros(size(currentimg));
                ci_95_high_ktrans	= zeros(size(currentimg));
                ci_95_low_ve		= zeros(size(currentimg));
                ci_95_high_ve		= zeros(size(currentimg));
                ci_95_low_vp		= zeros(size(currentimg));
                ci_95_high_vp		= zeros(size(currentimg));
                
                KtransROI(tumind) = fitting_results(:,1);
                veROI(tumind)     = fitting_results(:,2);
                vpROI(tumind)     = fitting_results(:,3);
                residual(tumind)  = fitting_results(:,4);
                ci_95_low_ktrans(tumind)	= fitting_results(:,5);
                ci_95_high_ktrans(tumind)	= fitting_results(:,6);
                ci_95_low_ve(tumind)		= fitting_results(:,7);
                ci_95_high_ve(tumind)		= fitting_results(:,8);
                ci_95_low_vp(tumind)		= fitting_results(:,9);
                ci_95_high_vp(tumind)		= fitting_results(:,10);
                
                nii_path{1} = fullfile(PathName, [rootname dce_model_name '_Ktrans.nii']);
                nii_path{2} = fullfile(PathName, [rootname dce_model_name '_ve.nii']);
                nii_path{3} = fullfile(PathName, [rootname dce_model_name '_vp.nii']);
                nii_path{4} = fullfile(PathName, [rootname dce_model_name '_residual.nii']);
                nii_path{5} = fullfile(PathName, [rootname dce_model_name '_ktrans_ci_low.nii']);
                nii_path{6} = fullfile(PathName, [rootname dce_model_name '_ktrans_ci_high.nii']);
                nii_path{7} = fullfile(PathName, [rootname dce_model_name '_ve_ci_low.nii']);
                nii_path{8} = fullfile(PathName, [rootname dce_model_name '_ve_ci_high.nii']);
                nii_path{9} = fullfile(PathName, [rootname dce_model_name '_vp_ci_low.nii']);
                nii_path{10} = fullfile(PathName, [rootname dce_model_name '_vp_ci_high.nii']);
                
                save_nii(make_nii(KtransROI, res, [1 1 1]), nii_path{1});
                save_nii(make_nii(veROI, res, [1 1 1]), nii_path{2});
                save_nii(make_nii(vpROI, res, [1 1 1]), nii_path{3});
                save_nii(make_nii(residual, res, [1 1 1]), nii_path{4});
                save_nii(make_nii(ci_95_low_ktrans, res, [1 1 1]), nii_path{5});
                save_nii(make_nii(ci_95_high_ktrans, res, [1 1 1]), nii_path{6});
                save_nii(make_nii(ci_95_low_ve, res, [1 1 1]), nii_path{7});
                save_nii(make_nii(ci_95_high_ve, res, [1 1 1]), nii_path{8});
                save_nii(make_nii(ci_95_low_vp, res, [1 1 1]), nii_path{9});
                save_nii(make_nii(ci_95_high_vp, res, [1 1 1]), nii_path{10});
            elseif outputft == 2
                % 3D DICOM
                
                
                for k = 1:numel(paramname)
                    
                    nii_path{k} = fullfile(PathName, [rootname dce_model_name '_' paramname{k} '.dcm']);
                    curimg = OUTPUT(k).IMG;
                    
                    [newIMG, slope, intercept] = double2uint16Scale(curimg);
                    
                    if isDICOMhdr(hdr)
                        % Then we write using the dicom hdr from before
                        dicomwrite(reshape(uint16(newIMG), [size(curimg,1) size(curimg,2) 1 size(curimg,3)]),nii_path{k}, ...
                            'RescaleIntercept', intercept, 'RescaleSlope', slope, ...
                            'PixelSpacing', res(1:2)', 'SliceThickness', res(3), hdr, 'MultiframeSingleFile', 1);
                    else
                        % Then we write using the dicom hdr from before
                        dicomwrite(reshape(uint16(newIMG), [size(curimg,1) size(curimg,2) 1 size(curimg,3)]),nii_path{k}, ...
                            'RescaleIntercept', intercept, 'RescaleSlope', slope, ...
                            'PixelSpacing', res(1:2)', 'SliceThickness', res(3),  'MultiframeSingleFile', 1);
                    end
                    
                end
            elseif outputft == 3
                for k = 1:numel(paramname)
                    
                    nii_path{k} = fullfile(PathName, [rootname dce_model_name '_' paramname{k} '.dcm']);
                    curimg = OUTPUT(k).IMG;
                    
                    [newIMG, slope, intercept] = double2uint16Scale(curimg);
                    
                    if isDICOMhdr(hdr)
                        % Then we write using the dicom hdr from before
                        dicomwrite(reshape(uint16(newIMG), [size(curimg,1) size(curimg,2) 1 size(curimg,3)]),nii_path{k}, ...
                            'ObjectType', 'MR Image Storage', 'RescaleIntercept', intercept, 'RescaleSlope', slope, ...
                            'PixelSpacing', res(1:2)', 'SliceThickness', res(3), hdr, 'MultiframeSingleFile', 0);
                    else
                        % Then we write using the dicom hdr from before
                        dicomwrite(reshape(uint16(newIMG), [size(curimg,1) size(curimg,2) 1 size(curimg,3)]),nii_path{k}, ...
                            'ObjectType', 'MR Image Storage', 'RescaleIntercept', intercept, 'RescaleSlope', slope, ...
                            'PixelSpacing', res(1:2)', 'SliceThickness', res(3),  'MultiframeSingleFile', 0);
                    end
                    
                end
            end
        end
    elseif strcmp(cur_dce_model, 'fxr')
        dce_model_name = 'fxr';
        % Write ROI results
        if number_rois~=0
            headings = {'ROI path', 'ROI', 'Ktrans', 'Ve','Tau','Residual', 'Ktrans 95% low', ...
                'Ktrans 95% high', 'Ve 95% low', 'Ve 95% high','Tau 95% low','Tau 95% high'};
            xls_results = [roi_list roi_name mat2cell(roi_results,ones(1,size(roi_results,1)),ones(1,size(roi_results,2)))];
            xls_results = [headings; xls_results];
            xls_path = fullfile(PathName, [rootname dce_model_name '_rois.xls']);
            xlswrite(xls_path,xls_results);
        end
        % Write voxel results
        if fit_voxels
            
            % Parameter name
            paramname = {'Ktrans'; 've'; 'tau'; 'residual'; 'ktrans_ci_low'; 'ktrans_ci_high'; 've_ci_low';'ve_ci_high'; 'tau_ci_low'; 'tau_ci_high'};
            
            % Setup img files
            
            for k = 1:numel(paramname)
                curimg = zeros(size(currentimg));
                curimg(tumind) = fitting_results(:,k);
                OUTPUT(k).IMG = curimg;
            end
            
            if outputft == 1
                % NIFTI
                KtransROI = zeros(size(currentimg));
                veROI     = zeros(size(currentimg));
                tauROI     = zeros(size(currentimg));
                residual  = zeros(size(currentimg));
                ci_95_low_ktrans	= zeros(size(currentimg));
                ci_95_high_ktrans	= zeros(size(currentimg));
                ci_95_low_ve		= zeros(size(currentimg));
                ci_95_high_ve		= zeros(size(currentimg));
                ci_95_low_tau		= zeros(size(currentimg));
                ci_95_high_tau		= zeros(size(currentimg));
                
                KtransROI(tumind) = fitting_results(:,1);
                veROI(tumind)     = fitting_results(:,2);
                tauROI(tumind)     = fitting_results(:,3);
                residual(tumind)  = fitting_results(:,4);
                ci_95_low_ktrans(tumind)	= fitting_results(:,5);
                ci_95_high_ktrans(tumind)	= fitting_results(:,6);
                ci_95_low_ve(tumind)		= fitting_results(:,7);
                ci_95_high_ve(tumind)		= fitting_results(:,8);
                ci_95_low_tau(tumind)		= fitting_results(:,9);
                ci_95_high_tau(tumind)		= fitting_results(:,10);
                
                nii_path{1} = fullfile(PathName, [rootname dce_model_name '_Ktrans.nii']);
                nii_path{2} = fullfile(PathName, [rootname dce_model_name '_ve.nii']);
                nii_path{3} = fullfile(PathName, [rootname dce_model_name '_tau.nii']);
                nii_path{4} = fullfile(PathName, [rootname dce_model_name '_residual.nii']);
                nii_path{5} = fullfile(PathName, [rootname dce_model_name '_ktrans_ci_low.nii']);
                nii_path{6} = fullfile(PathName, [rootname dce_model_name '_ktrans_ci_high.nii']);
                nii_path{7} = fullfile(PathName, [rootname dce_model_name '_ve_ci_low.nii']);
                nii_path{8} = fullfile(PathName, [rootname dce_model_name '_ve_ci_high.nii']);
                nii_path{9} = fullfile(PathName, [rootname dce_model_name '_tau_ci_low.nii']);
                nii_path{10} = fullfile(PathName, [rootname dce_model_name '_tau_ci_high.nii']);
                
                save_nii(make_nii(KtransROI, res, [1 1 1]), nii_path{1});
                save_nii(make_nii(veROI, res, [1 1 1]), nii_path{2});
                save_nii(make_nii(tauROI, res, [1 1 1]), nii_path{3});
                save_nii(make_nii(residual, res, [1 1 1]), nii_path{4});
                save_nii(make_nii(ci_95_low_ktrans, res, [1 1 1]), nii_path{5});
                save_nii(make_nii(ci_95_high_ktrans, res, [1 1 1]), nii_path{6});
                save_nii(make_nii(ci_95_low_ve, res, [1 1 1]), nii_path{7});
                save_nii(make_nii(ci_95_high_ve, res, [1 1 1]), nii_path{8});
                save_nii(make_nii(ci_95_low_tau, res, [1 1 1]), nii_path{9});
                save_nii(make_nii(ci_95_high_tau, res, [1 1 1]), nii_path{10});
            elseif outputft == 2
                % 3D DICOM
                
                
                for k = 1:numel(paramname)
                    
                    nii_path{k} = fullfile(PathName, [rootname dce_model_name '_' paramname{k} '.dcm']);
                    curimg = OUTPUT(k).IMG;
                    
                    [newIMG, slope, intercept] = double2uint16Scale(curimg);
                    
                    if isDICOMhdr(hdr)
                        % Then we write using the dicom hdr from before
                        dicomwrite(reshape(uint16(newIMG), [size(curimg,1) size(curimg,2) 1 size(curimg,3)]),nii_path{k}, ...
                            'RescaleIntercept', intercept, 'RescaleSlope', slope, ...
                            'PixelSpacing', res(1:2)', 'SliceThickness', res(3), hdr, 'MultiframeSingleFile', 1);
                    else
                        % Then we write using the dicom hdr from before
                        dicomwrite(reshape(uint16(newIMG), [size(curimg,1) size(curimg,2) 1 size(curimg,3)]),nii_path{k}, ...
                            'RescaleIntercept', intercept, 'RescaleSlope', slope, ...
                            'PixelSpacing', res(1:2)', 'SliceThickness', res(3),  'MultiframeSingleFile', 1);
                    end
                    
                end
            elseif outputft == 3
                for k = 1:numel(paramname)
                    
                    nii_path{k} = fullfile(PathName, [rootname dce_model_name '_' paramname{k} '.dcm']);
                    curimg = OUTPUT(k).IMG;
                    
                    [newIMG, slope, intercept] = double2uint16Scale(curimg);
                    
                    if isDICOMhdr(hdr)
                        % Then we write using the dicom hdr from before
                        dicomwrite(reshape(uint16(newIMG), [size(curimg,1) size(curimg,2) 1 size(curimg,3)]),nii_path{k}, ...
                            'ObjectType', 'MR Image Storage', 'RescaleIntercept', intercept, 'RescaleSlope', slope, ...
                            'PixelSpacing', res(1:2)', 'SliceThickness', res(3), hdr, 'MultiframeSingleFile', 0);
                    else
                        % Then we write using the dicom hdr from before
                        dicomwrite(reshape(uint16(newIMG), [size(curimg,1) size(curimg,2) 1 size(curimg,3)]),nii_path{k}, ...
                            'ObjectType', 'MR Image Storage', 'RescaleIntercept', intercept, 'RescaleSlope', slope, ...
                            'PixelSpacing', res(1:2)', 'SliceThickness', res(3),  'MultiframeSingleFile', 0);
                    end
                    
                end
            end
        end
    elseif strcmp(cur_dce_model, 'fractal')
    elseif strcmp(cur_dce_model, 'auc')
        
        dce_model_name = 'auc';
        % Write ROI results
        if number_rois~=0
            headings = {'ROI path', 'ROI', 'AUC conc', 'AUC sig','NAUC conc', 'NAUC sig'};
            
            xls_results = [roi_list roi_name mat2cell(roi_results,ones(1,size(roi_results,1)),ones(1,size(roi_results,2)))];
            xls_results = [headings; xls_results];
            xls_path = fullfile(PathName, [rootname dce_model_name '_rois.xls']);
            xlswrite(xls_path,xls_results);
        end
        
        % Write voxel results
        if fit_voxels
            
            
            % Parameter name
            paramname = {'AUCc'; 'AUCs'; 'NAUCc'; 'NAUCs'};
            
            % Setup img files
            
            for k = 1:numel(paramname)
                curimg = zeros(size(currentimg));
                curimg(tumind) = fitting_results(:,k);
                OUTPUT(k).IMG = curimg;
            end
            
            if outputft == 1
                % NIFTI
                
                AUCc     = zeros(size(currentimg));
                AUCs     = zeros(size(currentimg));
                NAUCc    = zeros(size(currentimg));
                NAUCs    = zeros(size(currentimg));
                
                
                AUCc(tumind)     = fitting_results(:,1);
                AUCs(tumind)     = fitting_results(:,2);
                NAUCc(tumind)    = fitting_results(:,3);
                NAUCs(tumind)    = fitting_results(:,4);
                
                nii_path{1} = fullfile(PathName, [rootname dce_model_name '_AUCc.nii']);
                nii_path{2} = fullfile(PathName, [rootname dce_model_name '_AUCs.nii']);
                nii_path{3} = fullfile(PathName, [rootname dce_model_name '_NAUCc.nii']);
                nii_path{4} = fullfile(PathName, [rootname dce_model_name '_NAUCs.nii']);
                
                
                save_nii(make_nii(AUCc, res, [1 1 1]), nii_path{1});
                save_nii(make_nii(AUCs, res, [1 1 1]), nii_path{2});
                save_nii(make_nii(NAUCc, res, [1 1 1]), nii_path{3});
                save_nii(make_nii(NAUCs, res, [1 1 1]), nii_path{4});
                
            elseif outputft == 2
                % 3D DICOM
            
                for k = 1:numel(paramname)
                    
                    nii_path{k} = fullfile(PathName, [rootname dce_model_name '_' paramname{k} '.dcm']);
                    curimg = OUTPUT(k).IMG;
                    
                    [newIMG, slope, intercept] = double2uint16Scale(curimg);
                    
                    if isDICOMhdr(hdr)
                        % Then we write using the dicom hdr from before
                        dicomwrite(reshape(uint16(newIMG), [size(curimg,1) size(curimg,2) 1 size(curimg,3)]),nii_path{k}, ...
                            'RescaleIntercept', intercept, 'RescaleSlope', slope, ...
                            'PixelSpacing', res(1:2)', 'SliceThickness', res(3), hdr, 'MultiframeSingleFile', 1);
                    else
                        % Then we write using the dicom hdr from before
                        dicomwrite(reshape(uint16(newIMG), [size(curimg,1) size(curimg,2) 1 size(curimg,3)]),nii_path{k}, ...
                            'RescaleIntercept', intercept, 'RescaleSlope', slope, ...
                            'PixelSpacing', res(1:2)', 'SliceThickness', res(3),  'MultiframeSingleFile', 1);
                    end
                    
                end
            elseif outputft == 3
                for k = 1:numel(paramname)
                    
                    nii_path{k} = fullfile(PathName, [rootname dce_model_name '_' paramname{k} '.dcm']);
                    curimg = OUTPUT(k).IMG;
                    
                    [newIMG, slope, intercept] = double2uint16Scale(curimg);
                    
                    if isDICOMhdr(hdr)
                        % Then we write using the dicom hdr from before
                        dicomwrite(reshape(uint16(newIMG), [size(curimg,1) size(curimg,2) 1 size(curimg,3)]),nii_path{k}, ...
                            'ObjectType', 'MR Image Storage', 'RescaleIntercept', intercept, 'RescaleSlope', slope, ...
                            'PixelSpacing', res(1:2)', 'SliceThickness', res(3), hdr, 'MultiframeSingleFile', 0);
                    else
                        % Then we write using the dicom hdr from before
                        dicomwrite(reshape(uint16(newIMG), [size(curimg,1) size(curimg,2) 1 size(curimg,3)]),nii_path{k}, ...
                            'ObjectType', 'MR Image Storage', 'RescaleIntercept', intercept, 'RescaleSlope', slope, ...
                            'PixelSpacing', res(1:2)', 'SliceThickness', res(3),  'MultiframeSingleFile', 0);
                    end
                    
                end
     
            end
            
        end
        
        
        
    else
        error('Model not supported');
    end
    
    % Calculate file hashes and log them
    Opt.Input = 'file';
    if number_rois~=0
        xls_md5 = DataHash(xls_path, Opt);
        disp(' ')
        disp('ROI results saved to: ')
        disp(xls_path)
        disp(['File MD5 hash: ' xls_md5])
    end
    if fit_voxels
        disp(' ')
        disp('Voxel results saved to: ')
        for i=1:numel(nii_path)
            nii_md5 = DataHash(nii_path{i}, Opt);
            disp(nii_path{i})
            disp(['File MD5 hash: ' nii_md5])
        end
    end
    
    disp(['Finished making maps for ' cur_dce_model '...']);
    
end