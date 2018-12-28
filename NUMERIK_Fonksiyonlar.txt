* Syntax :
... func( arg ) ... 

*Function func Return Value 
abs "- Absolute value of argument arg 
sign "- Sign of argument arg: -1, if the value of arg is negative; 0, if the value of arg is 0; 1, if the value of arg is positive 
ceil "- Smallest integer that is not less than the value of the argument arg is 
floor "- Largest integer that is not greater than the value of the argument arg is 
trunc" - Value of the integer part of the argument arg 
frac "- Value of the decimal places of the argument arg 

ipow( base = arg exp = n ) "This function raises the argument arg passed to base to the exponent n passed to exp. 
"The arguments arg and n are numerical expression positions. 
"Any numeric data object can be specified for arg. n expects the type i and exponents of other types are converted to i.
"" If the argument arg has the value 0, then the value of the exponent n must be greater than or equal to 0. "

nmax|nmin( val1 = arg1 val2 = arg2 [val3 = arg3] ... [val9 = arg9] ) ... "These functions return the value of the biggest or 
"the smallest of the arguments passed. At least two arguments, arg1 and arg2, 
"and a maximum of nine arguments must be passed, whereby the optional input parameters val3 to val9 must be filled in 
"ascending order without gaps. The arguments arg1 to arg9 are numerical expression positions. 

acos "arccosine [-1,1], no decfloat34 
asin "arcsine [-1,1], no decfloat34 
atan "arctangent -, no decfloat34 
cos "cosine -, no decfloat34 
sin "sine -, no decfloat34 
tan "tangent -, no decfloat34 
cosh "hyperbolic cosine -, no decfloat34 
sinh "hyperbolic sine -, no decfloat34 
tanh "hyperbolic tangent -, no decfloat34 
exp "Exponential function for base e [-709, 709] for type f and [-14144, 14149] for type decfloat34 
log "Natural logarithm > 0 
log10 "Logarithm to base 10 > 0 
sqrt "Square root >= 0 
