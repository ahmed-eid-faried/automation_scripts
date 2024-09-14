
#!/bin/bash
#bash clean_build_files.sh

# حذف الملفات المترجمة من مشروع C++ أو C#
find . -type d -name "Debug" -exec rm -rf {} +;
find . -type d -name "Release" -exec rm -rf {} +;
find . -type d -name ".vs" -exec rm -rf {} +;
find . -type d -name "x64" -exec rm -rf {} +;
find . -type d -name "x86" -exec rm -rf {} +;
find . -type d -name "bin" -exec rm -rf {} +;
find . -type d -name "obj" -exec rm -rf {} +;

echo "تم حذف الملفات المترجمة بنجاح!"
