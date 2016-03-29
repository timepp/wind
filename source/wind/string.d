module wind.string;

import std.string;
import std.conv;
import std.c.wcharh;

string splitHead(string str, char sep)
{
    auto pos = str.indexOf(sep);
    return pos == -1 ? str : str[0..pos];
}

string splitTail(string str, char sep, string defaultval)
{
    auto pos = str.indexOf(sep);
    return pos == -1 ? defaultval : str[pos+1..$];
}

unittest
{
    assert(splitHead("var:val:vvv", ':') == "var");
    assert(splitHead("variable", ':') == "variable");
    assert(splitTail("var:val:vvv", ':', "xyz") == "val:vvv");
    assert(splitTail("var", ':', "xyz") == "xyz");
}

string stringFromCStringA(void* buffer)
{
    immutable(char)* icstr = cast(immutable(char)*) buffer;
    return to!string(icstr);
}
string stringFromCStringW(void* buffer)
{
    immutable(wchar)* icstr = cast(immutable(wchar)*) buffer;
    wstring str = icstr[0..wcslen(icstr)];
    return to!string(str);
}

string hexDump(void* buffer, size_t len)
{
    string ret;
    ubyte* p = cast(ubyte*)buffer;
    for (size_t i = 0; i < len; i++)
    {
        uint c = p[i];
        uint x = c / 16;
        ret ~= cast(char)((x >= 10)? x-10+'A' : x+'0');
        uint y = c % 16;
        ret ~= cast(char)((y >= 10)? y-10+'A' : y+'0');
        ret ~= ' ';
    }
    return ret;
}

