function [ newfile ] = background9000_R( oldfile )
newfile=oldfile;
maskR = newfile ~= 0;

measurements = regionprops(maskR,'PixelList');

[pixels] = measurements.PixelList;

[x,y,~] = size(maskR);

%farthest hemisphere pixel in each direction
left = min(pixels(:,1,:));
right = max(pixels(:,1,:));
bottom = max(pixels(:,2,:));
top = min(pixels(:,2,:));

%distances of farthest pixels from edges of images
topdiff = top;
bottomdiff = x - bottom;
rightdiff = y - right;
leftdiff = left;

%if both dimension are below 9000, add border centering hemisphere on 9000x
%9000 black background
if x < 9000 && y < 9000
    vertdiff = 9000 - x;
    horizdiff = 9000 - y;
    
    horizratio = (-rightdiff + leftdiff + y - 9000)/(2*(y - 9000));
    vertratio = (-bottomdiff + topdiff + x - 9000)/(2*(x - 9000));
    
    bottom_add = vertdiff*(1 - vertratio);
    top_add = vertdiff*vertratio;
    left_add = horizdiff*horizratio;
    right_add = horizdiff*(1 - horizratio);
    
    vertpad = max(top_add,bottom_add);
    horizpad = max(right_add,left_add);
    
    newfile = padarray(newfile,[floor(vertpad),floor(horizpad)]);
    [xx,yy,~] = size(newfile);
    
    if bottom_add > top_add
        if left_add > right_add %trim top and right
            newfile = newfile(xx-9000+1:xx,1:9000,:);
        else %trim top and left
            newfile = newfile(xx-9000+1:xx,yy-9000:yy,:);
        end
    else
        if left_add > right_add %trim bottom and right
            newfile = newfile(1:9000,1:9000,:);
        else %trim bottom and left
            newfile = newfile(1:9000,yy-9000+1:yy,:);
        end
    end
else
    display('Warning: Dimensions exceed 9000 x 9000');
    %if they do just display this & save as is
end


end

