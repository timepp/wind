module wind.keyboard;

import core.sys.windows.windows;
import std.array;
import wind.ut;
import std.conv;
import std.algorithm;
import std.string;
import std.stdio;

enum KeyFlags
{
    Modifier = 1,
    BranchModifier = 2,
};

struct VirtualKeyInformation
{
    string name;             // traditional name
    string name2;            // alias name
    string shiftName;        // name when shift is down
    int flags;
};

__gshared VirtualKeyInformation[256] g_vkinfo =
    [
     /* 0x00 */ { ""                    , ""          , ""  },
     /* 0x01 */ { ""                    , ""          , ""  },
     /* 0x02 */ { "RBUTTON"             , ""          , ""  },
     /* 0x03 */ { "CANCEL"              , ""          , ""  },
     /* 0x04 */ { "MBUTTON"             , ""          , ""  },
     /* 0x05 */ { "XBUTTON1"            , ""          , ""  },
     /* 0x06 */ { "XBUTTON2"            , ""          , ""  },
     /* 0x07 */ { ""                    , ""          , ""  },
     /* 0x08 */ { "BACK"                , ""          , ""  },
     /* 0x09 */ { "TAB"                 , ""          , ""  },
     /* 0x0a */ { ""                    , ""          , ""  },
     /* 0x0b */ { ""                    , ""          , ""  },
     /* 0x0c */ { "CLEAR"               , ""          , ""  },
     /* 0x0d */ { "RETURN"              , "ENTER"     , ""  },
     /* 0x0e */ { ""                    , ""          , ""  },
     /* 0x0f */ { ""                    , ""          , ""  },
     /* 0x10 */ { "SHIFT"               , ""          , ""  , KeyFlags.Modifier},
     /* 0x11 */ { "CONTROL"             , ""          , ""  , KeyFlags.Modifier},
     /* 0x12 */ { "MENU"                , "ALT"       , ""  , KeyFlags.Modifier},
     /* 0x13 */ { "PAUSE"               , ""          , ""  },
     /* 0x14 */ { "CAPITAL"             , "CAPSLOCK"  , ""  },
     /* 0x15 */ { "HANGUL"              , ""          , ""  },
     /* 0x16 */ { ""                    , ""          , ""  },
     /* 0x17 */ { "JUNJA"               , ""          , ""  },
     /* 0x18 */ { "FINAL"               , ""          , ""  },
     /* 0x19 */ { "KANJI"               , ""          , ""  },
     /* 0x1a */ { ""                    , ""          , ""  },
     /* 0x1b */ { "ESCAPE"              , "ESC"       , ""  },
     /* 0x1c */ { "CONVERT"             , ""          , ""  },
     /* 0x1d */ { "NONCONVERT"          , ""          , ""  },
     /* 0x1e */ { "ACCEPT"              , ""          , ""  },
     /* 0x1f */ { "MODECHANGE"          , ""          , ""  },
     /* 0x20 */ { "SPACE"               , ""          , ""  },
     /* 0x21 */ { "PRIOR"               , "PAGEUP"    , ""  },
     /* 0x22 */ { "NEXT"                , "PAGEDOWN"  , ""  },
     /* 0x23 */ { "END"                 , ""          , ""  },
     /* 0x24 */ { "HOME"                , ""          , ""  },
     /* 0x25 */ { "LEFT"                , ""          , ""  },
     /* 0x26 */ { "UP"                  , ""          , ""  },
     /* 0x27 */ { "RIGHT"               , ""          , ""  },
     /* 0x28 */ { "DOWN"                , ""          , ""  },
     /* 0x29 */ { "SELECT"              , ""          , ""  },
     /* 0x2a */ { "PRINT"               , ""          , ""  },
     /* 0x2b */ { "EXECUTE"             , ""          , ""  },
     /* 0x2c */ { "SNAPSHOT"            , ""          , ""  },
     /* 0x2d */ { "INSERT"              , ""          , ""  },
     /* 0x2e */ { "DELETE"              , ""          , ""  },
     /* 0x2f */ { "HELP"                , ""          , ""  },
     /* 0x30 */ { "0"                   , ""          , ")" },
     /* 0x31 */ { "1"                   , ""          , "!" },
     /* 0x32 */ { "2"                   , ""          , "@" },
     /* 0x33 */ { "3"                   , ""          , "#" },
     /* 0x34 */ { "4"                   , ""          , "$" },
     /* 0x35 */ { "5"                   , ""          , "%" },
     /* 0x36 */ { "6"                   , ""          , "^" },
     /* 0x37 */ { "7"                   , ""          , "&" },
     /* 0x38 */ { "8"                   , ""          , "*" },
     /* 0x39 */ { "9"                   , ""          , "(" },
     /* 0x3a */ { ""                    , ""          , ""  },
     /* 0x3b */ { ""                    , ""          , ""  },
     /* 0x3c */ { ""                    , ""          , ""  },
     /* 0x3d */ { ""                    , ""          , ""  },
     /* 0x3e */ { ""                    , ""          , ""  },
     /* 0x3f */ { ""                    , ""          , ""  },
     /* 0x40 */ { ""                    , ""          , ""  },
     /* 0x41 */ { "a"                   , ""          , "A" },
     /* 0x42 */ { "b"                   , ""          , "B" },
     /* 0x43 */ { "c"                   , ""          , "C" },
     /* 0x44 */ { "d"                   , ""          , "D" },
     /* 0x45 */ { "e"                   , ""          , "E" },
     /* 0x46 */ { "f"                   , ""          , "F" },
     /* 0x47 */ { "g"                   , ""          , "G" },
     /* 0x48 */ { "h"                   , ""          , "H" },
     /* 0x49 */ { "i"                   , ""          , "I" },
     /* 0x4a */ { "j"                   , ""          , "J" },
     /* 0x4b */ { "k"                   , ""          , "K" },
     /* 0x4c */ { "l"                   , ""          , "L" },
     /* 0x4d */ { "m"                   , ""          , "M" },
     /* 0x4e */ { "n"                   , ""          , "N" },
     /* 0x4f */ { "o"                   , ""          , "O" },
     /* 0x50 */ { "p"                   , ""          , "P" },
     /* 0x51 */ { "q"                   , ""          , "Q" },
     /* 0x52 */ { "r"                   , ""          , "R" },
     /* 0x53 */ { "s"                   , ""          , "S" },
     /* 0x54 */ { "t"                   , ""          , "T" },
     /* 0x55 */ { "u"                   , ""          , "U" },
     /* 0x56 */ { "v"                   , ""          , "V" },
     /* 0x57 */ { "w"                   , ""          , "W" },
     /* 0x58 */ { "x"                   , ""          , "X" },
     /* 0x59 */ { "y"                   , ""          , "Y" },
     /* 0x5a */ { "z"                   , ""          , "Z" },
     /* 0x5b */ { "LWIN"                , ""          , ""  , KeyFlags.Modifier|KeyFlags.BranchModifier},
     /* 0x5c */ { "RWIN"                , ""          , ""  , KeyFlags.Modifier|KeyFlags.BranchModifier},
     /* 0x5d */ { "APPS"                , ""          , ""  },
     /* 0x5e */ { ""                    , ""          , ""  },
     /* 0x5f */ { "SLEEP"               , ""          , ""  },
     /* 0x60 */ { "NUMPAD0"             , ""          , ""  },
     /* 0x61 */ { "NUMPAD1"             , ""          , ""  },
     /* 0x62 */ { "NUMPAD2"             , ""          , ""  },
     /* 0x63 */ { "NUMPAD3"             , ""          , ""  },
     /* 0x64 */ { "NUMPAD4"             , ""          , ""  },
     /* 0x65 */ { "NUMPAD5"             , ""          , ""  },
     /* 0x66 */ { "NUMPAD6"             , ""          , ""  },
     /* 0x67 */ { "NUMPAD7"             , ""          , ""  },
     /* 0x68 */ { "NUMPAD8"             , ""          , ""  },
     /* 0x69 */ { "NUMPAD9"             , ""          , ""  },
     /* 0x6a */ { "NUMPAD_MULTIPLY"     , ""          , ""  },
     /* 0x6b */ { "NUMPAD_ADD"          , ""          , ""  },
     /* 0x6c */ { "NUMPAD_SEPARATOR"    , ""          , ""  },
     /* 0x6d */ { "NUMPAD_SUBTRACT"     , ""          , ""  },
     /* 0x6e */ { "NUMPAD_DECIMAL"      , ""          , ""  },
     /* 0x6f */ { "NUMPAD_DIVIDE"       , ""          , ""  },
     /* 0x70 */ { "F1"                  , ""          , ""  },
     /* 0x71 */ { "F2"                  , ""          , ""  },
     /* 0x72 */ { "F3"                  , ""          , ""  },
     /* 0x73 */ { "F4"                  , ""          , ""  },
     /* 0x74 */ { "F5"                  , ""          , ""  },
     /* 0x75 */ { "F6"                  , ""          , ""  },
     /* 0x76 */ { "F7"                  , ""          , ""  },
     /* 0x77 */ { "F8"                  , ""          , ""  },
     /* 0x78 */ { "F9"                  , ""          , ""  },
     /* 0x79 */ { "F10"                 , ""          , ""  },
     /* 0x7a */ { "F11"                 , ""          , ""  },
     /* 0x7b */ { "F12"                 , ""          , ""  },
     /* 0x7c */ { "F13"                 , ""          , ""  },
     /* 0x7d */ { "F14"                 , ""          , ""  },
     /* 0x7e */ { "F15"                 , ""          , ""  },
     /* 0x7f */ { "F16"                 , ""          , ""  },
     /* 0x80 */ { "F17"                 , ""          , ""  },
     /* 0x81 */ { "F18"                 , ""          , ""  },
     /* 0x82 */ { "F19"                 , ""          , ""  },
     /* 0x83 */ { "F20"                 , ""          , ""  },
     /* 0x84 */ { "F21"                 , ""          , ""  },
     /* 0x85 */ { "F22"                 , ""          , ""  },
     /* 0x86 */ { "F23"                 , ""          , ""  },
     /* 0x87 */ { "F24"                 , ""          , ""  },
     /* 0x88 */ { ""                    , ""          , ""  },
     /* 0x89 */ { ""                    , ""          , ""  },
     /* 0x8a */ { ""                    , ""          , ""  },
     /* 0x8b */ { ""                    , ""          , ""  },
     /* 0x8c */ { ""                    , ""          , ""  },
     /* 0x8d */ { ""                    , ""          , ""  },
     /* 0x8e */ { ""                    , ""          , ""  },
     /* 0x8f */ { ""                    , ""          , ""  },
     /* 0x90 */ { "NUMLOCK"             , ""          , ""  },
     /* 0x91 */ { "SCROLL"              , ""          , ""  },
     /* 0x92 */ { ""                    , ""          , ""  },
     /* 0x93 */ { ""                    , ""          , ""  },
     /* 0x94 */ { ""                    , ""          , ""  },
     /* 0x95 */ { ""                    , ""          , ""  },
     /* 0x96 */ { ""                    , ""          , ""  },
     /* 0x97 */ { ""                    , ""          , ""  },
     /* 0x98 */ { ""                    , ""          , ""  },
     /* 0x99 */ { ""                    , ""          , ""  },
     /* 0x9a */ { ""                    , ""          , ""  },
     /* 0x9b */ { ""                    , ""          , ""  },
     /* 0x9c */ { ""                    , ""          , ""  },
     /* 0x9d */ { ""                    , ""          , ""  },
     /* 0x9e */ { ""                    , ""          , ""  },
     /* 0x9f */ { ""                    , ""          , ""  },
     /* 0xa0 */ { "LSHIFT"              , ""          , ""  , KeyFlags.Modifier|KeyFlags.BranchModifier},
     /* 0xa1 */ { "RSHIFT"              , ""          , ""  , KeyFlags.Modifier|KeyFlags.BranchModifier},
     /* 0xa2 */ { "LCONTROL"            , ""          , ""  , KeyFlags.Modifier|KeyFlags.BranchModifier},
     /* 0xa3 */ { "RCONTROL"            , ""          , ""  , KeyFlags.Modifier|KeyFlags.BranchModifier},
     /* 0xa4 */ { "LMENU"               , ""          , ""  , KeyFlags.Modifier|KeyFlags.BranchModifier},
     /* 0xa5 */ { "RMENU"               , ""          , ""  , KeyFlags.Modifier|KeyFlags.BranchModifier},
     /* 0xa6 */ { "BROWSER_BACK"        , ""          , ""  },
     /* 0xa7 */ { "BROWSER_FORWARD"     , ""          , ""  },
     /* 0xa8 */ { "BROWSER_REFRESH"     , ""          , ""  },
     /* 0xa9 */ { "BROWSER_STOP"        , ""          , ""  },
     /* 0xaa */ { "BROWSER_SEARCH"      , ""          , ""  },
     /* 0xab */ { "BROWSER_FAVORITES"   , ""          , ""  },
     /* 0xac */ { "BROWSER_HOME"        , ""          , ""  },
     /* 0xad */ { "VOLUME_MUTE"         , ""          , ""  },
     /* 0xae */ { "VOLUME_DOWN"         , ""          , ""  },
     /* 0xaf */ { "VOLUME_UP"           , ""          , ""  },
     /* 0xb0 */ { "MEDIA_NEXT_TRACK"    , ""          , ""  },
     /* 0xb1 */ { "MEDIA_PREV_TRACK"    , ""          , ""  },
     /* 0xb2 */ { "MEDIA_STOP"          , ""          , ""  },
     /* 0xb3 */ { "MEDIA_PLAY_PAUSE"    , ""          , ""  },
     /* 0xb4 */ { "LAUNCH_MAIL"         , ""          , ""  },
     /* 0xb5 */ { "LAUNCH_MEDIA_SELECT" , ""          , ""  },
     /* 0xb6 */ { "LAUNCH_APP1"         , ""          , ""  },
     /* 0xb7 */ { "LAUNCH_APP2"         , ""          , ""  },
     /* 0xb8 */ { ""                    , ""          , ""  },
     /* 0xb9 */ { ""                    , ""          , ""  },
     /* 0xba */ { "SEMICOLON"           , ";"         , ":" },
     /* 0xbb */ { "EQUAL"               , "="         , "+" },
     /* 0xbc */ { "COMMA"               , ","         , "<" },
     /* 0xbd */ { "MINUS"               , "-"         , "_" },
     /* 0xbe */ { "PERIOD"              , "."         , ">" },
     /* 0xbf */ { "DIVIDE"              , "/"         , "?" },
     /* 0xc0 */ { "BACKQUOTE"           , "`"         , "~" },
     /* 0xc1 */ { ""                    , ""          , ""  },
     /* 0xc2 */ { ""                    , ""          , ""  },
     /* 0xc3 */ { ""                    , ""          , ""  },
     /* 0xc4 */ { ""                    , ""          , ""  },
     /* 0xc5 */ { ""                    , ""          , ""  },
     /* 0xc6 */ { ""                    , ""          , ""  },
     /* 0xc7 */ { ""                    , ""          , ""  },
     /* 0xc8 */ { ""                    , ""          , ""  },
     /* 0xc9 */ { ""                    , ""          , ""  },
     /* 0xca */ { ""                    , ""          , ""  },
     /* 0xcb */ { ""                    , ""          , ""  },
     /* 0xcc */ { ""                    , ""          , ""  },
     /* 0xcd */ { ""                    , ""          , ""  },
     /* 0xce */ { ""                    , ""          , ""  },
     /* 0xcf */ { ""                    , ""          , ""  },
     /* 0xd0 */ { ""                    , ""          , ""  },
     /* 0xd1 */ { ""                    , ""          , ""  },
     /* 0xd2 */ { ""                    , ""          , ""  },
     /* 0xd3 */ { ""                    , ""          , ""  },
     /* 0xd4 */ { ""                    , ""          , ""  },
     /* 0xd5 */ { ""                    , ""          , ""  },
     /* 0xd6 */ { ""                    , ""          , ""  },
     /* 0xd7 */ { ""                    , ""          , ""  },
     /* 0xd8 */ { ""                    , ""          , ""  },
     /* 0xd9 */ { ""                    , ""          , ""  },
     /* 0xda */ { ""                    , ""          , ""  },
     /* 0xdb */ { "OPEN_BRACKET"        , "["         , "{" },
     /* 0xdc */ { "BACKSLASH"           , "\\"        , "|" },
     /* 0xdd */ { "CLOSE_BRACKET"       , "]"         , "}" },
     /* 0xde */ { "SINGLEQUOTE"         , "'"         , "\""},
     /* 0xdf */ { "OEM_8"               , ""          , ""  },
     /* 0xe0 */ { ""                    , ""          , ""  },
     /* 0xe1 */ { ""                    , ""          , ""  },
     /* 0xe2 */ { "OEM_102"             , "\\"        , "|" },
     /* 0xe3 */ { ""                    , ""          , ""  },
     /* 0xe4 */ { ""                    , ""          , ""  },
     /* 0xe5 */ { "PROCESSKEY"          , ""          , ""  },
     /* 0xe6 */ { ""                    , ""          , ""  },
     /* 0xe7 */ { "PACKET"              , ""          , "" },
     /* 0xe8 */ { ""                    , ""          , ""  },
     /* 0xe9 */ { ""                    , ""          , ""  },
     /* 0xea */ { ""                    , ""          , ""  },
     /* 0xeb */ { ""                    , ""          , ""  },
     /* 0xec */ { ""                    , ""          , ""  },
     /* 0xed */ { ""                    , ""          , ""  },
     /* 0xee */ { ""                    , ""          , ""  },
     /* 0xef */ { ""                    , ""          , ""  },
     /* 0xf0 */ { ""                    , ""          , ""  },
     /* 0xf1 */ { ""                    , ""          , ""  },
     /* 0xf2 */ { ""                    , ""          , ""  },
     /* 0xf3 */ { ""                    , ""          , ""  },
     /* 0xf4 */ { ""                    , ""          , ""  },
     /* 0xf5 */ { ""                    , ""          , ""  },
     /* 0xf6 */ { "ATTN"                , ""          , ""  },
     /* 0xf7 */ { "CRSEL"               , ""          , ""  },
     /* 0xf8 */ { "EXSEL"               , ""          , ""  },
     /* 0xf9 */ { "EREOF"               , ""          , ""  },
     /* 0xfa */ { "PLAY"                , ""          , ""  },
     /* 0xfb */ { "ZOOM"                , ""          , ""  },
     /* 0xfc */ { "NONAME"              , ""          , ""  },
     /* 0xfd */ { "PA1"                 , ""          , ""  },
     /* 0xfe */ { "OEM_CLEAR"           , ""          , ""  },
     /* 0xff */ { ""                    , ""          , ""  },
     ];

