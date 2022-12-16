{ lib ? import ./default.nix }: {
  "1970-01-01T00:00:00.000000000Z" = lib.ISO-8601 0;
  "2009-02-13T23:31:30.000000000Z" = lib.ISO-8601 1234567890;

  "Fri Feb 13 23:31:30 Z 2009" = (lib.splitSecondsSinceEpoch { } 1234567890).c;
  "12 AM" = with lib.splitSecondsSinceEpoch { } 0; "${toString I} ${p}";
  "12 PM" = with lib.splitSecondsSinceEpoch { } (12 * 60 * 60); "${toString I} ${p}";
  "8 AM" = with lib.splitSecondsSinceEpoch { } (8 * 60 * 60); "${toString I} ${p}";

  "May  1" = with lib.splitSecondsSinceEpoch { } 1651363200; "${b} ${lib.pad " " 2 d}";
  "08 AM" = with lib.splitSecondsSinceEpoch { } (8 * 60 * 60); "${lib.pad0 2 I} ${p}";
  "1970" = with lib.splitSecondsSinceEpoch { } 0; "${lib.pad0 4 Y}";
}
