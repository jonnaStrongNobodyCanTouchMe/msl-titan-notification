#Include lib\bxt.ahk

_onClick_pause(ctrl, info:="") {
    if (!A_IsPaused) {
        ctrl.Gui['EDT_status'].Text := "paused-->" . ctrl.Gui['EDT_status'].Text
        ctrl.Gui['BTN_pause'].Text := ">>"
    } else {
        ctrl.Gui['EDT_status'].Text := StrSplit(ctrl.Gui['EDT_status'].Text, "paused-->")[2]
        ctrl.Gui['BTN_pause'].Text := "PAUSE"
    }
    Pause , 1
}

_onClick_reload(ctrl, info:="") {
    Reload
}

_onChange_selectTitle(ctrl, info:="") {
    selectedTitle := ctrl.Text
    className := WinGetClass(selectedTitle)
    txtNoxCheck := ctrl.Gui['TXT_noxcheck']

    ctrl.Gui['DDL_titles'].Opt("+Disabled")
    txtNoxCheck.SetFont("cBlack")
    if ((className = NOX_CLASS_NAME)) {
        _typeTextEffect(txtNoxCheck, "... ok!", 30)
        txtNoxCheck.SetFont("cGreen")
        ctrl.Gui['BTN_clanSet'].Opt("-Disabled")
    } else {
        _typeTextEffect(txtNoxCheck, "... invalid.", 30)
        txtNoxCheck.SetFont("cRed")
        ctrl.Gui['BTN_clanSet'].Opt("+Disabled")
    }
    ctrl.Gui['DDL_titles'].Opt("-Disabled")
}

_onFocus_refreshTitle(ctrl, info:="") {
    prevTitle := ctrl.Text
    WIN_TITLE_ARR := _getWindowTitles()
    ctrl.Gui['DDL_titles'].Delete()

    ctrl.Gui['DDL_titles'].Add(WIN_TITLE_ARR)
    for tit in WIN_TITLE_ARR {
        if (tit = prevTitle) {
            ctrl.Gui['DDL_titles'].Choose(prevTitle)
        }
    }
}

_onClick_openQpushSettings(_ctrlObj, info:="") {
    qpForm.Show("x521 y355 h140 w286")
}

_onClick_togglePlaySound(_ctrlObj, info:="") {
    IniWrite _ctrlObj.Value, "settings.ini", "Notification", "ENABLE_SOUND"
}

_onClick_togglePush(_ctrlObj, info:="") {
    if (IniRead(PUSH_INI, "Device", "OS")) {
        ; android
        if (_isBlank("android")) {
            MsgBox("Go Push Settings then enter the inputs first.", "Error", "IconX")
            _ctrlObj.Value := 0
        }
    } else {
        ; ios
        if (_isBlank("ios")) {
            MsgBox("Go Push Settings then enter the inputs first.", "Error", "IconX")
            _ctrlObj.Value := 0
        }
    }
    
    IniWrite _ctrlObj.Value, "settings.ini", "Notification", "ENABLE_PUSH"
}

_typeTextEffect(guiObj, str, term:=50) {
    guiObj.Text := ""
    res := ""

    lastIndex := StrLen(str)
    Loop parse, str, "" {
        res .= A_LoopField

        if (A_index != lastIndex) {
            guiObj.Text := res . "_"
            Sleep(term)
        } else {
            guiObj.Text := res
        }
    }
}

_isBlank(os) {
    if (os = "android") {
        token := Pushbullet_getToken()
        return token = "" ? true : false
    } else if (os = "ios") {
        user := QPush_getUserInfo()
        return (user.name = "" || user.code = "") ? true : false
    }
}