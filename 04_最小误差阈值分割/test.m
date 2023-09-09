defineAndVariableNumInputs('a',1,zeros(3,3),'mmm',555,876)

function defineAndVariableNumInputs(x,y,varargin)

    clc;
   disp("Total numbel of input arguments: " + nargin)
   
   formatSpec = "Size of varargin cell array: %d*%d";
   str = compose(formatSpec,size(varargin));
   %compose为复合函数
   disp(str)

   disp("The fist varargin argument obtained from the () index")
   
   disp(varargin(size(varargin,1)))
   
   disp("The fist varargin argument obtained from the {} index")
   
   disp(varargin{size(varargin,1)})
   
   disp("The last varargin argument obtained from the () index")
   
   disp(varargin(size(varargin,2)))
   
   disp("The last varargin argument obtained from the {} index")
   
   disp(varargin{size(varargin,2)})
   
   disp(varargin{2})
end