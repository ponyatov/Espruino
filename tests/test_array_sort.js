var a = [5,6,8,1,4,7,7,6,1].sort().toString();
var b = (new Uint8Array([1,1,4,5,6,6,7,7,8])).sort().toString();
var c = [5,6,8,1,4,7,7,6,1].sort(function(a,b) { return (a>b)?-1:((a<b)?1:0); }).toString();
var d = [ 0.933, 0.708, 0.256, 0.685, 0.657, 0.433, 0.272, 0.347, 0.376, 0.307 ].sort(function(a,b) { return a-b; }).toString();
var e = ([2,-1,0,-2,1]).sort().toString(); // go JS!
var f = (new Int8Array([2,-1,0,-2,1])).sort().toString();
var g = ([1,undefined,5,undefined,2].sort((a,b)=>a-b).toString());
var h = ([1,undefined,5,undefined,2].sort().toString());

result = "1,1,4,5,6,6,7,7,8"==a && "1,1,4,5,6,6,7,7,8"==b && "8,7,7,6,6,5,4,1,1"==c && "0.256,0.272,0.307,0.347,0.376,0.433,0.657,0.685,0.708,0.933"==d && e=="-1,-2,0,1,2" && f=="-2,-1,0,1,2" && g == "1,2,5,," && h == "1,2,5,,";

