## zi = = linInterpolant(x,y,z,xi,yi)
## Generate a vector of interpolated values 
##
## Inputs 
## x <- vector of x values. 
## y <- vector of y values.
## z <- vector of values at point(x,y)
## x, y & z are vectors of the same length.
## xi <-  vectors of query points along the x axis.
## yi <-  vectors of query points along the y axis.
## xi & yi are vectors of the same length.
##
## Output 
## zi -> vector of interpolated values.
##
## Background information
## This function is build as alternative to Matlab's scatterInterpolant function for use with https://www.udemy.com/master-matlab-through-guided-problem-solving.
## Comparable functions in Octave return a mesh, Matlab's function generates an "interpolant" and applies that to query points which results defacto into a vector and not a mesh
## Similar behaviour is, as far as I am aware off, not possible in Octace, as this would require a higher order function that creates a partially parameterised function in return
## 
## Author L M Sandt
## https://github.com/lausandt/Octave-functions       

function zi = linInterpolant(x,y,z,xi,yi)
 
  # checking if x,y & z are vectors and of equal length
  if (isvector (x) && isvector (y) && isvector (z))
    if (! isequal (length (x), length (y), length (z)))
      error ("linearInterpolant: X, Y, and Z must be vectors of the same length.");
    endif
  else
    error ("linearInterpolant: X, Y, and Z must be vectors.");
  endif
  # checking if xi & yi are vectors and of equal length
  if (isvector (xi) && isvector (yi))
    if (! isequal (length (xi), length (yi)))
      error ("linearInterpolant: XI, YI must be vectors of the same length.");
    endif
  else
    error ("linearInterpolant: XI, YI must be vectors.");
  endif
    
    
  #triangulate the data 
  tri = delaunay (x, y);
  
  # creating the return argument
  zi = zeros(size (xi));
  
  # Search for every point the enclosing triangle.
  # For tri <- delaunay(x, y)), where (x, y) is a 2D set of points, 
  # tsearch(x, y, tri, xq, yq) finds the index in tri containing the points (xq, yq). 
  tri_list = tsearch (x, y, tri, xi, yi);
  

  # Catch points outside the convex hull which tsearch sets to NaN and replace them with the nearest value (slim chance but..)
  valid = ! isnan (tri_list);
  if sum(valid) != length(xi)
      cv = find(isnan(tri_list));
      if any(cv==length(tri_list))
        tri_list(length(tri_list)) = tri_list(length(tri_list)-1);
      elseif any(cv==1)
        tri_list(1) = tri_list(2)
      else  
        tri_list(cv) = tri_list(cv+1);
      endif
  endif    
    
  
  # only keep the triangulated data for the points in xi and yi
  tri = tri(tri_list,:);
  
  # the zscores of the three points that make up the triangle where the missing point is to be found
  z1 = z(tri(:,1));
  z2 = z(tri(:,2));
  z3 = z(tri(:,3));
  
  # take the linear interpolant of the three lines that make up the triangle 
  zi = ((z1+z2)/2+(z1+z3)/2 + (z2+z3)/2)/3;
  
  
endfunction
