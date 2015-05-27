@echo off
mxmlc -source-path+=lib\starling\src -library-path+=lib\CGSCommon.swc -debug=true -frame two, Main -incremental=true -static-link-runtime-shared-libraries=true src\Preloader.as -output ymtd.swf
