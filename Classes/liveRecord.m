classdef liveRecord < handle
	
	
	properties
		srate
		
		growingRawData
		growingMovingData
		totalRawData
		growingTimes
		totalTimes
		sampleCounter
		samplesObtained
		
		axesHandles
		axesDataSources
		axesXScales
		axesYLims
		
		moveSwitch
		
		aiObj
		growth
		
		saveDir
		basename
	end
	properties (Constant)
		xMax = 10;
		yMax = 5;
	end
	methods
		function obj = liveRecord(dir,basename,chList,srate,daqGain)
			obj.basename = basename;
			obj.saveDir = dir;
			
			
			ai = analoginput('dtol',0);   %create daq object
			ai.BufferingMode = 'Auto';        %let daq control buffering
			ai.SampleRate = srate;            %set daq samplerate
			obj.srate = srate;
			ai.SamplesPerTrigger = inf;       %we will be continuously plotting data
			ai.TimerPeriod = .1;              %frequency plot gets updated
			ai.TimerFcn = {@obj.timerCbFunc}; %function that gets called when timer goes off
			
			addchannel(ai, chList); %collect data from this channel
			ai.Channel.GainPerChan = daqGain; %ranges of voltage will vary from -2.5-2.5, maximum resolution
			
			
			obj.aiObj = ai;
			obj.growth = 0;
			obj.totalTimes = [];
			obj.totalRawData = [];
			obj.growingRawData = [];
			obj.growingTimes = [];
			obj.growingMovingData = [];
			obj.samplesObtained = 0;
			obj.moveSwitch = 0;
			for a= 1:8
				obj.axesXScales{a} = 1;
				obj.axesYLims{a} = [-obj.yMax obj.yMax];
			end
		end
		
		
		function timerCbFunc(obj, ai, event)
			c=min(floor(ai.SampleRate*ai.TimerPeriod),ai.SamplesAvailable);
			
			%COLLECT DATA
			if c~=0
				[data, time] = getdata(ai, c);
				obj.samplesObtained = obj.samplesObtained + c;
				obj.sampleCounter.String = sprintf('%d Samples',obj.samplesObtained);
				obj.growingRawData = [obj.growingRawData; data];
				obj.totalRawData = [obj.totalRawData; data];
				for a = 1:size(data,2)
					obj.growingMovingData(:,a) = obj.growingRawData(:,a) - mean(obj.growingRawData(:,a));
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
									yDat = obj.growingMovingData(:,source);
									plot(ax,xDat,yDat);
									xlim(ax, [0 xScale*10])
									ylim(ax, obj.axesYLims{i})
								else
									lastTime = obj.growingTimes(end);
									xDat = obj.growingTimes(end-xOffset:end);
									yDat = obj.growingMovingData(end-xOffset:end,source);
									plot(ax,xDat,yDat);
									xlim(ax, [lastTime-xScale*8 lastTime+xScale*2])
								end
							case 1
								lastTime = obj.growingTimes(end);
								xDat = obj.growingTimes(end-.8*xOffset:end);
								yDat = obj.growingMovingData(end-.8*xOffset:end,source);
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
					obj.growingRawData = obj.growingRawData(end-10*obj.srate:end,:);
					obj.totalTimes = [obj.totalTimes; obj.growingTimes];
					obj.growingTimes = obj.growingTimes(end-10*obj.srate:end)
				end
			end
			obj.growingMovingData=[];
		end
		
		function scaleLims(obj,dim,axID,scale)
			switch dim
				case 'x'
					obj.axesXScales{axID} = scale;
				case 'y'
					newY = scale * obj.yMax;
					obj.axesYLims{axID} = [-newY newY];
			end
		end
		
		function setAxes(obj,handles)
			a = cell(1,8);
			d = cell(1,8);
			for b = 1:8
				a{b} = handles{b};
				d{b} = [];
			end
			obj.axesHandles = a;
			obj.axesDataSources = d;
		end
		
		function setDataSource(obj, plotID, chID)
			obj.axesDataSources{plotID} = chID;
		end
		
		function setSampleCounter(obj, handle)
			obj.sampleCounter = handle;
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

