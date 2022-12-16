# Flockenzeit: Nix Time Manipulation

## Using this library

All the user-facing functions are contained in the `lib` output (or in
`default.nix`, if you're not using flakes).

## :warning: A note about timezones

This **does not** handle timezones, because I want to keep my sanity. All the
times are in UTC.

## Functions

### `splitSecondsSinceEpoch`

Splits the number of seconds since UNIX epoch (00:00:00 UTC on 1970-01-01) into
`date`-esque parts. The first argument allows you to specify a locale (which
must contain ordered weekday names, month names, and a function to format the
datetime). The default locale is `C`, provided as `locales.C`, which means you
can just pass an empty attribute set as the first argument and not worry about
it.

Parts which are purely numeric (e.g. `Y` (year), `H` (hour), etc) are kept as
integers, so you'll have to pad them yourself (see [pad](#pad)).  Composite
parts (e.g. `T` (time)) are strings. Parts which are locale-dependent are taken
from the specified locale.

For meaning of all the parts, consult `man date`.

#### Example:

```
nix-repl> with splitSecondsSinceEpoch {} __currentTime; "It's a nice ${A} out today, isn't it? What a lovely ${B} day in ${toString Y}."
"It's a nice Friday out today, isn't it? What a lovely December day in 2022."
```

### `ISO-8601`

Presents time in the ISO-8601 format, like `2009-02-13T23:31:30.000000000Z` .

#### Example:

```
nix-repl> ISO-8601 __currentTime
"2022-12-16T08:32:18.000000000Z"
```

### `pad`

`pad` takes a padding symbol, the desired length, and the string. If the string
is shorter than the desired length, left-pads it with the padding symbol until
it is of the desired length.

`pad0` is simply `pad "0"`.

#### Example:

```
nix-repl> pad " " 2 4
" 4"

nix-repl> pad "0" 4 123
"0123"

nix-repl> pad0 4 123
"0123"
```
