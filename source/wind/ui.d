module wind.ui;

import core.sys.windows.windows;
import std.conv;
import std.algorithm;
import core.stdc.wchar_;

enum RR // rect relationship
{
    Above = 0x1,
    Below = 0x2,
    Left = 0x4,
    Right = 0x8,
    Same = 0x10,
    Offset = 0x20,
    Intersect = 0x40,
    Align = 0x80,
    Inner = 0x100,
    Outer = 0x200
};

int rectRelationShip(RECT r, RECT b)
{
    int ret;
    if (r == b) return RR.Same;

    RECT i = intersect(r, b);

    if (r.top < b.top && r.bottom <= b.top) ret |= RR.Above;
    if (r.bottom > b.bottom && r.top >= b.bottom) ret |= RR.Below;
    if (r.left < b.left && r.right <= b.left) ret |= RR.Left;
    if (r.right > b.right && r.left >= b.right) ret |= RR.Right;
    if (r.width == b.width && r.height == b.height) ret |= RR.Offset;
    if (r.top == b.top && r.bottom == b.bottom || r.left == b.left && r.right == b.right) ret |= RR.Align;

    // TODO: intersect, inner and outer

    return ret;
}

RECT toClientCoordinate(HWND hwnd, RECT rc)
{
    POINT pt1 = {rc.left, rc.top};
    POINT pt2 = {rc.right, rc.bottom};
    core.sys.windows.windows.ScreenToClient(hwnd, &pt1);
    core.sys.windows.windows.ScreenToClient(hwnd, &pt2);
    return RECT(pt1.x, pt1.y, pt2.x, pt2.y);
}

LONG width(RECT rc)
{
    return rc.right - rc.left;
}

LONG height(RECT rc)
{
    return rc.bottom - rc.top;
}

HWND[] directChilds(HWND hwnd)
{
    HWND[] childs;
    HWND child;
    while ((child = FindWindowExW(hwnd, child, null, null)) != NULL)
    {
        childs ~= child;
    }
    return childs;
}

string getClassName(HWND hwnd)
{
    WCHAR[100] clsname;
    GetClassNameW(hwnd, clsname.ptr, clsname.length);
    return to!string(clsname[0..wcslen(clsname.ptr)]);
}

@property RECT rect(HWND hwnd)
{
    RECT rc;
    GetWindowRect(hwnd, &rc);
    return rc;
}

@property string title(HWND hwnd)
{
    WCHAR[512] buf;
    GetWindowTextW(hwnd, buf.ptr, buf.length);
    return to!string(buf[0..wcslen(buf.ptr)]);
}

// If the 2 input rects are not intersected, the result will be a irregular rect.
// i.e. result.left > result.right, or result.top > result.bottom
RECT intersect(RECT r1, RECT r2)
{
    RECT r;
    r.left = max(r1.left, r2.left);
    r.top = max(r1.top, r2.top);
    r.right = min(r1.right, r2.right);
    r.bottom = min(r1.bottom, r2.bottom);
    return r;
}
