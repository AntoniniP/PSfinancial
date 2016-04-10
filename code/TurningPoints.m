%% Actual TP function
function tp = TurningPoints(x)

y = PreprocessTP(x); %TODO Only the first time!

%% Boundary elements hanlding
tp(1,:) = y(1,:);  % first element of the time series
tp(length(y),:) = y(length(y),:);  % last element of the time series

%% Core
i = 1;
while i < (length(y)-3)
    
    p0 = y(i+0,2);
    p1 = y(i+1,2);
    p2 = y(i+2,2);
    p3 = y(i+3,2);
   
    condUT = p0 < p1 && p0 < p2 && p1 < p3 && p2 < p3 ...  % uptrend
             && abs(p1 - p2) < abs(p0 - p2) + abs(p1 - p3);
         
    condDT = p0 > p1 && p0 > p2 && p1 > p3 && p2 > p3 ...  % downtrend
             && abs(p2 - p1) < abs(p0 - p2) + abs(p1 - p3);  

    eps = 0.05 * mean([p0 p1 p2 p3]);
    condST = abs(p0 - p2) < eps && abs(p1 - p3) < eps;  % same trend
            
    if condUT || condDT || condST
        tp(i,:) = y(i,:); 
        tp(i+3,:) = y(i+3,:);
        i=i+3;
    else
        tp(i,:) = y(i,:);
        i=i+1;
    end
    
end

%% Cleaning of the result
Z = tp(:,2)==0;  
tp(Z,:) = [];  % deletes rows according to Z

%% Final operations and presentation
totItems = length(y(:,1));
delItems = totItems - length (tp(:,1));
fprintf ('Deleted %d elements out of %d.\n', delItems, totItems)

plot( datetime ( tp(:,1), 'ConvertFrom', 'datenum'), tp(:,2), ...
      datetime ( y(:,1), 'ConvertFrom', 'datenum'), y(:,2), ...
      datetime ( x(:,1), 'ConvertFrom', 'datenum'), x(:,2) );

end







%% Data preprocessing for TurningPoints(x) function
function y = PreprocessTP(x)

%% Boundary elements hanlding
y(1,:) = x(1,:);  % first element of the time series
y(length(x),:) = x(length(x),:);  % last element of the time series

%% Core
for i=2:(length(x)-1)
    
    prec = x(i-1,2);
    curr = x(i,2);
    succ = x(i+1,2);
   
    condMIN = curr < prec && curr < succ;  % curr: local minimum
    condMAX = curr > prec && curr > succ;  % curr: local maximum
    if condMIN || condMAX
        y(i,:) = x(i,:);  
    end
    
end

%% Cleaning of the result
Z = y(:,2)==0;  
y(Z,:) = [];  % deletes rows according to Z

%% Final operations and presentation
totItems = length(x(:,1));
delItems = totItems - length (y(:,1));
fprintf ('PREPROC: deleted %d elements out of %d.\n', delItems, totItems)

%plot( datetime ( y(:,1), 'ConvertFrom', 'datenum'), y(:,2), ...
%      datetime ( x(:,1), 'ConvertFrom', 'datenum'), x(:,2));

end