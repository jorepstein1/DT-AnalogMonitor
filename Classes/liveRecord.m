classdef liveRecord < handle
	
	
	properties
		
		saverData  %dirPath,   filename,      notes
		daqData    %srate,     chList,        gain
		guiHandles %plots,     sampleCounter, acqTimer
		
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
		yMax	
		moveSwitch
	end
	
	properties (Constant)
		xMax = 10;
	end
	
	
	methods
		function obj = liveRecord(saverData, daqData, guiHandles)
			obj.saverData = saverData;
			obj.trial = 1;
			obj.daqData = daqData;
			obj.srate = daqData.srate;
			obj.chCount = size(daqData.chList,2);
			
			obj.guiHandles = guiHandles;
			
			obj.axesData = repmat([1 1 0],8,1); %matrix containing xScale, yScale, source for each axis
            obj.yMax = .1;
		end
		
		function resetUI(obj)
			ai = analoginput('dtol',0);       %create daq object
			ai.BufferingMode = 'Auto';        %let daq control buffering
			ai.SampleRate = obj.srate;        %set daq samplerate
			ai.SamplesPerTrigger = inf;       %we will be continuously plotting data
			ai.TimerPeriod = .1;              %frequency plot gets updated
			ai.TimerFcn = {@obj.timerCbFunc}; %function that gets called when timer goes off
			obj.daqData.chList
			addchannel(ai, obj.daqData.chList);           %collect data from this channel
			ai.Channel.GainPerChan = obj.daqData.gain;    %ranges of voltage will vary from -2.5-2.5, maximum resolution
			
			obj.aiObj = ai;
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
				
				obj.samplesObtained = obj.samplesObtained + c;
				handles.sampleCounter.String = sprintf('%d Samples',obj.samplesObtained);
				
				handles = obj.guiHandles;
				handles.acqTimer = sprintf('%d Seconds since Start',time(end)); %relative time of last sample in seconds
				rate = obj.srate;
				
				ad = obj.axesData;
				yLim = obj.yMax;
				
				obj.growingRawData = [obj.growingRawData; data];
				obj.totalRawData = [obj.totalRawData; data];
				for a = 1:obj.chCount
					obj.movingData(:,a) = obj.growingRawData(:,a) - mean(obj.growingRawData(:,a));
				end
				obj.growingTimes = [obj.growingTimes; time];
				lastTime = obj.growingTimes(end);
				obj.growth = obj.growth + 1;
				
				
				%PLOT DATA
				for i = 1:8
					if ad(i,3) ~= 0
						ax = handles.plots{i};
						xScale = ad(i,1);
						yrange = [-ad(i,2)*yLim ad(i,2)*yLim];
						source = ad(i,3);
						xOffset = 10*xScale*rate;
	
						
						switch obj.moveSwitch
							case 0
								if obj.samplesObtained <= xOffset
									xDat = obj.growingTimes(:);
									yDat = obj.movingData(:,source);
									plot(ax,xDat,yDat);
									xlim(ax, [0 xScale*10])
								else
									xDat = obj.growingTimes(end-xOffset:end);
									yDat = obj.movingData(end-xOffset:end,source);
									plot(ax,xDat,yDat);
									xlim(ax, [lastTime-xScale*8 lastTime+xScale*2])
								end
							case 1
								xDat = obj.growingTimes(end-.8*xOffset:end);
								yDat = obj.movingData(end-.8*xOffset:end,source);
								plot(ax,xDat,yDat);
								xlim(ax, [lastTime-xScale*8 lastTime+xScale*2])
						end
						ylim(ax, yrange)
					end
				end
				
				
				%MANAGE DATA
				if obj.growth == 80
					obj.moveSwitch = 1;
				end
				if obj.growth == 110
					obj.growth = 0;
					offset = 10*rate;
					obj.growingRawData = obj.growingRawData(end-offset:end,:);
					obj.totalTimes = [obj.totalTimes; obj.growingTimes];
					obj.growingTimes = obj.growingTimes(end-offset:end)
				end
			end
			obj.movingData=[];
		end
		
		function chAxes(obj, axID, colID, newVal)
			obj.axesData(axID,colID) = newVal; % colID 1-> xScale
													% 2-> yScale
											  	 % 3-> source's chList index
		end
		
		function start(obj)
			start(obj.aiObj); %trigger daq and begin timer
		end
		
		function stop(obj)
			stop(obj.aiObj)
			sd = obj.saverData;
			cd(sd.dirPath);
			dat = {sd.notes obj.totalRawData};
			fname = sd.filename;
			fname = [sd.filename sprintf('%d',obj.trial) '.mat'];
			save(fname, 'dat')
			delete(obj.aiObj);
			clear obj.aiObj;
			obj.trial = obj.trial+1;
		end
		
	end
	
	
end

