{ mkDerivation, base, base-orphans, deepseq, doctest, HUnit, lib, primitive
, QuickCheck, random, tasty, tasty-bench, tasty-hunit
, tasty-inspection-testing, tasty-quickcheck, template-haskell
, transformers, vector-stream
}:
mkDerivation {
  pname = "vector";
  version = "0.13.0.0";
  sha256 = "c5d3167d15e12f52e00879ddf304a591672a74e369cc47bc5c7fa1d5a8d15b4f";
  revision = "1";
  editedCabalFile = "12cwdaqsy9dv7j7cwq6r6kdyfxqiya8khm6ccaabjhhpa2aqwljl";
  libraryHaskellDepends = [ base deepseq primitive vector-stream ];
  testHaskellDepends = [
    base base-orphans doctest HUnit primitive QuickCheck random tasty
    tasty-hunit tasty-inspection-testing tasty-quickcheck
    template-haskell transformers
  ];
  benchmarkHaskellDepends = [ base random tasty tasty-bench ];
  homepage = "https://github.com/haskell/vector";
  description = "Efficient Arrays";
  license = lib.licenses.bsd3;
}
