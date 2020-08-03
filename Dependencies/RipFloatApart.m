%usage:
%       [Mantissa,Power] = RipFloatApart(realno)
%take a non-negative real number R = Mantissa * 10^(Power) 
% and returns the Mantiss and Power

function [Mantissa,Power] = RipFloatApart(realno)
    
    if (abs(realno) < eps^2)
        Mantissa = 0;
        Power = 0;
        return;
    end
    
    Power = floor(log10(realno));
    
    Mantissa = realno * 10^(-Power);

end