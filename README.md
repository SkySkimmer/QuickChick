QuickChick
==========

### Description
 
  - Randomized property-based testing plugin for Coq; a clone of [Haskell QuickCheck]
  - Includes a [foundational verification framework for testing code]

[Haskell QuickCheck]:
https://hackage.haskell.org/package/QuickCheck

[foundational verification framework for testing code]:
http://prosecco.gforge.inria.fr/personal/hritcu/publications/foundational-pbt.pdf

For more information on QuickChick, look at the tutorial available under the qc folder 
of the deep spec summer school:
https://github.com/DeepSpec/dsss17

### Known to work with

  - Branch master: 
    * Coq 8.6
    * OCaml 4.03.0, 4.04
    * mathcomp-ssreflect-1.6.1 

  - Branch 8.4pl6 known to work with
    * OCaml 4.01.0 and Coq 8.4pl3 or OCaml 4.02.1 and Coq 8.4pl6
    * SSReflect 1.5 (http://ssr.msr-inria.inria.fr/FTP/)
  - Branch coq 8.5-* known to work with
    * Coq 8.5pl2 
    * OCaml 4.03.0
    * mathcomp-ssreflect v1.5 
    + 8.5-legacy contains the old typeclass hierarchy
    + 8.5-automation contains the new one
  - Branch coq.8.6 known to work with
    * Coq 8.6
    * OCaml 4.03.0
    * mathcomp-ssreflect-1.6.1

  - trunk is the experimental development branch, currently on 8.6

### Compilation and Installation

    # To get ssreflect, you need to add the Coq opam repository (if you haven't already)
    opam repo add coq-released https://coq.inria.fr/opam/released
    opam update
    opam install coq-mathcomp-ssreflect

    # Then:
    make && make install

### Simple Examples

  - `examples/Tests.v`
  - `examples/RedBlack`
  - `examples/stlc`
  - `examples/ifc-basic` (not quite finished)

Running `make tests` in the top-level QuickChick folder will check and execute all of these.

### Larger Case Study

  - See the https://github.com/QuickChick/IFC repository

### Top-level Commands

- `QuickCheck c`
- `QuickCheckWith args c`
- `MutateCheck c p`
- `MutateCheckWith args c p`
- `MutateCheckMany c ps`
- `MutateCheckManyWith args c ps`

### Documentation
Yes, we need more! Until then here are some reasonable surrogates:
  - Our ITP 2015 paper on [Foundational Property-Based Testing](http://prosecco.gforge.inria.fr/personal/hritcu/publications/foundational-pbt.pdf)
  - Catalin's [internship topic proposals for 2015](http://prosecco.gforge.inria.fr/personal/hritcu/students/topics/2015/quick-chick.pdf)
  - Catalin's [presentation at CoqPL 2015 workshop (2015-01-18)](http://prosecco.gforge.inria.fr/personal/hritcu/talks/QuickChick-Verified-Testing-CoqPL.pdf)
  - Zoe's [thesis defense at NTU Athens (2014-09-08)](http://prosecco.gforge.inria.fr/personal/hritcu/talks/zoe-defense.pdf)
  - Maxime's [presentation at the Coq Workshop (2014-07-18)](http://prosecco.gforge.inria.fr/personal/hritcu/talks/QuickChick-Coq.pdf)
  - Catalin's [presentation at the Coq Working Group @ PPS (2014-03-19)](http://prosecco.gforge.inria.fr/personal/hritcu/talks/QuickChick-PPS.pdf)
