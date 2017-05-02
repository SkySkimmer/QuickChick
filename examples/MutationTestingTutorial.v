From QuickChick Require Import QuickChick Tactics.
Require Import String. Open Scope string.

From mathcomp Require Import ssreflect ssrfun ssrbool ssrnat eqtype seq.

Import GenLow GenHigh.
Require Import List.
Import ListNotations.
Import QcDefaultNotation. Open Scope qc_scope.
Import QcDoNotation.


Set Bullet Behavior "Strict Subproofs".

(*! Section Prop12 *)

Require Import Arith.

Definition testProp1 (x : nat) := beq_nat x 0.

Definition testProp2 (x : nat) := beq_nat x x.

(*!
QuickChick testProp1. 
*)

(*! QuickChick testProp2. *)

(*! Section Prop3 extends Prop12 *)
Definition testProp3 (x y : nat) := beq_nat x y.

(*!
QuickChick testProp3.
*)

(*! Section Prop4 *)
Definition testProp4 (x y : nat) := beq_nat x y.

(*!
QuickChick testProp4.
*)