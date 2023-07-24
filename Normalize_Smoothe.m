function [SignalnormS]=Normalize_Smoothe(Signal,Normalization_Value,Background_Value)
Signalnorm=(Signal-Background_Value)/(Normalization_Value-Background_Value);
SignalnormS=smoothdata(Signalnorm);
end