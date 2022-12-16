{ lib ? import ./default.nix }: {
  "2009-02-13T23:31:30.000000000Z" = lib.ISO-8601 1234567890;
  "Fri Feb 13 23:31:30 Z 2009" = (lib.splitSecondsSinceEpoch { } 1234567890).c;
}
