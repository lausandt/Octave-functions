

% run the code from the previous project to generate multivariate space-time data

% create dataset
% first, corrupt several channels
prop2corrupt = .1; % fraction of channels to remove

% pick the sensors to replace with noise
badsensors = randperm(N^2);
badsensors = badsensors(1:ceil(prop2corrupt*N^2));

% loop through time and replace those pixels
multidataC = multidata;
for ti=1:npnts
    % get the data from this time point
    tmp = squeeze(multidata(ti,:,:));
    
    % replace the bad sensors with large-amplitude noise
    tmp(badsensors) = 100*randn(size(badsensors), 1);
    
    % then put that matrix back into the corrupted data
    multidataC(ti,:,:) = tmp;
end


figure(1), clf
colormap jet

% setup the figure for a video
subplot(131)
oh = imagesc(squeeze( mean(multidata,1) ));
set(gca,'clim',[-1 1]*2), axis square
title('Original data');

subplot(132)
ch = imagesc(squeeze( mean(multidata,1) ));
set(gca,'clim',[-1 1]*2), axis square
title('Corrupted data');

% loop through time and update the display
for ti=1:npnts
    set(oh, 'cdata', squeeze(multidata(ti,:,:)))
    set(ch, 'cdata', squeeze(multidataC(ti,:,:)))
    
    pause(.05)
end


% how to identify the bad sensors? 
% let's start by assuming that bad sensors have very large variance.
% Thus, in a separate figure, show a plot of the standard deviation over time at each sensor.
figure(2), clf
imagesc(squeeze(std(multidataC)))
colorbar 


% now let's see a histogram of the standard deviations
tmp  = reshape( squeeze(std(multidataC,[],1)) ,1,[]);
tmpz = (tmp-mean(tmp))/std(tmp);
hist(tmp,30)


% pick a threshold and identify the sensors to interpolate
sensors2interp = tmpz > 2;
# setting multidataC to the to be reconstructed data
multidataR = zeros(npnts,N,N);

## This nearest neighbor interpolation works on taking the median of an 8 number vector
## the vector consists of the eight closest neighbours of the Matrix index (i,j) that needs to be interpolated
## the algorithm divides the matrix in 9 distinct areas in order to pick the closest neighbour
## 1 - upper left corner
## 2 - upper right corner
## 3 - lower left corner
## 4 - lower right corner
## 5 - the upper border
## 6 - the left side border
## 7 - the lower border
## 8 - the right side border
## 9 - the middle


for ti=1:npnts
# setting the matrix to the timepoint 
    X = squeeze(multidataC(ti,:,:));
    #warning('off','all');
    # inner for loop 
    for qi=1:length(sensors2interp)
      if sensors2interp(qi)==1
        [i,j] = ind2sub(size(X), qi);
        # upper left corner
        if (i == 1 & j == 1) 
          X(i,j) = median([X(i,j+1), X(i,j+2), X(i+1,j), X(i+1,j+1), X(i+1,j+2), X(i+2,j), X(i+2,j+1), X(i+2,j+2) ]);
        # upper right corner  
        elseif (i == 1 & j == size(X, 2)) 
          X(i,j) = median([X(i,j-1), X(i,j-2), X(i+1,j), X(i+1,j-1), X(i+1,j-2), X(i+2,j), X(i+2,j-1), X(i+1,j-2) ]);
        # lower left corner  
        elseif (i == size(X,1) & j == 1) 
          X(i,j) = median([X(i,j+1), X(i,j+2), X(i-1,j), X(i-1,j+1), X(i-1,j+2), X(i-2,j), X(i-2,j+1), X(i-2,j+2) ]);
        # lower right corne  
        elseif (i == size(X,1) & j == size(X, 2)) r
          X(i,j) = median([X(i,j-1), X(i,j-2), X(i-1,j), X(i-1,j-1), X(i-1,j-2), X(i-2,j), X(i-2,j-1), X(i-1,j-2) ]);
        # the upper border  
        elseif (i== 1) 
          X(i,j) = median([X(i,j-1), X(i,j+1), X(i+1,j), X(i+1,j-1), X(i+1,j+1), X(i+2,j), X(i+2,j-1), X(i+2,j+1) ]);
        # left side border
        elseif (j== 1) 
          X(i,j) = median([X(i,j+1), X(i,j+2), X(i-1,j), X(i-1,j+1), X(i-1,j+2), X(i+1,j), X(i+1,j+1), X(i+1,j+2) ]);
        # lower border  
        elseif (i == size(X,1)) 
          X(i,j) = median([X(i,j-1), X(i,j+1), X(i-1,j), X(i-1,j-1), X(i-1,j+1), X(i-2,j), X(i-2,j-1), X(i-2,j+1) ]);
        # right side border  
        elseif (j == size(X, 2)) 
          X(i,j) =  median([X(i,j-1), X(i,j-2), X(i-1,j), X(i-1,j-1), X(i-1,j-2), X(i+1,j), X(i+1,j-1), X(i+1,j-2) ]);
        # the middle  
        else 
          X(i,j) = median([X(i,j-1), X(i,j+1), X(i-1,j-1), X(i-1,j), X(i-1,j+1), X(i+1,j-1), X(i+1,j), X(i+1,j+1) ]);
        endif  
      endif
    endfor

  multidataR(ti,:,:) = X;
end
%%

% final video of all images
figure(3) clf, 
colormap jet 
% setup the original dataset
subplot(131)
imgh1 = imagesc(squeeze( mean(multidata,1) ));
set(gca,'clim',[-1 1]*2), axis square
title('Original data');

% setup the corrupted dataset (same as above)
subplot(132)
imgh2 = imagesc(squeeze( mean(multidataC,1) ));
set(gca,'clim',[-1 1]*2), axis square
title('Corrupted data');


% setup the interpolated (reconstructed) dataset
subplot(133)
imgh3 = imagesc(squeeze( mean(multidataR,1) ));
set(gca,'clim',[-1 1]*2), axis square
title('Reconstructed data');


% loop through time points and update the displayes
for ti=1:npnts
    
    set(imgh1,'CData',squeeze(multidata(ti,:,:)))
    set(imgh2,'CData',squeeze(multidataC(ti,:,:)))
    set(imgh3,'CData',squeeze(multidataR(ti,:,:)))
    
    pause(.05)
end


%%
