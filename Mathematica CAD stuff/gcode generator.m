(* ::Package:: *)

(************************************************************************)
(* This file was generated automatically by the Mathematica front end.  *)
(* It contains Initialization cells from a Notebook file, which         *)
(* typically will have the same name as this file except ending in      *)
(* ".nb" instead of ".m".                                               *)
(*                                                                      *)
(* This file is intended to be loaded into the Mathematica kernel using *)
(* the package loading commands Get or Needs.  Doing so is equivalent   *)
(* to using the Evaluate Initialization Cells menu command in the front *)
(* end.                                                                 *)
(*                                                                      *)
(* DO NOT EDIT THIS FILE.  This entire file is regenerated              *)
(* automatically each time the parent Notebook file is saved in the     *)
(* Mathematica front end.  Any changes you make to this file will be    *)
(* overwritten.                                                         *)
(************************************************************************)




(*this function returns a grid construct clearly showing each member of the list in its own box.  This is useful for seeing exactly what is in a list.  this function is not directly relevant to the gcode generator.*)
lucidlistform[list_] := 
Grid[
Table[
{i,list[[i]]},
{i,1,Length[list]}
],
Frame -> All
];

parameterstring[namestring_,value_] := 
namestring <> 
ToString[
Round[value,10^-4] //N
]<> " "; (*I have this function in place in case different parameters need to be formatted with different precision numbers*)


(*
drillevent[
(*x:*) ,
(*y:*) ,
(*zfinal:*)  ,
(*zretract:*) ,
(*feedspeed:*) ,
(*peckdepth:*) , 
(*ztraverse*) 
]

*)
drillevent[x_ ,y_ , zfinal_, zretract_, feedspeed_,peckdepth_, ztraverse_] := 
StringJoin @
{
"G00 ",parameterstring["Z",ztraverse],"\t\n" , 

"G00 ",parameterstring["X",x], parameterstring["Y",y] ,"\t\n" , 

"G00 ",parameterstring["Z",zretract],"\t\n" ,

"G83 " ,
parameterstring["X",x],
parameterstring["Y",y],
parameterstring["Z",zfinal],
parameterstring["R",zretract],
parameterstring["F",feedspeed],
parameterstring["Q",peckdepth],"\t\n", 

 "G00 ", parameterstring["Z",ztraverse],

"\n"
};


(*
drillpoints[
(*zfinal:*)  ,
(*zretract:*) ,
(*feedspeed:*) ,
(*peckdepth:*) , 
(*ztraverse*) 
] @ 
*)

(*this function extracts all pairs {x,y} occuring within Point constructs within the input object.*)

extractlistofpoints[inputobject_] :=  Flatten[
Cases[
{inputobject},
point_?(Head[#] == Point &) :>   
Cases[
point,
xy_?(MatchQ[#,{_?(NumericQ[#]&), _?(NumericQ[#]&)}]&),
Infinity
],
Infinity
],
1
] ;

(*this function extracts all pairs {x,y} occuring within Point constructs within the input object.  This function outputs a list of drillevents, one for each {x,y} pair extracted.*)
drillpoints[zfinal_, zretract_, feedspeed_,peckdepth_, ztraverse_][inputobject_] :=
Block[
{listofpositions},
listofpositions = extractlistofpoints[inputobject] ;

Table[
drillevent[
(*x:*)xy[[1]],
(*y:*) xy[[2]],
(*zfinal:*)  zfinal,
(*zretract:*) zretract,
(*feedspeed:*) feedspeed,
(*peckdepth:*) peckdepth, 
(*ztraverse*) ztraverse
],
{xy,listofpositions}
]

];





makecamfile[machiningeventlist_,filenumber_] :=
Block[
{camfilename ,camfilepath,stringtoexport},

camfilename =  StringTake[#,-8]& @ToString[PaddedForm[filenumber,{8,0},NumberPoint -> "",NumberPadding -> "0",SignPadding->False,NumberSigns -> {"",""}]]<> ".CAM";
camfilepath = FileNameJoin @ {camfiledirectory, camfilename};
stringtoexport = camfilepreamble  <> StringJoin[machiningeventlist] ;
If[
StringCount[stringtoexport,"notset"] >= 1,
Print@ "ERROR making CAM file: some of the options to machining event constructs were left unset"; Return[];
];

 Export[camfilepath,stringtoexport,"TEXT"];
];
