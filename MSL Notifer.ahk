global ENV := "Production" ; Development | Production
global PUSH_INI := ENV = "Production" ? "push_user_data.ini" : "push_dev_data.ini"

#Include %A_ScriptDir%
#Include bin\gui\form.ahk
#Include bin\gui\form_push.ahk
#Include bin\do\lib\bxt.ahk
#Include bin\do\lib\qpush.ahk
#Include bin\do\lib\pushbullet.ahk
#Include bin\do\settings.ahk
#Include bin\do\clan.ahk


_onClick_test(_ctrlObj, info:="") {
    ; test
}