// return empty string if there is no such vk
string GetVirtualKeyName(ubyte vk)
{
    return g_vkinfo[vk].name;
}

// return 0 if there is no such vk
// TODO: in future we may create associate arrays to accelerate the lookup from key string to virtual key
ubyte GetVirtualKeyValue(string vkname, out bool shifted)
{
    foreach (i, v; g_vkinfo)
    {
        if (v.name == vkname || v.name2 == vkname)
        {
            shifted = false;
            return cast(ubyte)i;
        }
        if (v.shiftName == vkname)
        {
            shifted = true;
            return cast(ubyte)i;
        }
    }
    return 0;
}

bool isModifier(ubyte vk)
{
    return g_vkinfo[vk].flags & KeyFlags.Modifier;
}

unittest
{
    assertEqual(GetVirtualKeyName(VK_RETURN), "RETURN");
    bool shifted;
    assertEqual(GetVirtualKeyValue("BACK", shifted), VK_BACK);
    assertEqual(shifted, false);

    assertEqual(GetVirtualKeyValue("F", shifted), 'F');
    assertEqual(shifted, true);
}

/**
   A KeyPress contains 0 or more modifiers and one primary key.
   A modifier is one of {ctrl, alt, shift, win}.
   
   Theoretically, normal keys can also be used as modifiers, but it
   will conflict with key sequence in practical. Considering this
   sequence: `D` down, `F` down, `F` up, `D` up. Is this a key
   sequence [D, F], or a `F` with the modifier `D`? Theoretically it's
   the latter, but actually if user press [D, F] quickly he always
   lead to above sequence.

   On the contrast, a key sequence can help to achieve the goal of
   "press D and F at the same time" very well.  So we do not support
   normal keys as the modifier.
*/
struct KeyPress
{
    int key;          // virtual key code of primary key
    int[] modifiers;  // virtual key code of modifiers
};

