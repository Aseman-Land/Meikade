# Import PySide classes
import sys
from PySide.QtCore import *
from PyQt5 import QtCore

app = QCoreApplication(sys.argv)

args = app.arguments()
if len(args) <= 1:
    print("converter.py /path/to/dir")
    exit()

path = args[1]
print(path)

dirs = QDir(path).entryList(["*.sql"])
for d in dirs:
    f = QFile(path + "/" + d)
    f.open(QFile.ReadOnly)
    
    o = QFile(path + "/" + d + ".zip")
    o.open(QFile.WriteOnly)
    o.write( QtCore.qCompress(f.readAll().data()).data() )
    o.close()
    
    f.close()
    
