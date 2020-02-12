This is a Haxe version of part 1 of my ["small guide on writing interpreters"](https://yal.cc/interpreters-guide).

The structure is very much alike, with minor changes:

- I make reasonable use of Haxe's ADT enums and abstracts for readability.
- Since Haxe has exception support, this uses `throw` for throwing errors.