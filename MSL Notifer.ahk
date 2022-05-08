global ENV := "Production" ; Development | Production
global QPUSH_INI := ENV = "Production" ? "qpush.ini" : "qpushForDev.ini"

#Include %A_ScriptDir%
#Include bin\gui\form.ahk
#Include bin\gui\form_qpush.ahk
#Include bin\do\lib\bxt.ahk
#Include bin\do\lib\qpush.ahk
#Include bin\do\settings.ahk
#Include bin\do\clan.ahk



_onClick_test(_ctrlObj, info:="") {
    ; test
}




