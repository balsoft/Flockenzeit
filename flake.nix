{
  description = "Nix datetime manipulation library";
  outputs = { self }: {
    lib = import ./default.nix;
    checks = let
      assertEq = real: golden: def:
        if real == golden then def else throw "Assertion failed: ${real} != ${golden}";
    in __deepSeq (__mapAttrs (n: v: assertEq v n null)
      (import ./tests.nix { inherit (self) lib; })) { };
  };
}
