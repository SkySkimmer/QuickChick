From QuickChick Require Import QuickChick Tactics Instances Classes DependentClasses.
Require Import String. Open Scope string.
Require Import List.

From mathcomp Require Import ssreflect ssrfun ssrbool ssrnat eqtype seq.

Import GenLow GenHigh .

Import ListNotations.
Import QcDefaultNotation. Open Scope qc_scope.
Import QcDoNotation.

Set Bullet Behavior "Strict Subproofs".

Typeclasses eauto := debug.

Require Import zoo DependentTest.

Lemma eq_symm {A : Type} (x y : A) :
  x = y -> y = x.
Proof.
  firstorder.
Qed.

(* Yikes this is stupid, find a workaround *)
Definition prop := Prop.


Inductive tree : Type :=
| Leaf : tree
| Node : nat -> tree -> tree -> tree.


(* Example with two IH *)

Inductive goodTree : nat -> tree -> Prop :=
| GL : goodTree 0 Leaf
| GN : forall k t1 t2 n m, goodTree n t1 ->
                      goodTree m t2 ->
                      goodTree m t1 ->
                      goodTree (S n) (Node k t1 t2).

Instance DecgoodTree (n : nat) (t : tree) : Dec (goodTree n t).
Admitted.

Instance DecTreeEq (t1 t2 : tree) : Dec (t1 = t2).
Admitted.

Derive ArbitrarySizedSuchThat for (fun foo => goodTree n foo).

Derive SizedProofEqs for (fun foo => goodTree n foo).

Derive SizeMonotonicSuchThatOpt for (fun foo => goodTree n foo).

Existing Instance GenOfGenSized.
Existing Instance genNatSized.

Definition a (n : nat) := @arbitraryST _ (fun foo => goodTree n foo) _.

Lemma suchThatMaybeOpt_subset_compat {A : Type} (p : A -> bool) (g1 g2 : G (option A)) s :
  isSome :&: (semGenSize g1 s) \subset isSome :&: (semGenSize g2 s) ->
  isSome :&: (semGenSize (suchThatMaybeOpt g1 p) s) \subset
  isSome :&: (semGenSize (suchThatMaybeOpt g2 p) s).
Proof.
Admitted.

Lemma suchThatMaybe_subset_compat {A : Type} (p : A -> bool) (g1 g2 : G A) s :
  (semGenSize g1 s) \subset (semGenSize g2 s) ->
  isSome :&: (semGenSize (suchThatMaybe g1 p) s) \subset
  isSome :&: (semGenSize (suchThatMaybe g2 p) s).
Proof.
Admitted.

