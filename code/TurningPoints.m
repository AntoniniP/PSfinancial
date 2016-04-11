%% Actual TP function
function tp = TurningPoints(time, value, n)

x = TP_prepareData(time, value);
tp = TP_preprocess(x);

while n > 0
    
    n = n-1;
    y = tp;
    clear tp;
    
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
        end  % end if
        
    end  % end while i < (length(y)-3)
    
    tp(length(y),:) = y(length(y),:);
    tp = TP_cleaning(tp);
    TP_output(y,tp)
    
end  % end while n > 0

plot( datetime ( x(:,1), 'ConvertFrom', 'datenum'), x(:,2), ...
    datetime ( tp(:,1), 'ConvertFrom', 'datenum'), tp(:,2));

end  % end TurningPoints()


%% Data preprocessing
function y = TP_preprocess(x)

% Boundary elements
y(1,:) = x(1,:);
y(length(x),:) = x(length(x),:);

% Core
for i=2:(length(x)-1)
    
    prec = x(i-1,2);
    curr = x(i,2);
    succ = x(i+1,2);
    
    condMIN = curr < prec && curr < succ;  % curr: local minimum
    condMAX = curr > prec && curr > succ;  % curr: local maximum
    if condMIN || condMAX
        y(i,:) = x(i,:);
    end  % end if
    
end  % end for

y = TP_cleaning(y);
TP_output(x,y)

end  % end TP_preprocess()


%% Prepares data for processing
function y = TP_prepareData(time, value)

temp = datenum(time, 'yyyy-mm-dd');  % converts dates to tractable format
y = [flipud(temp) flipud(value)];  % flips order (older data first)

end  % end TP_prepareData()


%% Data cleaning
function y = TP_cleaning(x)

y = x;
Z = y(:,2)==0;  % identifies rows containing 0's
y(Z,:) = [];  % deletes rows accordig to Z

end  % end TP_cleaning()


%% Prints out some information about the operations
function TP_output(a,b)

totItems = length(a(:,1));
delItems = totItems - length (b(:,1));
fprintf ('Deleted %d elements out of %d.\n', delItems, totItems)

end  % end TP_output()