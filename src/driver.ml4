open Pp
open Loc
open Names
open Extract_env
open Tacmach
open Entries
open Declarations
open Declare
open Libnames
open Util
open Constrintern
open Topconstr
open Constrexpr
open Constrexpr_ops
open Decl_kinds
open GenericLib
open SetLib
open CoqLib
open Sized
open SizeMon
open SizeSMon
open SizeCorr

type derivation = SimpleDer of SimplDriver.derivable list
                | DepDer of DepDriver.derivable list

let dispatch cn ind = 
  let s = match cn with 
    | CRef (r, _) -> string_of_qualid (snd (qualid_of_reference r))
    | _ -> failwith "Usage: Derive <class_name> for <inductive_name>"
  in 

  let ind_name = match ind with 
    | CRef (r, _) -> string_of_qualid (snd (qualid_of_reference r))
    | _ -> failwith "Implement me for functions" 
  in 
  
  let class_names = match s with 
    | "Arbitrary" -> SimpleDer [SimplDriver.ArbitrarySized; SimplDriver.Shrink]
    | "Show" -> SimpleDer [SimplDriver.Show]
  in 

  match class_names with 
  | SimpleDer classes -> 
     List.iter (fun cn -> SimplDriver.derive cn ind (SimplDriver.mk_instance_name cn ind_name) "" "") classes
  | _ -> failwith "Do this"

VERNAC COMMAND EXTEND Derive 
   | ["Derive" constr(class_name) "for" constr(inductive)] -> 
      [dispatch class_name inductive]
(*   | ["Derive" constr(class_name) "for" constr(inductive) "as" string(s1)] -> 
      [dispatch class_name inductive (Some s1) None]
   | ["Derive" constr(class_name) "for" constr(inductive) "as" string(s1) "and" string(s2)] -> 
      [dispatch class_name inductive (Some s1) (Some s2)]
 *)
END;;

(*

VERNAC COMMAND EXTEND DeriveArbitrarySized
  | ["DeriveArbitrarySized" constr(c) "as" string(s1)] -> [derive ArbitrarySized c s1 "aux" ""]
END;;

VERNAC COMMAND EXTEND DeriveSized
  | ["DeriveSized" constr(c) "as" string(s1)] -> [derive Sized c s1 "aux" ""]
END;;

VERNAC COMMAND EXTEND DeriveCanonicalSized
  | ["DeriveCanonicalSized" constr(c) "as" string(s1)] -> [derive CanonicalSized c s1 "aux" ""]
END;;

VERNAC COMMAND EXTEND DeriveArbitrarySizedMonotonic
  | ["DeriveArbitrarySizedMonotonic" constr(c) "as" string(s1) "using" string(s2)] ->
  (* s2 is the instance name for ArbitrarySized *)
    [derive SizeMonotonic c s1 s2 ""]
END;;

VERNAC COMMAND EXTEND DeriveArbitrarySizedSizeMonotonic
  | ["DeriveArbitrarySizedSizeMonotonic" constr(c) "as" string(s1)] ->
    [derive SizeSMonotonic c s1 "" ""]
END;;


VERNAC COMMAND EXTEND DeriveArbitrarySizedCorrect
  | ["DeriveArbitrarySizedCorrect" constr(c) "as" string(s1) "using" string(s2) "and" string(s3)] ->
    [derive GenSizeCorrect c s1 s2 s3]
END;;
 *)
