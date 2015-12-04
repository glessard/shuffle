# shuffle

Shuffle a Collection as lazily as possible, via a `PermutationGenerator`.

The input collection is only indexed; the Fisher-Yates shuffle is implemented step by step, during the `PermutationGenerator`s call to `next()`.
