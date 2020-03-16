clear

activitiesFile='C:\Users\Admin\Documents\MATLAB\StravaAnalysis\activities.csv';

opts = detectImportOptions(activitiesFile);
opts.LineEnding='\r\n';
M=readtable(activitiesFile, opts);

dateTimeFormat='dd MMM yyyy, HH:mm:ss';

allActivityTypes=unique(M.ActivityType);
isCycling=strcmp(M.ActivityType,'Ride') | strcmp(M.ActivityType,'VirtualRide');
isByFoot=strcmp(M.ActivityType,'Hike') | strcmp(M.ActivityType,'Walk') | strcmp(M.ActivityType,'Run');

rideDistance=M.Distance(isCycling); % assume this is in metres
rideDates=datetime(M.ActivityDate(isCycling), 'InputFormat', dateTimeFormat);
rideWeek=week(rideDates);
[rideYear, ~, ~]=ymd(rideDates);

footDistance=M.Distance(isByFoot); % assume this is in metres
footDates=datetime(M.ActivityDate(isByFoot), 'InputFormat', dateTimeFormat);
footWeek=week(footDates);
[footYear, ~, ~]=ymd(footDates);

%% Cycling
yearSel=unique(rideYear);
accumulateDistInWeeks=zeros(numel(unique(rideYear)),53);
for i=1:numel(rideDistance)
    accumulateDistInWeeks(rideYear(i)==yearSel,rideWeek(i))=...
        accumulateDistInWeeks(rideYear(i)==yearSel,rideWeek(i))+rideDistance(i); 
end

cumsumDist_km=cumsum(accumulateDistInWeeks,2)/1000;

figure(1);clf
subplot(1,2,1)
    plot(1:53,cumsumDist_km)
    legend(num2str(yearSel),'location','northwest')
    xlabel('Week #')
    ylabel('Cumulative cycling distance, km')
    grid on
    
%% By foot
yearSel=unique(footYear);
accumulateDistInWeeks=zeros(numel(unique(footYear)),53);
for i=1:numel(footDistance)
    accumulateDistInWeeks(footYear(i)==yearSel,footWeek(i))=...
        accumulateDistInWeeks(footYear(i)==yearSel,footWeek(i))+footDistance(i); 
end
cumsumDist_km=cumsum(accumulateDistInWeeks,2)/1000;

subplot(1,2,2)
    plot(1:53,cumsumDist_km)
    legend(num2str(yearSel),'location','northwest')
    xlabel('Week #')
    ylabel('Cumulative distance by foot, km')
    grid on
