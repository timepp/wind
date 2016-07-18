# wind
small d wrapper functions, mainly for easier Windows development

# features
## wind.string
- splitHead: split the first part separated by 'sep'
- splitTail: split all but the first part separated by 'sep'
- stringFromCStringA: decode an ANSI string buffer to string
- stringFromCStringW: decode an UNICODE string buffer to string
- hexDump: return the hex representation of a buffer
- unindent: format text by removing leading spaces and indentations

## wind.keyboard
windows key sequence parser

## wind.ui
utilities to handle Windows rect

## binaries/windows_manifest_x86.res
used to build into D application to bring modern Windows application behavior:
1. high DPI awareness
2. new Windows common control looks
3. windows explorer won't treat the app as old-style app to apply compatibility rules on it
