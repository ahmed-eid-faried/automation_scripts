#./clean_build_files.ps1

# حذف الملفات المترجمة من مشروع C++ أو C#
$folders = @("Debug", "Release", ".vs", "x64", "x86", "bin", "obj")

foreach ($folder in $folders) {
    Get-ChildItem -Recurse -Directory -Filter $folder | ForEach-Object { 
        Remove-Item -Recurse -Force $_.FullName
    }
}

Write-Host "تم حذف الملفات المترجمة بنجاح!"
