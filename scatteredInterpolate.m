

# This function is a variation on the scatteredInterpolate function in Matlab
# Its use is for Octave followers of www.udemy.com/master-matlab-through-guided-problem-solving/learn/lecture/10247376 
# and only guaranteed to work for the accompanying code of Mike X Cohen, but it should work for all similar defined problems
#
# Multivariate interpolation a.k.a. spacial interpolation is interpolation on functions of more then one variable
# The function to be interpolated is known at given points f(x_{i},y_{i},z_{i}) and 
# The interpolation problem consist of yielding values at arbitrary points f(x,y,z)
# There are multiple manners to solve this problem, this function uses only one, a version of nearest neighbour 
#
# inputs:
#        M = the matrix with corrupted data
#        LM = the logical matrix/vector where the corrupted data is true
#
# Algorithm: 
#            This nearest neighbor interpolation works on taking the median of an 8 number vector
#            the vector consists of the eight closest neighbours of the MatriM indeM (i,j) that needs to be interpolated
#            the algorithm divides the matrix in 9 distinct areas in order to pick the closest neighbour
#            1 - upper left corner
#            2 - upper right corner
#            3 - lower left corner
#            4 - lower right corner
#            5 - the upper border
#            6 - the left side border
#            7 - the lower border
#            8 - the right side border
#            9 - the middle
#
# output:
#        the Interploated Matrix M
#
#
# Author Lau Sandt 
# https://github.com/lausandt/Octave-functions

function M = scatteredInterpolate(M, LM)
  
  for qi=1:length(LM)
      if LM(qi)==1
        [i,j] = ind2sub(size(M), qi);
        # upper left corner
        if (i == 1 & j == 1) 
          M(i,j) = median([M(i,j+1), M(i,j+2), M(i+1,j), M(i+1,j+1), M(i+1,j+2), M(i+2,j), M(i+2,j+1), M(i+2,j+2) ]);
        # upper right corner  
        elseif (i == 1 & j == size(M, 2)) 
          M(i,j) = median([M(i,j-1), M(i,j-2), M(i+1,j), M(i+1,j-1), M(i+1,j-2), M(i+2,j), M(i+2,j-1), M(i+1,j-2) ]);
        # lower left corner  
        elseif (i == size(M,1) & j == 1) 
          M(i,j) = median([M(i,j+1), M(i,j+2), M(i-1,j), M(i-1,j+1), M(i-1,j+2), M(i-2,j), M(i-2,j+1), M(i-2,j+2) ]);
        # lower right corne  
        elseif (i == size(M,1) & j == size(M, 2)) r
          M(i,j) = median([M(i,j-1), M(i,j-2), M(i-1,j), M(i-1,j-1), M(i-1,j-2), M(i-2,j), M(i-2,j-1), M(i-1,j-2) ]);
        # the upper border  
        elseif (i== 1) 
          M(i,j) = median([M(i,j-1), M(i,j+1), M(i+1,j), M(i+1,j-1), M(i+1,j+1), M(i+2,j), M(i+2,j-1), M(i+2,j+1) ]);
        # left side border
        elseif (j== 1) 
          M(i,j) = median([M(i,j+1), M(i,j+2), M(i-1,j), M(i-1,j+1), M(i-1,j+2), M(i+1,j), M(i+1,j+1), M(i+1,j+2) ]);
        # lower border  
        elseif (i == size(M,1)) 
          M(i,j) = median([M(i,j-1), M(i,j+1), M(i-1,j), M(i-1,j-1), M(i-1,j+1), M(i-2,j), M(i-2,j-1), M(i-2,j+1) ]);
        # right side border  
        elseif (j == size(M, 2)) 
          M(i,j) =  median([M(i,j-1), M(i,j-2), M(i-1,j), M(i-1,j-1), M(i-1,j-2), M(i+1,j), M(i+1,j-1), M(i+1,j-2) ]);
        # the middle  
        else 
          M(i,j) = median([M(i,j-1), M(i,j+1), M(i-1,j-1), M(i-1,j), M(i-1,j+1), M(i+1,j-1), M(i+1,j), M(i+1,j+1) ]);
        endif  
      endif
    endfor
  
endfunction


%%
