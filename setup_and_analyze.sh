#!/bin/bash
#  TO RUN for current path

# chmod +x setup_and_analyze.sh
# ./setup_and_analyze.sh

#  TO RUN for slected path
# chmod +x setup_and_analyze.sh
# ./setup_and_analyze.sh /Users/ahmedmady/Hard/GitHub/work/bishyaka_consumer_flutter/lib

# تأكد من وجود Homebrew، وقم بتثبيته إذا لم يكن موجودًا
if ! command -v brew &>/dev/null; then
    echo "Homebrew غير مثبت. يتم تثبيته الآن..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# تأكد من وجود أداة tree، وقم بتثبيتها إذا لم تكن موجودة
if ! command -v tree &>/dev/null; then
    echo "tree غير مثبت. يتم تثبيته الآن..."
    brew install tree
fi

# استخدام المسار الحالي كافتراضي إذا لم يتم تقديم مسار
DIR=${1:-$(pwd)}

# استخدام 'tree' لإنشاء هيكلية الدليل
echo "إنشاء هيكلية الدليل..."
tree -ah "$DIR" >structure.txt
