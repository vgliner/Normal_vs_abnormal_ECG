function varargout = peakfinder(x0, sample_rate,handles, sel, thresh, extrema, include_endpoints)
%PEAKFINDER Noise tolerant fast ECG peak finding algorithm

%%  Divide to chunks because of serious DC bias over time
chunk_factor=15; %[required sec]
num_of_chunks=ceil(numel(diff(x0))/sample_rate/chunk_factor);
input_data=smooth(x0(~isnan(x0)),10);

PeakIndsTot=[];
for chunks_counter=1:num_of_chunks
        x0=input_data((chunks_counter-1)*sample_rate*chunk_factor+1:min([chunks_counter*sample_rate*chunk_factor length(input_data)]));
        s = size(x0);
%        if chunks_counter==1
        [polarity]=polarity_determination(x0);
 %       end
        flipData =  s(1) < s(2);
        len0 = numel(x0);
        if ~handles.if_hilbert
        x0=x0-mean(x0);% Take out bias % Vadim 29/7/2015
        end
        y0=x0;% Eliminatig the case of false high spike to wrong polarity % Vadim 29/7/2015
 
        if (polarity<0)
            x0=-x0;
        end
%         if abs(min(y0))>abs(max(y0))% Inverse signal if flipped % Vadim 29/7/2015
%             x0=-x0;
%         end
         if (handles.if_hilbert)
         y0=x0;    
         else
         y0=abs(diff(x0));    
         end
            [N,edges] = histcounts(y0,30);
            sel = (edges(max(find(N>14)))-min(y0))/2.5;% Changing selection threshold  % Vadim 29/7/2015 - Eliminatig P\T waves
            thresh=sel;

        if nargin < 4 || isempty(thresh)
            thresh = [];
        elseif ~isnumeric(thresh) || ~isreal(thresh)
            thresh = [];
            warning('PEAKFINDER:InvalidThreshold',...
                'The threshold must be a real scalar. No threshold will be used.')
        elseif numel(thresh) > 1
            thresh = thresh(1);
            warning('PEAKFINDER:InvalidThreshold',...
                'The threshold must be a scalar.  The first threshold value in the vector will be used.')
        end

        if nargin < 5 || isempty(extrema)
            extrema = 1;
        else
            extrema = sign(extrema(1)); % Should only be 1 or -1 but make sure
            if extrema == 0
                error('PEAKFINDER:ZeroMaxima','Either 1 (for maxima) or -1 (for minima) must be input for extrema');
            end
        end

        if nargin < 6 || isempty(include_endpoints)
            include_endpoints = true;
        else
            include_endpoints = boolean(include_endpoints);
        end

        x0 = extrema*x0(:); % Make it so we are finding maxima regardless
        thresh = thresh*extrema; % Adjust threshold according to extrema.
        dx0 = medfilt1(diff(x0)); % Find derivative
        dx0(dx0 == 0) = -eps; % This is so we find the first of repeated values
        ind = find((dx0(1:end-20)>0).*(dx0(2:end-19) < 0))+1; % Find where the derivative changes sign
        %plot(x0)
%         plot(diff(x0))     
%         hold on
        dx0=diff(x0);
%         plot(ind,dx0(ind),'ro')
        sel=2*mean(abs(dx0(abs(dx0)>0)));
        ind=ind(abs(dx0(max(ind-5,1)))>sel);
        ind=ind(ind>0);
        %%  Centralize index on the peak
        ind_cpy=[];
        if numel(ind)>2
            for loc_counter=1:numel(ind)
               [~, ind_cpy(loc_counter)]=max(abs(x0(max(1,ind(loc_counter)-10):min(numel(x0),ind(loc_counter)+10))));
               ind_cpy(loc_counter)=max(ind_cpy(loc_counter)-11+ind(loc_counter),1);
            end
        end
        ind=ind_cpy';
        % Include endpoints in potential peaks and valleys as desired
