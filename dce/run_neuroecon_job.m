function fitting_results = run_neuroecon_job(number_cpus, xdata, numvoxels, dce_model);

warning off
        
        p = pwd
        %n = '/home/thomasn/scripts/niftitools';
        n = niftipathfind();
        % for k = 1:totale
        sched = findResource('scheduler', 'configuration', 'NeuroEcon.local');
        set(sched, 'SubmitArguments', '-l walltime=5:00:00 -m abe -M thomasn@caltech.edu')
        
        jj = createMatlabPoolJob(sched, 'PathDependencies', {p});
        
        set(jj, 'MaximumNumberOfWorkers', number_cpus)
        set(jj, 'MinimumNumberOfWorkers', number_cpus)
        %         STARTEND(k,:)
        %         %We only feed the workers only the voxels that they can handle
        %
        %         xdata{1}.Ct = wholeCt(:,STARTEND(k,1):STARTEND(k,2));
        
        %Schedule object, neuroecon
        t = createTask(jj, @FXLfit_generic, 1,{xdata, numvoxels, dce_model});
        set(t, 'CaptureCommandWindowOutput', true);
        
        submit(jj)
        waitForState(jj,'finished')
        jj
        results = getAllOutputArguments(jj)
        destroy(jj)
        
        clear jj
        fitting_results = cell2mat(results);