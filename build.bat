@echo off
mxmlc -source-path+=lib\starling\src -debug=true -incremental=true -static-link-runtime-shared-libraries=true src\Main.as -output ymtd.swf
