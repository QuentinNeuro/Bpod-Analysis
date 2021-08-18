TTL_Outcome=zeros(size(D,2),2);
for thisT=1:size(D,2)
    indices=find(D(thisT).y);
    TTL_Outcome(thisT,:)=[D(thisT).x(indices(1)) D(thisT).x(indices(end))]/1000;
end