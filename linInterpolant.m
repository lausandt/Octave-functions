## the point is that matlab handles this linear instead of multilinear!
## the wy matlab counts means that the next neighbour always moves up in the y line, unless y mod 50 == 0 then it is in the x line 

function p = linInterpolant(X,Y,values, Xq, Yq)
  # create a matrix of column vectors X and Y
  MXY = zeros(size(X),2);
  # filling the matrix with the values of X and Y
  MXY(:,1) = X;
  MXY(:,2) = Y;
  p = zeros(size(Xq));
  for i=1:length(Xq)
    x = Xq(i);
    y = Yq(i);
    if y==1;
      y = 50;
      x = x - 1;
      l = 1;
      lowtarget  =  [];
      while isempty(lowtarget)
        lowtarget  =  find(MXY(:,1)==x & MXY(:,2)==y-l);
        l = l + 1;
      endwhile
      x = x -1;
      y = 1;
      h = 1;
      hightarget = [];
      while isempty(hightarget)
        hightarget = find(MXY(:,1)==x & MXY(:,2)==y+h);
        h = h +1;
      endwhile
    elseif y == 50
       l = 1;
      lowtarget  =  [];
      while isempty(lowtarget)
        lowtarget  =  find(MXY(:,1)==x & MXY(:,2)==y-l);
        l = l + 1;
      endwhile
      x = x +1;
      y = 1;
      h = 1;
      hightarget = [];
      while isempty(hightarget)
        hightarget = find(MXY(:,1)==x & MXY(:,2)==y+h);
        h = h +1;
      endwhile  
    else  
      l = 1;
      lowtarget  =  [];
      while isempty(lowtarget)
        if y-l <1
          y = 51;
          x = x-1;
          lowtarget  =  find(MXY(:,1)==x & MXY(:,2)==y-l);
        else 
          lowtarget  =  find(MXY(:,1)==x & MXY(:,2)==y-l);
        endif  
        l = l + 1;
      endwhile
      x = Xq(i);
      y = Yq(i);
      h = 1;
      hightarget = [];
      while isempty(hightarget)
        if y+h>50
          y = 1;
          x = x+1;
          hightarget = find(MXY(:,1)==x & MXY(:,2)==y+h);
        else  
          hightarget = find(MXY(:,1)==x & MXY(:,2)==y+h);
        endif  
        h = h +1;
      endwhile
    endif  
    p(i) = (values(hightarget)+values(lowtarget))/2;
  endfor  
endfunction




