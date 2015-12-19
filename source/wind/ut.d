module wind.ut;

import core.exception;
import std.format;

template assertPred(string op)
{
    void assertPred(L, R)
        (L lhs, R rhs)
        if((op == "<" ||
            op == "<=" ||
            op == "==" ||
            op == "!=" ||
            op == ">=" ||
            op == ">") &&
           __traits(compiles, mixin("lhs " ~ op ~ " rhs")))
        {
            immutable result = mixin("lhs " ~ op ~ " rhs");

            if(!result)
            {
                throw new AssertError(format("assertPred!\"%s\" failed:\nlhs: [%s]\nrhs: [%s]", op, lhs, rhs),
                                      __FILE__,
                                      __LINE__);
            }
        }
}

alias assertPred!"==" assertEqual;
alias assertPred!"!=" assertNotEqual;

