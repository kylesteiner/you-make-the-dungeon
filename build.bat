@echo off
mxmlc -source-path+=lib\starling\src -library-path+=lib\CGSCommon.swc -debug=true -frame two, Game -incremental=true -static-link-runtime-shared-libraries=true src\Main.as -output ymtd.swf
