# list-vcpkg-ports.ps1

parses `vcpkg`'s `CONTROL` files under `$VCPKG_ROOT\ports\*` directories and displays project name, version, last write time (local) and description in GUI table, that can be filtered, sorted etc.

Uses `$env:VCPKG_ROOT` if set or a hardcoded folder otherwise (change as needed).
