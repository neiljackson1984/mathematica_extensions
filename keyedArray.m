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



Unprotect@keyedArray;
Remove[keyedArray];
SetAttributes[keyedArray, Protected];

Unprotect@keyedPart;
Attributes[keyedPart] = {};
Remove[keyedPart];
SetAttributes[keyedPart,HoldAll];
keyedPart[x_, key_, newvalue_:Null, equalsstring_:"="] := 
Block[
{address},
address = Position[x, key, {2}];
If[Length@address == 0, 
If[
MatchQ[newvalue,Null],
Return[Null],
(*in this case, the key does not yet exist, and the user has passed a newvalue, so we need to create the key.*)
AppendTo[x,{key,Null}];
Return[keyedPart[x,key,newvalue,equalsstring]];

]
];
address = First@address;
If[address[[-1]] != 1, Return[Null]];
address[[-1]] = 2;

If[
!MatchQ[newvalue,Null],
ToExpression@StringJoin@ Flatten@  (*There is probably a better way to do this than by converting the command into a string, but I can't figure out the order of evaluation.*)
{
"Part[",
ToString@Unevaluated@x,
Table[
", " <> ToString[i] ,
{i,address}
],
"] ",
equalsstring,
" ",
ToString@InputForm@Unevaluated@newvalue
};
];

Return[Part[x,Sequence@@address]];

];

(*this lets us use the syntax namedpart[x,partname] = newvalue (or :=) to alter the definition of x.  *)
UpValues[keyedPart] = 
{
HoldPattern[Set[keyedPart[x_, key_],y_] ] :> keyedPart[x,key,y, "="],
HoldPattern[SetDelayed[keyedPart[x_, key_],y_] ] :> keyedPart[x,key,y, ":="]
}; 
SetAttributes[keyedPart, Protected] ;







(*takes an m by n list whose first row is presumed to contain the array keys, like the header row of a table, and produces a list of keyedArrays.  The idea here is to apply this function to an SQL result set returned by SQLExecute with the "ShowColumnHeadings" option set to True.  Then, the result will be a list of keyedArrays, where we can access the elements with keyedPart and specify the name of the column rather than the numerical index of the column.  *)
tableWithHeadingsToListOfKeyedArrays[resultSet_] := Table[
keyedArray@@Transpose@{resultSet[[1]],row},
{row,resultSet[[2;;-1]]}
];

(*define an alias for this ridiculously long function name*)
toKeyed = tableWithHeadingsToListOfKeyedArrays;



(*returns a list of all keys in the given keyedArray*)
keys[x_] := If[
Length@x >0,
First@Transpose@Level[x,1],
{}
];




