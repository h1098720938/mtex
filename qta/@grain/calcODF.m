function grains = calcODF(grains,ebsd,varargin)
% bypass-function to calculate individual ODFs for each grain or an ODF based on the orientation of each grain
%
%% Input
%  grains - @grain
%  ebsd   - @EBSD, specifiy to perform an ODF estimation based on original data
%
%% Output
%  grains  - @grain with odf as property
%  or odf  - @ODF if based on orientation of grains
%
%% See also
% ebsd/calcODF

if nargin>1 && isa(ebsd,'EBSD')
  for l=1:numel(ebsd)
    ebsd_cur = ebsd(l); 
    ind = get(grains,'phase') == get(ebsd_cur,'phase');
        
    %do the same kernel for every grain of same phase    
    [k hw options] = extract_kernel(getgrid(ebsd_cur),varargin);

    %predefine a grid
    if ~check_option(varargin,'exact'), 
      [S3G options]= extract_SO3grid(ebsd_cur,options);
    end
    
    [o grains(ind)] = grainfun(@calcODF, grains(ind), ebsd_cur,...
      'property',get_option(varargin,'property','ODF'),options{:},'silent');
  end
else
  if nargin>1, varargin = [{ebsd} varargin]; end
  grains = calcODF(toebsd(grains),varargin{:});
end

