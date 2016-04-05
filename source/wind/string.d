module wind.string;

import core.stdc.wchar_;
import std.string;
import std.conv;
import std.array;
import std.algorithm;
import wind.ut;

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

string hexDump(immutable(void*) buffer, size_t len)
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

unittest
{
    assertEqual(hexDump("\x00\x10\x7f\x80\xcc\xff".ptr, 6), "00 10 7F 80 CC FF ");
}

int getIndention(string str)
{
    int indention = 0;
    while (indention < str.length && str[indention] == ' ')
    {
        indention++;
    }
    return indention;
}

unittest
{
    assert(getIndention("") == 0);
    assert(getIndention("    abcd f") == 4);
    assert(getIndention("abcd    ") == 0);
    assert(getIndention(" ") == 1);
    assert(getIndention("\tabcd") == 0);
}

// unindent according to the first non-empty line
// all empty lines before the first non-empty line will be removed
string unindent(string str)
{
    string ret;
    string[] lines = str.splitLines(KeepTerminator.yes);
    int indention = -1;
    foreach(l; lines)
    {
        if (indention == -1 && l.length > 0 && l[0] != '\r' && l[0] != '\n')
        {
            indention = l.getIndention();
        }

        if (indention != -1)
        {
            ret ~= l[min(indention,l.getIndention())..$];
        }
    }
    return ret;
}

unittest
{
    string src = `
        
        abcd
          efgh
         iikk
        `;
    string dst = `
abcd
  efgh
 iikk
`;
    assertEqual(src.unindent(), dst);
}

