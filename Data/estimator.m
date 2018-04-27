function [] = estimator(trainDir, testDir, outDir)
    
    files = dir(fullfile(testDir, '*.mat'));
    
    for fileIndex = 1:length(files)
        
        load(files(fileIndex).name);
        % if sig only has 5 rows instead of 6
        if(length(max(sig')) == 5)
            sss = [zeros(1, 37250); sig];
            sig = sss;
        end

        % Read data input
        x1 = sig(2, :);
        x2 = sig(3, :);
        % Adding both channels of ppg
        x = (x1+x2);

        % Fs = 125;
        % L = 37937;
        % F=(-L/2:L/2-1)*Fs/L;
        % figure;
        % plot(F, fftshift(abs((fft(x)))));

        % Filtering noise. Only allowing 0.5 Hz to 4 Hz
        [b,a]=butter(1,[0.5 4]/(125/2),'bandpass');
        out = filter(b, a, x);
        % figure;
        % plot(out);
        % figure;
        % plot(F, fftshift(abs(fft(out))));

        s = abs(spectrogram(out, 1000, 750,[] , 125));
        sMax = max(s);

        sInd = zeros(length(sMax), 1);

        for i=1:length(sMax)
            for j=1:length(s(:,i))
                if(s(j,i) == sMax(i))
                    sInd(i) = j;
                end
            end
        end

        est_bpm = (513/65) * sInd - 10;
        est_bpm2 = est_bpm;
        for i=6:length(sInd)
            est_bpm2(i) = est_bpm(i-1) + est_bpm(i-2) + est_bpm(i-3) + est_bpm(i-4) + est_bpm(i-5);
            est_bpm2(i) = est_bpm2(i)/5;
        end
        pred = est_bpm2(1:125);
        if(outDir(length(outDir)) ~= '/')
            outDir(length(outDir)+1) = '/';
        end
        save(strcat(outDir, 'output_team_06_', files(fileIndex).name), 'pred');
    end
end