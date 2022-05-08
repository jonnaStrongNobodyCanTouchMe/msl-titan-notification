#Include lib\bxt.ahk

global AlarmCls := ""

class Alarm {
    __New() {
        this.firstTime := A_Year . A_MM . A_DD . form['EDT_time'].Text
        this.compTimeFn := ObjBindMethod(this, "Check")
    }
    Start() {
        SetTimer this.compTimeFn, 1000
    }
    Stop() {
        SetTimer this.compTimeFn, 0
    }
    Check() {
        currentTime := A_Year . A_MM . A_DD . A_Hour . A_Min
        if (DateDiff(this.firstTime, currentTime, "minutes") <= 0) {
            form['CB_popmsgbox'].Value := 0
            SoundPlay "bin\snd\t2.mp3"
            SetTimer this.compTimeFn, 0
            MsgBox("
                (
                    It's almost time!
                    This MsgBox closes in 5 seconds.
                )", "Alarm", "T5"
            )
        }
    }
}

;###################################################################################
; OnEvent OnEvent OnEvent OnEvent OnEvent OnEvent OnEvent OnEvent OnEvent OnEvent 
;###################################################################################

; TAB[Clan] > CB[msgpop]
_onClick_checkboxPop(_ctrlObj, info:="") {
    if (!_ctrlObj.Value) {
        ; clear alarm
        AlarmCls.Stop
        AlarmCls := ""
        return
    }

    form['EDT_time'].Text := Trim(form['EDT_time'].Text)
    ; remove not number characters 
    form['EDT_time'].Text := RegExReplace(form['EDT_time'].Text, "[^0-9]")
    if (form['EDT_time'].Text = "" || StrLen(form['EDT_time'].Text) != 4) {
        MsgBox("Enter a time like 1630 (means 16:30)", "invalid", "Iconx")
        form['CB_popmsgbox'].Value := 0 ; uncheck
        form['EDT_time'].Focus()
        return
    }

    dispTime := FormatTime(A_Year . A_MM . A_DD . form['EDT_time'].Text, "h : mm tt")

    msgAns := MsgBox("This will notify you at " dispTime " (KST)`nWould you like to continue?", "", "YN")
    if (msgAns = "Yes") {
        AlarmCls := Alarm.new()
        AlarmCls.Start
    } else {
        _ctrlObj.Value := 0
    }
}

; TAB[Clan] > BTN[Set]
_onClick_startClanAlarm(_ctrlObj, info:="") {
    result := Clan_main(_ctrlObj)
    if (!result) {
        Bxt_updateStatus(_ctrlObj, "ERROR")
        return false
    } else if (result < 0) {
        msg := "ERROR: titan element not found. You need to update images."
        Clan_sendMessage(_ctrlObj, msg)
        Bxt_updateStatus(_ctrlObj, msg)
        return false
    }
    return true
}

; TAB[Clan] > DDL[titan]
_onChange_selectTitan(ctrl, info:="") {
    rgbVar := ""

    Switch ctrl.Text {
        case "Dark": rgbVar := "431771"
        case "Water": rgbVar := "0000FF"
        case "Wood": rgbVar := "008000"
        case "Light": rgbVar := "bf8d27"
        case "Fire": rgbVar := "CC0000"
        default: rgbVar := "000000"
    }
    ctrl.Gui['TXT_titan'].SetFont("c" . rgbVar)
}

;#######################################################################################
; Functions
;#######################################################################################


Clan_getTitanElement(_ctrlObj) {
    elementsArr := ["Dark", "Water", "Wood", "Light", "Fire"]

    Loop 3 {
        For element in elementsArr {
            if (Bxt_hasImg(_ctrlObj, "clan-titanType" . element,, false, false)) {
                return element
            }
        }
    }
    return ""
}

Clan_playSound(_ctrlObj) {
    if (_ctrlObj.Gui['CB_playsound'].Value) {
        SoundPlay "bin\snd\t1.mp3"
    }
    return
}

Clan_sendMessage(_ctrlObj, msg:="") {
    if (!_ctrlObj.Gui['CB_push'].Value) {
        return
    }
    currentOS := IniRead(PUSH_INI, "Device", "OS") ? "android" : "ios"

    if (currentOS = "android") {
        req := Pushbullet_send(Pushbullet_getToken(), msg)

        Bxt_updateStatus(_ctrlObj, "result: " req.result " , status: " req.status)
        return
    } else if (currentOS = "ios") {
        qpUser := QPush_getUserInfo()
        req := QPush_send(qpUser.name, qpUser.code, msg)

        Bxt_updateStatus(_ctrlObj, "result: " req.result " , status: " req.status)
        return
    }
}

Clan_main(_ctrlObj) {
    msgStr := ""

    ; validation - check ddl is blank
    if (_ctrlObj.Gui['DDL_titanElement'].Text = "") {
        MsgBox("Choose the titan's element.", "invalid", "IconX")
        return false
    }
    ; validation - check screen
    isTitanLobby := Bxt_hasImg(_ctrlObj, "clan-titanLobby")
    if (!isTitanLobby) {
        MsgBox("You should set on Clan Lobby", "invalid", "IconX")
        return false
    }
    
    Loop {
        Bxt_updateStatus(_ctrlObj, "Searching Current Element..")
        currentTitanElement := Clan_getTitanElement(_ctrlObj)
        Bxt_updateStatus(_ctrlObj, "Current Titan: " . currentTitanElement)

        if (currentTitanElement = _ctrlObj.Gui['DDL_titanElement'].Text) {
            ; play sound 
            Clan_playSound(_ctrlObj)

            ; send message
            msgStr := "Enter the titan battles now!"
            Clan_sendMessage(_ctrlObj, msgStr)

            ; pop msgbox
            MsgBox(msgStr, "notification")
            return true
        } else {
            Bxt_updateStatus(_ctrlObj, "Current Titan: " currentTitanElement " (search again every 30secs)")
        }
        if (currentTitanElement = "") {
            return -1 ;-1
        }
        Sleep(30000)
    }
}

