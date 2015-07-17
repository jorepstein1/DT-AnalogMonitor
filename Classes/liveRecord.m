classdef liveRecord < handle
	
	
	properties
		
		saverData  %dirPath,   filename,      notes
		daqData    %srate,     chList,        gain
		guiHandles %plots,     sampleCounter, acqTimer

		chCount %int number of active channels
		srate
		aiObj
		
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
	end
	
	properties (Constant)
		xMax = 10;
		yMax = 5;
	end
	
	
	methods
		function obj = liveRecord(saverData, daqData, guiHandles)
			obj.saverData = saverData;
			
			obj.daqData = daqData;
			obj.srate = daqData.srate;
			obj.chCount = size(daqData.chList);
			
			obj.guiHandles = guiHandles;
			
			obj.axesData = repmat([1 1 0],8,1) %matrix containing xScale, yScale, source for each axis	
		end
		
		function resetUI(obj)
			ai = analoginput('winsound',0);       %create daq object
			ai.BufferingMode = 'Auto';        %let daq control buffering
			ai.SampleRate = obj.srate;        %set daq samplerate
			ai.SamplesPerTrigger = inf;       %we will be continuously plotting data
			ai.TimerPeriod = .1;              %frequency plot gets updated
			ai.TimerFcn = {@obj.timerCbFunc}; %function that gets called when timer goes off
			
			addchannel(ai, obj.daqData.chList);           %collect data from this channel
			%ai.Channel.GainPerChan = obj.daqData.gain;    %ranges of voltage will vary from -2.5-2.5, maximum resolution
			
			obj.aiObj = ai;
			obj.growth = 0;
			obj.totalTimes = [];
			obj.totalRawData = [];
			obj.growingRawData = [];
			obj.growingTimes = [];
			obj.growingMovingData = [];
			obj.samplesObtained = 0;
			obj.moveSwitch = 0;
		end
		
		function timerCbFunc(obj, ai, event)
			c=min(floor(ai.SampleRate*ai.TimerPeriod),ai.SamplesAvailable);
			
			%COLLECT DATA
			if c~=0
				[data, time] = getdata(ai, c);
				
				obj.samplesObtained = obj.samplesObtained + c;
				obj.sampleCounter.String = sprintf('%d Samples',obj.samplesObtained);
				
				timerTime = time(end); %relative time of last sample in seconds
				
				obj.growingRawData = [obj.growingRawData; data];
				obj.totalRawData = [obj.totalRawData; data];
				for a = 1:obj.chCount
					obj.movingData(:,a) = obj.growingRawData(:,a) - mean(obj.growingRawData(:,a));
				end
				obj.growingTimes = [obj.growingTimes; time];
				obj.growth = obj.growth + 1;
				
				
				%PLOT DATA
				for i = 1:8
					ax = obj.axesHandles{i};
					source = obj.axesDataSources{i};
					xScale = obj.axesXScales{i};
					xOffset = 10*xScale*obj.srate;
					
					
					if ~isempty(source)
						switch obj.moveSwitch
							case 0
								if obj.samplesObtained <= xOffset
									xDat = obj.growingTimes(:);
									yDat = obj.movingData(:,source);
									plot(ax,xDat,yDat);
									xlim(ax, [0 xScale*10])
									ylim(ax, obj.axesYLims{i})
								else
									lastTime = obj.growingTimes(end);
									xDat = obj.growingTimes(end-xOffset:end);
									yDat = obj.movingData(end-xOffset:end,source);
									plot(ax,xDat,yDat);
									xlim(ax, [lastTime-xScale*8 lastTime+xScale*2])
								end
							case 1
								lastTime = obj.growingTimes(end);
								xDat = obj.growingTimes(end-.8*xOffset:end);
								yDat = obj.movingData(end-.8*xOffset:end,source);
								plot(ax,xDat,yDat);
								xlim(ax, [lastTime-xScale*8 lastTime+xScale*2])
						end
					end
				end
				
				
				%MANAGE DATA
				if obj.growth == 80
					obj.moveSwitch = 1;
				end
				if obj.growth == 110
					obj.growth = 0;
					obj.growingRawData = obj.rawData(end-10*obj.srate:end,:);
					obj.totalTimes = [obj.totalTimes; obj.growingTimes];
					obj.growingTimes = obj.growingTimes(end-10*obj.srate:end)
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
			dt = datetime('now','TimeZone','local','Format','HHmmss');
			cd(obj.saveDir);
			wha = obj.totalRawData;
			fname = [obj.basename '.mat']
			save(fname, 'wha')
			delete(obj.aiObj);
			clear obj.aiObj;
		end
		
	end
	
	
end