Lemma bigcup_cons_setI_subset_compat {A B} (f : A -> set B)
      (x x' : A) (l l' : seq A) s :
  f x \subset f x' ->
  \bigcup_(x in (l :&: s)) (f x) \subset
   \bigcup_(x in (l' :&: s)) (f x) ->
  \bigcup_(x in ((x :: l) :&: s)) (f x) \subset
   \bigcup_(x in ((x' :: l') :&: s)) (f x).
Proof.
Admitted.

(* more specific lemmas to help type checking of the proof term *)
Lemma bigcup_cons_setI_subset_compat_backtrack {A}
      (n n' : nat) (g g' : G (option A)) (l l' : seq (nat * G (option A))) s :
  isSome :&: semGenSize g s  \subset isSome :&: semGenSize g' s ->
  \bigcup_(x in (l :&: (fun x => x.1 <> 0))) (isSome :&: semGenSize x.2 s) \subset
  \bigcup_(x in (l' :&: (fun x => x.1 <> 0))) (isSome :&: semGenSize x.2 s) ->
  \bigcup_(x in (((n, g) :: l) :&: (fun x => x.1 <> 0))) (isSome :&: semGenSize x.2 s) \subset
  \bigcup_(x in (((n', g') :: l') :&: (fun x => x.1 <> 0))) (isSome :&: semGenSize x.2 s).
Proof.
Admitted.

Lemma bigcup_cons_setI_subset_pres_backtrack {A}
      (n : nat) (g : G (option A)) (l l' : seq (nat * G (option A))) s :
  \bigcup_(x in (l :&: (fun x => x.1 <> 0))) (isSome :&: semGenSize x.2 s) \subset
  \bigcup_(x in (l' :&: (fun x => x.1 <> 0))) (isSome :&: semGenSize x.2 s) ->
  \bigcup_(x in (l :&: (fun x => x.1 <> 0))) (isSome :&: semGenSize x.2 s) \subset
  \bigcup_(x in ((n, g) :: l') :&: (fun x => x.1 <> 0)) (isSome :&: semGenSize x.2 s).
Proof.
Admitted.

Lemma bigcup_nil_setI {A B} (f : A -> set B)
      (l : seq A) s :
  \bigcup_(x in [] :&: s) (f x) \subset
  \bigcup_(x in (l :&: s)) (f x).
Proof.
Admitted.

Derive GenSizedSuchThatSizeMonotonicOpt for (fun foo => goodTree n foo).

Lemma isSomeSome {A : Type} (y : A) :
  Some y.
Proof.
  exact isT.
Qed.

Lemma semBacktrack:
  forall (A : Type) (l : seq (nat * G (option A))),
    semGen (backtrack l) <-->
    (\bigcup_(x in (l :&: (fun x => x.1 <> 0))) (isSome :&: (semGen x.2))) :|:
    ([set None] :&: (\bigcap_(x in l :&: (fun x => x.1 <> 0)) (semGen x.2))).
Admitted.


Lemma semSuchThatMaybe_complete:
  forall (A : Type) (g : G A) (f : A -> bool) (s : set A),
    s \subset semGen g ->
    (Some @: (s :&: (fun x : A => f x))) \subset
    semGen (suchThatMaybe g f).
Proof.
Admitted.

Lemma semSuchThatMaybeOpt_complete:
  forall (A : Type) (g : G (option A)) (f : A -> bool) (s : set A),
    (Some @: s) \subset semGen g ->
    (Some @: (s :&: (fun x : A => f x))) \subset
    semGen (suchThatMaybeOpt g f).
Proof.
Admitted.

Lemma semSuchThatMaybe_sound:
  forall (A : Type) (g : G A) (f : A -> bool) (s : set A),
    semGen g \subset s ->
    semGen (suchThatMaybe g f) \subset ((Some @: (s :&: (fun x : A => f x))) :|: [set None]).
Proof.
Admitted.

Lemma semSuchThatMaybeOpt_sound:
  forall (A : Type) (g : G (option A)) (f : A -> bool) (s : set A),
    semGen g \subset ((Some @: s) :|: [set None]) ->
    semGen (suchThatMaybeOpt g f) \subset (Some @: (s :&: (fun x : A => f x)) :|: [set None]).
Proof.
Admitted.


(* Definition gen (n : nat) : G (option tree) := @arbitraryST _ (fun foo => goodTree n foo) _. *)

(* Definition inst (n : nat) := @STComplete _ (fun foo => goodTree n foo) ( @arbitraryST _ (fun foo => goodTree n foo) _) _. *)

(* XXX these instances should be present *)
Existing Instance genSFoo.
Existing Instance shrFoo.
Derive Sized for Foo.
Derive SizeMonotonic for Foo using genSFoo.
Derive SizedMonotonic for Foo using genSFoo.
Derive CanonicalSized for Foo.
Derive SizedCorrect for Foo using genSFoo and SizeMonotonicFoo.

Definition corr := @arbitraryCorrect Foo arbitrary _.

Existing Instance GenSizedSuchThatgoodFooUnif. (* ???? *)

Derive SizeMonotonicSuchThatOpt for (fun (x : Foo) => goodFooUnif input x).

Derive SizedProofEqs for (fun foo => goodFooUnif n foo).

Derive GenSizedSuchThatCorrect for (fun foo => goodFooUnif n foo).

Derive GenSizedSuchThatSizeMonotonicOpt for (fun foo => goodFooUnif n foo).

Definition genSTgoodFooUnif (n : nat) := @arbitraryST _  (fun foo => goodFooUnif n foo) _.

Definition genSTgoodFooUnifSound (n : nat) := @STSound _ _ (@arbitraryST _  (fun foo => goodFooUnif n foo) _) _.

(* Interesting. Do we need  Global instance?? *) 
Existing Instance GenSizedSuchThatgoodFooNarrow.  (* Why???? *)

Derive SizeMonotonicSuchThatOpt for (fun foo => goodFooNarrow n foo).

Derive SizedProofEqs for (fun foo => goodFooNarrow n foo).

Derive GenSizedSuchThatCorrect for (fun foo => goodFooNarrow n foo).

Derive GenSizedSuchThatSizeMonotonicOpt for (fun foo => goodFooNarrow n foo).

Definition genSTgoodFooNarrow (n : nat) := @arbitraryST _  (fun foo => goodFooNarrow n foo) _.

Definition genSTgoodFooNarrowSound (n : nat) := @STSound _ _ (@arbitraryST _  (fun foo => goodFooNarrow n foo) _) _.

Existing Instance GenSizedSuchThatgoodFooCombo.

Derive SizeMonotonicSuchThatOpt for (fun foo => goodFooCombo n foo).

Derive SizedProofEqs for (fun foo => goodFooCombo n foo).

Derive GenSizedSuchThatCorrect for (fun foo => goodFooCombo n foo).

Derive GenSizedSuchThatSizeMonotonicOpt for (fun foo => goodFooCombo n foo).

Definition genSTgoodFooCombo (n : nat) := @arbitraryST _  (fun foo => goodFooCombo n foo) _.

Definition genSTgoodFooComboSound (n : nat) := @STSound _ _ (@arbitraryST _  (fun foo => goodFooCombo n foo) _) _.

Existing Instance GenSizedSuchThatgoodFoo.

Derive SizeMonotonicSuchThatOpt for (fun (x : Foo) => goodFoo input x).

Derive SizedProofEqs for (fun (x : Foo) => goodFoo input x).

Derive GenSizedSuchThatCorrect for (fun foo => goodFoo n foo).

Derive GenSizedSuchThatSizeMonotonicOpt for (fun foo => goodFoo n foo).

Definition genSTgoodFoo (n : nat) := @arbitraryST _  (fun foo => goodFoo n foo) _.

Definition genSTgoodFooSound (n : nat) := @STSound _ _ (@arbitraryST _  (fun foo => goodFoo n foo) _) _.

Existing Instance GenSizedSuchThatgoodFooPrec.  (* ???? *)

Derive SizeMonotonicSuchThatOpt for (fun (x : Foo) => goodFooPrec input x).

Derive SizedProofEqs for (fun (x : Foo) => goodFooPrec input x).

Derive GenSizedSuchThatCorrect for (fun foo => goodFooPrec n foo).

Derive GenSizedSuchThatSizeMonotonicOpt for (fun foo => goodFooPrec n foo).

Definition genSTgoodFooPrec (n : nat) := @arbitraryST _  (fun foo => goodFooPrec n foo) _.

Definition genSTgoodFooPrecSound (n : nat) := @STSound _ _ (@arbitraryST _  (fun foo => goodFooPrec n foo) _) _.

Existing Instance GenSizedSuchThatgoodFooMatch.  (* ???? *)

Derive SizeMonotonicSuchThatOpt for (fun foo => goodFooMatch n foo).

Derive SizedProofEqs for (fun foo => goodFooMatch n foo).

Derive GenSizedSuchThatCorrect for (fun foo => goodFooMatch n foo).

Derive GenSizedSuchThatSizeMonotonicOpt for (fun foo => goodFooMatch n foo).

Definition genSTgoodFooMatch (n : nat) := @arbitraryST _  (fun foo => goodFooMatch n foo) _.

Definition genSTgoodFooMatchSound (n : nat) := @STSound _ _ (@arbitraryST _  (fun foo => goodFooMatch n foo) _) _.

Existing Instance GenSizedSuchThatgoodFooRec.  (* ???? *)

Derive SizeMonotonicSuchThatOpt for (fun (x : Foo) => goodFooRec input x).

Derive SizedProofEqs for (fun (x : Foo) => goodFooRec input x).

Derive GenSizedSuchThatCorrect for (fun foo => goodFooRec n foo).

Derive GenSizedSuchThatSizeMonotonicOpt for (fun foo => goodFooRec n foo).

Definition genSTgoodFooRec (n : nat) := @arbitraryST _  (fun foo => goodFooRec n foo) _.

Definition genSTgoodFooRecSound (n : nat) := @STSound _ _ (@arbitraryST _  (fun foo => goodFooRec n foo) _) _.

Inductive goodFooB : nat -> Foo -> Prop :=
| GF1 : goodFooB 2 (Foo2 Foo1)
| GF2 : goodFooB 3 (Foo2 (Foo2 Foo1)).

Derive ArbitrarySizedSuchThat for (fun (x : Foo) => goodFooB input x).

Derive SizedProofEqs for (fun (x : Foo) => goodFooB input x).

Derive SizeMonotonicSuchThatOpt for (fun foo => goodFooB n foo).

Derive GenSizedSuchThatCorrect for (fun foo => goodFooB n foo).

Derive GenSizedSuchThatSizeMonotonicOpt for  (fun foo => goodFooB n foo).

Definition genSTgoodFooB (n : nat) := @arbitraryST _  (fun foo => goodFooB n foo) _.

Definition genSTgoodFooBSound (n : nat) := @STSound _ _ (@arbitraryST _  (fun foo => goodFooB n foo) _) _.

(* Derive SizeMonotonicSuchThat for (fun foo => goodTree n foo). *)
(* XXX
   bug for 
| GL : goodTree 0 Leaf
| GN : forall k t1 t2 n, goodTree n t1 ->
                      ~ t1 =  t2 ->υ
                      (* goodTree m t1 -> *)
                      goodTree (S n) (Node k t1 t2).
 *)

Inductive LRTree : tree -> Prop :=
| PLeaf : LRTree Leaf
| PNode :
    forall m t1 t2,
      ~ t1 = Node 2 Leaf Leaf ->
      ~ Node 4 Leaf Leaf = t1 ->
      LRTree t1 ->
      LRTree t2 ->
      LRTree (Node m t1 t2).



Derive ArbitrarySizedSuchThat for (fun (x : tree) => LRTree x).

(* XXX sucThatMaybe case *)

Instance DecidableLRTree t : Dec (LRTree t).
Proof.
Admitted.


Derive SizedProofEqs for (fun (x : tree) => LRTree x).

Derive SizeMonotonicSuchThatOpt for (fun foo => LRTree foo).

Derive GenSizedSuchThatCorrect for (fun foo => LRTree foo).

Derive GenSizedSuchThatSizeMonotonicOpt for (fun foo => LRTree foo).

Definition genSTLRTree (n : nat) := @arbitraryST _  (fun foo => LRTree foo) _.

Definition genSTLRTreeSound (n : nat) := @STSound _ _ (@arbitraryST _  (fun foo => LRTree foo) _) _.


Inductive HeightTree : nat -> tree -> Prop :=
| HLeaf : forall n, HeightTree n Leaf
| HNode :
    forall t1 t2 n m,
      HeightTree n t1 ->
      HeightTree n t2 ->
      HeightTree (S n) (Node m t1 t2).


Instance ArbitrarySuchThatEql {A} (x : A) : GenSuchThat A (fun y => eq x y) :=
  {| arbitraryST := returnGen (Some x) |}.



(* XXX breaks gen *)

(* Inductive ex_test : tree -> Prop := *)
(* | B : ex_test Leaf  *)
(* | Ind : *)
(*     forall (list  y12  : nat) t, *)
(*       list = y12 -> *)
(*       ex_test (Node 4 t t). *)

(* Derive ArbitrarySizedSuchThat for (fun (x : tree) => ex_test x). *)

(* Set Printing All.  *)

(* Inductive LRTree : tree -> Prop := *)
(* | PLeaf : LRTree Leaf *)
(* | PNode : *)
(*     forall m t1 t2, *)
(*       Node 2 Leaf Leaf = t1 -> *)
(*       t1 = Node 2 Leaf Leaf -> *)
(*       LRTree t1 -> *)
(*       LRTree t2 -> *)
(*       LRTree (Node m t1 t2). *)

(* Inductive test : nat -> Foo -> Prop := *)
(* | T : forall (x : False), test 1 Foo1. *)

(* Derive ArbitrarySizedSuchThat for (fun foo => test n foo). *)

(* Inductive test1 : bool -> Foo -> Prop := *)
(* | T1 : forall (x1 x2 x3 : bool), x1 = x3 -> test1 x2 Foo1. *)

(* Derive ArbitrarySizedSuchThat for (fun foo => test1 n foo). *)

(* Inductive test2 : nat -> Foo -> Prop := *)
(* | T2 : forall (x1 x2 : bool), x1 = x2 ->  test2 1 Foo1. *)
 
(* Derive ArbitrarySizedSuchThat for (fun foo => test2 n foo). *)

(* XXX weird bug when naming binders with name of already existing ids,
   e.g. nat, list*)

(* Inductive HeightTree : nat -> tree -> Prop := *)
(* | HLeaf : forall n, HeightTree n Leaf *)
(* | HNode : *)
(*     forall t1 t2 n k m, *)
(*       k = 3 -> *)
(*       HeightTree k t2 -> *)
(*       HeightTree k t1 -> *)
(*       HeightTree n (Node m t1 t2). *)

(* Inductive goodTree : nat -> tree -> Prop := *)
(* | GL : goodTree 0 Leaf *)
(* | GN : forall k t1 t2 n m, goodTree n t1 -> *)
(*                       goodTree m t2 -> *)
(*                       goodTree (n + m + 1) (Node k t1 t2). *)

(* Lemma test2 {A} (gs1 gs2 : nat -> list (nat * G (option A))) s s1 s2 :  *)
(*       \bigcup_(g in gs1 s1) (semGenSize (snd g) s) \subset  \bigcup_(g in gs2 s2) (semGenSize (snd g) s) -> *)
(*       semGenSize (backtrack (gs1 s1)) s \subset semGenSize (backtrack (gs2 s2)) s. *)
(* Admitted. *)

(* Goal (forall inp : nat, SizedMonotonic (@arbitrarySizeST Foo (fun (x : Foo) => goodFooRec inp x) _)). *)
(* Proof. *)
(*   intros inp. *)
(*   constructor. *)
(*   intros s s1 s2. *)
(*   revert inp. *)
(*   induction s1; induction s2; intros. *)
(*   - simpl. eapply subset_refl. *)
(*   - simpl. *)
(*     refine (test *)
(*               (fun s => [(1, returnGen (Some Foo1))]) *)
(*               (fun s => [(1, returnGen (Some Foo1)); *)
(*                        (1, *)
(*                         doM! foo <- *)
(*                            (fix aux_arb (size0 input0_ : nat) {struct size0} :  *)
(*                               G (option Foo) := *)
(*                               match size0 with *)
(*                                 | 0 => backtrack [(1, returnGen (Some Foo1))] *)
(*                                 | size'.+1 => *)
(*                                   backtrack *)
(*                                     [(1, returnGen (Some Foo1)); *)
(*                                       (1, doM! foo <- aux_arb size' 0; returnGen (Some (Foo2 foo)))] *)
(*                               end) s 0; returnGen (Some (Foo2 foo)))]) *)
(*               s 0 s2 _). *)
(*     admit. *)
(*   - ssromega. *)
(*   - simpl. *)
(*     refine (test *)
(*               (fun s => [(1, returnGen (Some Foo1)); *)
(*                        (1, *)
(*                         doM! foo <- *)
(*                            (fix aux_arb (size0 input0_ : nat) {struct size0} :  *)
(*                               G (option Foo) := *)
(*                               match size0 with *)
(*                                 | 0 => backtrack [(1, returnGen (Some Foo1))] *)
(*                                 | size'.+1 => *)
(*                                   backtrack *)
(*                                     [(1, returnGen (Some Foo1)); *)
(*                                       (1, doM! foo <- aux_arb size' 0; returnGen (Some (Foo2 foo)))] *)
(*                               end) s 0; returnGen (Some (Foo2 foo)))]) *)
(*               (fun s => [(1, returnGen (Some Foo1)); *)
(*                        (1, *)
(*                         doM! foo <- *)
(*                            (fix aux_arb (size0 input0_ : nat) {struct size0} :  *)
(*                               G (option Foo) := *)
(*                               match size0 with *)
(*                                 | 0 => backtrack [(1, returnGen (Some Foo1))] *)
(*                                 | size'.+1 => *)
(*                                   backtrack *)
(*                                     [(1, returnGen (Some Foo1)); *)
(*                                       (1, doM! foo <- aux_arb size' 0; returnGen (Some (Foo2 foo)))] *)
(*                               end) s 0; returnGen (Some (Foo2 foo)))]) *)
(*               s s1 s2 _). *)
(*     admit. *)

Definition success := "Proofs work!".
Print success.