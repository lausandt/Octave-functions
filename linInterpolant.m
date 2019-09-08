## -*- texinfo -*-
## @deftypefn  {} {@var{zi} =} griddata (@var{x}, @var{y}, @var{z}, @var{xi}, @var{yi})
## 
## Background information
## This function applies a linearinterpolant along the lines that Matlab creates a linear interpolant in the function scatteredInterpolant
## Matlab performs this task in two steps (speeding up the process) 
## Step 1 create a partial parameterised function F 
## Step 2 apply F to the query points
## This requires an higher order function that returns a partially applied function
## This type of functional programming is not implemented in Octave
## Therefor this function does it all in one step
## Why not use Octave griddata instead? Griddata creates a regular mesh, this creates a vector of interpolated values. In tests this seems to be factor 10 faster then griddata
## 
## Input 
##        X vector of known data
##        Y vector of known data
##        vector of values at x,y 
##        Xq vector of query points 
##        Yq vector of query points 
##
## Output 
##        Vq a vector of interpolated values
## 




function Vq = linInterpolant(X,Y,values, Xq, Yq)
  # create a matrix of column vectors X and Y
  MXY = zeros(size(X),2);
  # filling the matrix with the values of X and Y
  MXY(:,1) = X;
  MXY(:,2) = Y;
  # create the result matrix 
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
    # set result
    Vq(i) = (values(hightarget)+values(lowtarget))/2;
  endfor  
endfunction




