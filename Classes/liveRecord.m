classdef liveRecord < handle
	
	
	properties
		
		saverData  %dirPath,   filename,      notes
		daqData    %srate,     chList,        gain
		
		plotHandles
		guiHandles
		
		chCount %int number of active channels
		srate
		aiObj
		
		trial
		
		growingRawData
		growingTimes
		growth
		
		totalRawData
		totalTimes
		
		axesHandles
		sampleCounter
		samplesObtained
		movingData
		
		
		axesData
		
		moveSwitch
		xMax = 10;
		yMax = 5;
    end
	
    
	methods
		function obj = liveRecord(saverData, daqData, handles)
			obj.saverData = saverData;
			obj.trial = 1;
			obj.daqData = daqData;
			obj.srate = daqData.srate;
			obj.chCount = size(daqData.chList,2);
			
			obj.guiHandles = handles;
			obj.plotHandles = {obj.guiHandles.plot1 obj.guiHandles.plot2 obj.guiHandles.plot3 obj.guiHandles.plot4 ...
                             obj.guiHandles.plot5 obj.guiHandles.plot6 obj.guiHandles.plot7 obj.guiHandles.plot8};
			obj.axesData = repmat([1 1 0],8,1); %matrix containing xScale, yScale, source for each axis. each row = one axis
		end
		
		function resetUI(obj)
			ai = analoginput('winsound',0);       %create daq object
			ai.BufferingMode = 'Auto';        %let daq control buffering
			ai.SampleRate = obj.srate;        %set daq samplerate
			ai.SamplesPerTrigger = inf;       %we will be continuously plotting data
			ai.TimerPeriod = .1;              %frequency plot gets updated
			ai.TimerFcn = {@obj.timerCbFunc}; %function that gets called when timer goes off
			addchannel(ai, obj.daqData.chList);            %collect data from this channel
			%ai.Channel.GainPerChan = obj.daqData.gain;    %ranges of voltage will vary from -2.5-2.5, maximum resolution
			
			obj.aiObj = ai;                       %save reference to ai in object
            
            %reset variables used to plot and acquire data
			obj.growth = 0;                       
			obj.totalTimes = [];                  
			obj.totalRawData = [];
			obj.growingRawData = [];
			obj.growingTimes = [];
			obj.movingData = [];
			obj.samplesObtained = 0;
			obj.moveSwitch = 0;
		end
		
		function timerCbFunc(obj, ai, event)
			c=min(floor(ai.SampleRate*ai.TimerPeriod),ai.SamplesAvailable);
			
			%COLLECT DATA
			if c~=0
				[data, time] = getdata(ai, c);
				
				obj.samplesObtained = obj.samplesObtained + c;              %keep track of how many samples are acquired
				obj.guiHandles.samplesText.String = sprintf('%07d Samples',obj.samplesObtained); %print number of samples acquired
				obj.guiHandles.timeText.String = sprintf('%i s',time(end)); %print relative time of last sample in seconds
				
				yLim = obj.yMax; %determined by the yMax edit box
				
				obj.growingRawData = [obj.growingRawData; data]; %add data vertically to this matrix
				obj.totalRawData = [obj.totalRawData; data];     %append to this array, gets saved at the end
				%for a = 1:obj.chCount %also the width of the data arrays
				%	obj.movingData(:,a) = obj.growingRawData(:,a) - mean(obj.growingRawData(:,a));
				%end
				obj.growingTimes = [obj.growingTimes; time]; %data to plot on x axis
				lastTime = obj.growingTimes(end); %this is used to set x axis limits later
				obj.growth = obj.growth + 1; %increment growth
				ad = obj.axesData;
				
				%PLOT DATA
				for i = 1:8                                      %each plot
					if ad(i,3) ~= 0                              %if that axis is set to display data
						ax = obj.plotHandles{i};                 %point to axis
						yrange = [-ad(i,2)*yLim ad(i,2)*yLim];   %ylim will always be yscale * yLim
						source = ad(i,3);                        %active axis?
						xOffset = 10*ad(i,1)*obj.srate;          %if moving axis, move by this much
	
						
						switch obj.moveSwitch
							case 0           %not yet 8 seconds
								if obj.samplesObtained <= xOffset     %dont move
									xDat = obj.growingTimes(:);
									yDat = obj.growingRawData(:,source);
									plot(ax,xDat,yDat);
									xlim(ax, [0 ad(i,1)*10])      %xmax is xscale times 10 i.e. xscale seconds
								else
									xDat = obj.growingTimes(end-xOffset:end);           %only graph time of the last xOffset values
									yDat = obj.growingRawData(end-xOffset:end,source);  %same
									plot(ax,xDat,yDat); 
									xlim(ax, [lastTime-ad(i,1)*8 lastTime+ad(i,1)*2])   %set axis limit to effectively capture only range of xDat
								end
							case 1
								xDat = obj.growingTimes(end-.8*xOffset:end);
								yDat = obj.growingRawData(end-.8*xOffset:end,source);
								plot(ax,xDat,yDat);
								xlim(ax, [lastTime-ad(i,1)*8 lastTime+ad(i,1)*2])
						end
						ylim(ax, yrange)
					end
				end
				
				
				%MANAGE DATA
				if obj.growth == 80         %start moving the graphs no matter what here
					obj.moveSwitch = 1;     
				end
				if obj.growth == 110        %'clear the memory'
					obj.growth = 0;
					offset = 10*obj.srate;
					obj.growingRawData = obj.growingRawData(end-offset:end,:);    %only keep 10 seconds worth of data at a time
					%obj.totalTimes = [obj.totalTimes; obj.growingTimes];          
					obj.growingTimes = obj.growingTimes(end-offset:end);
				end
            end
		end
		
		function chAxes(obj, axID, colID, newVal)
			obj.axesData(axID,colID) = newVal; % colID 1-> xScale
													% 2-> yScale
											  	 % 3-> source's chList index
        end
        
        function chGlobY(obj, newVal) %change global Y
            obj.yMax = newVal;
        end
		
		function start(obj)
			start(obj.aiObj); %trigger daq and begin timer
		end
		
		function stop(obj)
			stop(obj.aiObj)
			sd = obj.saverData;
			cd(sd.dirPath);
			dat = {sd.notes obj.totalRawData};
			fname = [sd.filename sprintf('%d',obj.trial) '.mat'];
			save(fname, 'dat')
			delete(obj.aiObj);
			clear obj.aiObj;    %clear from memory
			obj.trial = obj.trial+1;     %incremenet name of file by 1
		end
		
	end
	
	
end

