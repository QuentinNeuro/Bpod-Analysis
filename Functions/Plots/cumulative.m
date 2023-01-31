function [x,y]=cumulative(data)
    data=data(~isnan(data));
    datasize=length(data);
    step=1/datasize;
    x=sort(data);   
    y=nan(datasize,1);
    y(1)=step;
    for i=2:datasize
        y(i)=y(i-1)+step;
    end
end