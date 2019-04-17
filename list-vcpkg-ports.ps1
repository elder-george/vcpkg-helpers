function from-CONTROL($contents){
    $result = @{}
    $key = $None;
    $val = '';
    $contents | % {
        $matches = [regex]::Matches($_, '^([\w\-]+):\s*(.*)$')
        if ($matches.Success){
            if ($key -ne $None -and -not ($result.Contains($key)) ){
                $result[$key] = $val;
            }
            $key = $matches.Groups[1].Value;
            $val = $matches.Groups[2].Value;
        } else {
            $val = $val + $_;
        }
    }
    if ($key -ne $None -and -not ($result.Contains($key)) ){
        $result[$key] = $val;
    }
    return New-Object psobject -Property $result
}

function Read-CONTROL([System.IO.FileSystemInfo]$path){
    $CONTROL = from-CONTROL(cat $path);
    Add-Member -InputObject $CONTROL -Name LastWriteTime -MemberType NoteProperty -Value $path.LastWriteTime
    return $CONTROL;
}

if ($env:VCPKG_ROOT -ne $Null){
    $VCPKG_ROOT=$env:VCPKG_ROOT
} else {
    $VCPKG_ROOT='c:\bin\tools\vcpkg'
}

$entries = (ls $VCPKG_ROOT\ports\*\CONTROL |% { Read-CONTROL $_})
$entries | select -Property Source,Version,LastWriteTime,Description,Build-Depends | ogv -Wait
