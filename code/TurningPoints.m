function y = TurningPoints( x )

%% Boundary elements hanlding
y(1,:) = x(1,:);  % first element of the time series
y(length(x),:) = x(length(x),:);  % last element of the time series

%% Core
for i=2:(length(x)-1)
    
    prec = x(i-1,2);
    curr = x(i,2);
    succ = x(i+1,2);
   
    condMIN = curr <= prec && curr <= succ;  % curr: local minimum
    condMAX = curr >= prec && curr >= succ;  % curr: local maximum
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
fprintf ('Deleted %d elements out of %d.\n', delItems, totItems)

plot( datetime ( y(:,1), 'ConvertFrom', 'datenum'), y(:,2), ...
      datetime ( x(:,1), 'ConvertFrom', 'datenum'), x(:,2));

end