alias KeySequence = KeyPress[];

/**
   KeySequence:
       KeyPress
       KeyPress , KeySequence

   Note: the comma between KeyPresses can be omitted, in such case the
   parser will use the maximum munch technique. sometimes the comma is
   needed to avoid ambiguous, e.g.: {CONTROL}, {MENU}+f cannot be
   written as {CONTROL}{MENU}+f

   KeyPress:
       PrimaryKey
       Modifiers + PrimaryKey

   PrimaryKey:
       AsciiChar
       {KeyName}
       {KeyValue}

   Modifiers:
       Modifier
       Modifier Modifiers

   Modifier:
       PrimaryKey that can be parsed to CONTROL, ALT, SHIFT or WINDOWS keys.

   AsciiChar:
       any ASCII character except ","(comma), "+"(add), "{", "}", and spaces(space,tab,...).
       if the above special keys are used in KeyPress, use their name instead.
       e.g. {SPACE}, {TAB}, {COMMA} ...

 */
KeySequence ParseKeySequence(string s)
{
    KeyPress kp;
    KeySequence keys;
    string remaining;
    while (ExtractKeyPress(s, remaining, kp))
    {
        s = remaining;
        keys ~= kp;
    }
    return keys;
}
unittest
{
    struct Case
    {
        string s;
        KeySequence expectedKeySequence;
    }

    Case[] cases = [
                    { "f", [{'F'}] },
                    { "9", [{'9'}] },
                    { "F", [{'F', [VK_SHIFT]}] },
                    { "ff", [{'F'}, {'F'}] },
                    { "abD!2$", [{'A'}, {'B'}, {'D', [VK_SHIFT]}, {'1', [VK_SHIFT]}, {'2'}, {'4', [VK_SHIFT]}] },
                    { "w0", [{'W'}, {'0'}] },
                    { "o,o", [{'O'}, {'O'}] },
                    { "{CONTROL}f", [{'F', [VK_CONTROL]}] },
                    { "{CONTROL}+f", [{'F', [VK_CONTROL]}] },
                    { "{CONTROL} + f", [{'F', [VK_CONTROL]}] },
                    { "{CONTROL}{ALT}{SHIFT}f", [{'F', [VK_CONTROL, VK_MENU, VK_SHIFT]}] },
                    { "{CONTROL}{ALT}{SHIFT}F", [{'F', [VK_CONTROL, VK_MENU, VK_SHIFT]}] },
                    { "{CONTROL}{ALT}F", [{'F', [VK_CONTROL, VK_MENU, VK_SHIFT]}] },
                    { "{CONTROL}{ALT}", [{VK_MENU, [VK_CONTROL]}] },
                    { "{CONTROL},{ALT}", [{VK_CONTROL}, {VK_MENU}] },
                    { "{LCONTROL},{ALT}", [{VK_LCONTROL}, {VK_MENU}] },
                    { "f {CONTROL}", [{'F'}, {VK_CONTROL}] },
                    { "{CONTROL}{ALT}{CONTROL}{ALT}f", [{'F', [VK_CONTROL, VK_MENU]}] },
                    { "{ALT}{ALT}", [{VK_MENU}] },
                    ];

    write("ParseKeySequence");
    foreach(i, c; cases)
    {
        write("  case:", i+1);
        stdout.flush();

        KeySequence seq = ParseKeySequence(c.s);
        assertEqual(seq, c.expectedKeySequence);
    }
    writeln();
   
}

