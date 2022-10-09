{ mkDerivation, base, bitvec, bytestring, containers, lib
, mwc-random, primitive, QuickCheck, vector
}:
mkDerivation {
  pname = "vector-algorithms";
  version = "0.9.0.1";
  sha256 = "2ba7c0d3a8f26ef3ada24ff4abe81609225ecbab3b5754f048f8a0a3ecc33841";
  libraryHaskellDepends = [
    base bitvec bytestring primitive vector
  ];
  testHaskellDepends = [
    base bytestring containers QuickCheck vector
  ];
  benchmarkHaskellDepends = [ base mwc-random vector ];
  homepage = "https://github.com/erikd/vector-algorithms/";
  description = "Efficient algorithms for vector arrays";
  license = lib.licenses.bsd3;
}