%         if include_endpoints
%             x = [x0(1);x0(ind);x0(end)];
%             ind = [1;ind;len0];
%             minMag = min(x);
%             leftMin = minMag;
%         else
%             x = x0(ind);
%             minMag = min(x);
%             leftMin = x0(1);
%         end
        x = x0(ind);
        minMag = min(x);
        leftMin = x0(1);
        % x only has the peaks, valleys, and possibly endpoints
        len = numel(x);

        if len > 2 % Function with peaks and valleys
            % Set initial parameters for loop
            tempMag = minMag;
            foundPeak = false;
            include_endpoints=0;
            if include_endpoints
                % Deal with first point a little differently since tacked it on
                % Calculate the sign of the derivative since we tacked the first 
                %  point on it does not neccessarily alternate like the rest.
                signDx = sign(diff(x(1:3)));
                if signDx(1) <= 0 % The first point is larger or equal to the second
                    if signDx(1) == signDx(2) % Want alternating signs
                        x(2) = [];
                        ind(2) = [];
                        len = len-1;
                    end
                else % First point is smaller than the second
                    if signDx(1) == signDx(2) % Want alternating signs
                        x(1) = [];
                        ind(1) = [];
                        len = len-1;
                    end
                end
            end

            % Skip the first point if it is smaller so we always start on a
            %   maxima
            if x(1) >= x(2)
                ii = 0;
            else
                ii = 1;
            end

            % Preallocate max number of maxima
            maxPeaks = ceil(len/2);
            peakLoc = zeros(maxPeaks,1);
            peakMag = zeros(maxPeaks,1);
            cInd = 1;
            % Loop through extrema which should be peaks and then valleys
        %    while ii < len
                ii = ii+1; % This is a peak
                % Reset peak finding if we had a peak and the next peak is bigger
                %   than the last or the left min was small enough to reset.
                if foundPeak
                    tempMag = minMag;
                    foundPeak = false;
                end

                % Make sure we don't iterate past the length of our vector
                if ii == len
                    break; % We assign the last point differently out of the loop
                end

                % Found new peak that was lager than temp mag and selectivity larger
                %   than the minimum to its left.
                if x(ii) > tempMag && x(ii) > leftMin + sel
                    tempLoc = ii;
                    tempMag = x(ii);
                end

                ii = ii+1; % Move onto the valley
                % Come down at least sel from peak
                if ~foundPeak && (tempMag > (sel + x(ii)))
                    foundPeak = true; % We have found a peak
                    leftMin = x(ii);
                    peakLoc(cInd) = tempLoc; % Add peak to index
                    peakMag(cInd) = tempMag;
                    cInd = cInd+1;
                elseif x(ii) < leftMin % New left minima
                    leftMin = x(ii);
                end
            end
            
%             % Check end point
%             if include_endpoints
%             if x(end) > tempMag && x(end) > leftMin + sel
%                 peakLoc(cInd) = len;
%                 peakMag(cInd) = x(end);
%                 cInd = cInd + 1;
%             elseif ~foundPeak && tempMag > minMag % Check if we still need to add the last point
%                 peakLoc(cInd) = tempLoc;
%                 peakMag(cInd) = tempMag;
%                 cInd = cInd + 1;
%             end
%             elseif ~foundPeak 
%                 if tempMag > x0(end) + sel
%                     peakLoc(cInd) = tempLoc;
%                     peakMag(cInd) = tempMag;
%                     cInd = cInd + 1;
%                 end
%             end
% 
%             % Create output
%             peakInds = ind(peakLoc(1:cInd-1));
%             peakMags = peakMag(1:cInd-1);
            peakInds = ind;
            peakMags = x0(ind);
%         else % This is a monotone function where an endpoint is the only peak
%             [peakMags,xInd] = max(x);
%             if include_endpoints && peakMags > minMag + sel
%                 peakInds = ind(xInd);
%             else
%                 peakMags = [];
%                 peakInds = [];
%             end
%         end

        % Apply threshold value.  Since always finding maxima it will always be
        %   larger than the thresh.
        if ~isempty(thresh)
            m = peakMags>thresh;
            peakInds = peakInds(m);
            peakMags = peakMags(m);
        end

        % Rotate data if needed
        if flipData
            peakMags = peakMags.';
            peakInds = peakInds.';
        end

        % Change sign of data if was finding minima
        if extrema < 0
            peakMags = -peakMags;
            x0 = -x0;
        end
        %end

        % Take out noise frequent spikes % Vadim 3/8/2015
        added_peaks=(peakInds+(chunks_counter-1)*sample_rate*chunk_factor);
        if ~isrow(added_peaks)
            added_peaks=added_peaks';
        end
        PeakIndsTot=[PeakIndsTot added_peaks];
end
peakInds=PeakIndsTot;
peakInds((diff(PeakIndsTot)<(60/5000*sample_rate)))=[];  %HR 180bpm
peakInds((diff(peakInds)<(60/300*sample_rate)))=[];  %HR 300bpm

varargout = {peakInds,peakMags};