bool ExtractKeyPress(string s, out string remaining, out KeyPress kp)
{
    KeyPress k;
    string r;
    string component;
    bool ret;
    int componentIndex = 0;

    while (ExtractComponent(s, r, component))
    {
        s = r;
        componentIndex++;
        
        if (component == ",")
        {
            if (componentIndex == 1) continue; else break;
        }

        if (component == "+")
        {
            continue;
        }

        bool shifted;
        ubyte vk = GetVirtualKeyValue(component, shifted);
        if (vk == 0)
        {
            vk = to!ubyte(component);
            if (vk == 0)
            {
                return false;
            }
        }

        if (isModifier(vk))
        {
            if (k.modifiers.find(vk) == [])
            {
                k.modifiers ~= vk;
            }
        }
        else
        {
            k.key = vk;
            if (shifted)
            {
                if (k.modifiers.find(VK_SHIFT) == [])
                {
                    k.modifiers ~= VK_SHIFT;
                }
            }
            break;
        }
    }

    if (k.key == 0)
    {
        if (k.modifiers.length > 0)
        {
            k.key = k.modifiers[$-1];
            k.modifiers.length--;
        }
    }

    if (k.key != 0)
    {
        kp = k;
        remaining = r;
        return true;
    }
    else
    {
        return false;
    }
}

bool ExtractComponent(string s, out string remaining, out string component)
{
    // omit spaces
    s = s.strip();

    if (s.length == 0) return false;

    if (s[0] == '{')
    {
        auto p = s.indexOf('}');
        if (p == -1) return false;
        component = s[1..p];
        remaining = s[p+1..$];
        return true;
    }

    component = s[0..1];
    remaining = s[1..$];
    return true;
}
unittest
{
    struct Case
    {
        string str;
        string remaining;
        string component;
        bool ret;
    }

    Case[] cases = [
                    { "f", "", "f", true },
                    { "+", "", "+", true },
                    { ",", "", ",", true },
                    { "", "", "", false },
                    { "    ", "", "", false },
                    { "  \t   f   ", "", "f", true },
                    { "{CONTROL}", "", "CONTROL", true },
                    { "{20}", "", "20", true },
                    { "{CONTRO", "", "", false },
                    ];

    write("ExtractComponent");
    foreach(i, c; cases)
    {
        write("  case:", i+1);
        stdout.flush();
        string r, comp;
        assertEqual(ExtractComponent(c.str, r, comp), c.ret);
        if (c.ret)
        {
            assertEqual(r, c.remaining);
            assertEqual(comp, c.component);
        }
    }
    writeln();
}

