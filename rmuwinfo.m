% Remove unwanted info
% main function needs to bear the same name as the script
function tab = rmuwinfo(dt,col,unwn)
    new=cell([1,height(dt)]); % create empty cell
    for i=1:height(dt)
        val=strsplit(cell2mat(dt.(col)(i)),unwn); % cell2mat get the string from the cell
        new(i)=val(2); 
    end
    dt.('new')=new';
    tab = dt;
end 

