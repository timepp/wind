module wind.ui;

import core.sys.windows.windows;

RECT ScreenToClient(HWND hwnd, RECT rc)
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
