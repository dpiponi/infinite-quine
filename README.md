# infinite-quine

Infinite quines are much easier to write than finite ones, but as I haven't seen an infinite quine in the wild before, here is one.

You generate it with something like `runghc infinite-quine.hs`

    This infinitely long tweet begins with an upper-case T followed by an H, an I, an S, a space, another I, an N, an F, yet another I, another N, yet another I, a T, an E, an L, a Y, another space, another L, an O, yet another N, a G, yet another space, another T, a W, another E, yet another E, yet another T, yet another space, a B, yet another E, another G, yet another I, yet another N, another S, yet another space, another W, yet another I,...
    
But you can also pipe it into the interpreter with `runghc infinite-quine.hs | runghc interpreter.hs` and you should get the same result

    This infinitely long tweet begins with an upper-case T followed by an H, an I, an S, a space, another I, an N, an F, yet another I, another N, yet another I, a T, an E, an L, a Y, another space, another L, an O, yet another N, a G, yet another space, another T, a W, another E, yet another E, yet another T, yet another space, a B, yet another E, another G, yet another I, yet another N, another S, yet another space, another W, yet another I,...
    
