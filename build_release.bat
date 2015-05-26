@echo off
mxmlc -source-path+=lib\starling\src -library-path+=lib\CGSCommon.swc -frame two, Game -incremental=false -static-link-runtime-shared-libraries=true src\Main.as -output ymtd.swf
