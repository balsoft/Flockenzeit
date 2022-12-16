rec {
  pad = p: n: s:
    let
      s' = toString s;
      l = __stringLength s';
    in __concatStringsSep ""
    (__genList (_: p) (if n - l > 0 then n - l else 0) ++ [ s' ]);
  pad0 = pad "0";
  pads = pad " ";

  locales = {
    C = {
      months = [
        "January"
        "February"
        "March"
        "April"
        "May"
        "June"
        "July"
        "August"
        "September"
        "October"
        "November"
        "December"
      ];
      weekdays = [
        "Monday"
        "Tuesday"
        "Wednesday"
        "Thursday"
        "Friday"
        "Saturday"
        "Sunday"
      ];
      dateFormat = parsed:
        with parsed;
        "${a} ${b} ${pad " " 2 d} ${T} ${Z} ${pad0 4 Y}";
      AM = "AM";
      PM = "PM";
    };
  };

  splitSecondsSinceEpoch = { locale ? locales.C }:
    t:
    let
      rem = x: y: x - x / y * y;
      days = t / 86400;
      secondsInDay = rem t 86400;
      H = secondsInDay / 3600;
      M = (rem secondsInDay 3600) / 60;
      S = rem t 60;

      # Courtesy of https://stackoverflow.com/a/32158604.
      z = days + 719468;
      era = (if z >= 0 then z else z - 146096) / 146097;
      doe = z - era * 146097;
      yoe = (doe - doe / 1460 + doe / 36524 - doe / 146096) / 365;
      y = yoe + era * 400;
      doy = doe - (365 * yoe + yoe / 4 - yoe / 100);
      mp = (5 * doy + 2) / 153;
      d = doy - (153 * mp + 2) / 5 + 1;
      m = mp + (if mp < 10 then 3 else -9);
      Y = y + (if m <= 2 then 1 else 0);
      w = rem (z + 2) 7;
      q = __div m 4 + 1;
      u = w + 1;
      j = doy;
      A = __elemAt locale.weekdays w;
      a = __substring 0 3 A;
      B = __elemAt locale.months (m - 1);
      b = __substring 0 3 B;
      F = "${pad0 4 Y}-${pad0 2 m}-${pad0 2 d}";
      T = "${pad0 2 H}:${pad0 2 M}:${pad0 2 S}";
      I' = rem H 12;
      I = if I' == 0 then 12 else I';
      p = __elemAt [locale.AM locale.PM] (__div H 12);

      primitives = {
        s = t;
        inherit H M S Y m d w u q A a B b F T j p I;
        N = "000000000";
        z = "+0000";
        Z = "Z";
      };
    in primitives // {
      c = locale.dateFormat primitives;
    };

  ISO-8601 = s: with splitSecondsSinceEpoch { } s; "${F}T${T}.${N}${Z}";
  RFC-5322 = s: with splitSecondsSinceEpoch { } s; "${a}, ${pad0 2 d} ${b} ${pad0 4 Y} ${T} ${z}";
  RFC-3339 = s: with splitSecondsSinceEpoch { } s; "${F} ${T}{z}";
}
