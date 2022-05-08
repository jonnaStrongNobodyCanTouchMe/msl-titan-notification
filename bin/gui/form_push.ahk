#Include %A_ScriptDir%
#NoTrayIcon



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Create GUI
global qpForm := GuiCreate()
qpForm.Opt("-SysMenu" )
qpForm.SetFont(, "consolas")
qpForm.Title := "Push Settings"
; Inputs and buttons
qpForm.Add("Radio", "x10 y25 w70 h20 vRD_ios", "iOS")
ControlSetChecked (IniRead(PUSH_INI, "Device", "OS") ? 0 : 1), qpForm['RD_ios']
qpForm['RD_ios'].OnEvent("Click", "_onClick_disableAndroid")
qpForm.Add("Radio", "x10 y77 w70 h20 vRD_android", "Android")
ControlSetChecked (IniRead(PUSH_INI, "Device", "OS") ? 1 : 0), qpForm['RD_android']
qpForm['RD_android'].OnEvent("Click", "_onClick_disableIOS")
qpForm.Add("GroupBox", "x85 y0 w195 h65", "")
qpForm.Add("Text", "x92 y15 w80 h20", "QPush Name:")
qpForm.Add("Edit", "x173 y13 w100 h20 vEDT_pushname", IniRead(PUSH_INI, "QPush", "PUSH_NAME")).SetFont("s10","consolas")
qpForm.Add("Text", "x92 y40 w80 h20", "QPush Code:")
qpForm.Add("Edit", "x173 y38 w100 h20 vEDT_pushcode", IniRead(PUSH_INI, "QPush", "PUSH_CODE")).SetFont("s10","consolas")
qpForm.Add("GroupBox", "x85 y65 w195 h40", "")
qpForm.Add("Text", "x92 y80 w66 h20", "PB Token:")
qpForm.Add("Edit", "x158 y78 w115 h20 vEDT_pbtoken", IniRead(PUSH_INI, "Pushbullet", "TOKEN")).SetFont("s10","consolas")
qpForm.Add("Button", "x50 y112 w60 h20 vBTN_applyQP", "apply").SetFont("s8") ;x67
qpForm['BTN_applyQP'].OnEvent("Click", "_onClick_applyPushSettings")
qpForm.Add("Button", "x125 y112 w115 h20 vBTN_testQP", "send test message").SetFont("s8")
qpForm['BTN_testQP'].OnEvent("Click", "_onClick_testPushSettings")
; init input disabled
if (qpForm['RD_ios'].Value) {
    qpForm['EDT_pbtoken'].Opt("+Disabled")
} else {
    qpForm['EDT_pushname'].Opt("+Disabled")
    qpForm['EDT_pushcode'].Opt("+Disabled")
}

_onClick_disableAndroid(_ctrlObj, info:="") {
    qpForm['EDT_pbtoken'].Opt("+Disabled")
    qpForm['EDT_pushname'].Opt("-Disabled")
    qpForm['EDT_pushcode'].Opt("-Disabled")
}

_onClick_disableIOS(_ctrlObj, info:="") {
    qpForm['EDT_pbtoken'].Opt("-Disabled")
    qpForm['EDT_pushname'].Opt("+Disabled")
    qpForm['EDT_pushcode'].Opt("+Disabled")
}

_onClick_testPushSettings(_ctrlObj, info:="") {
    pm := "Hi! This is the test message from your sending test."

    if (qpForm['RD_ios'].Value) { ; ios -> qpush
        pn := qpForm['EDT_pushname'].Text
        pc := qpForm['EDT_pushcode'].Text

        resObj := QPush_send(pn, pc, pm)
    } else if (qpForm['RD_android'].Value) { ; android -> pushbullet
        pt := qpForm['EDT_pbtoken'].Text

        resObj := Pushbullet_send(pt, pm)
    } else {
        MsgBox("Select your OS.", "invalid", "IconX")
        return false
    }
    MsgBox(resObj.result = "success" ? "Success! Check the message on your phone." : "Failed. ERROR: " resObj.status, "Result")
    return true
}

_onClick_applyPushSettings(_ctrlObj, info:="") {
    qpForm['EDT_pushname'].Text := Trim(qpForm['EDT_pushname'].Text)
    qpForm['EDT_pushcode'].Text := Trim(qpForm['EDT_pushcode'].Text)
    qpForm['EDT_pbtoken'].Text := Trim(qpForm['EDT_pbtoken'].Text)

    deviceOS := qpForm['RD_ios'].Value ? 0 : 1
    IniWrite deviceOS, PUSH_INI, "Device", "OS"

    IniWrite qpForm['EDT_pushname'].Text, PUSH_INI, "QPush", "PUSH_NAME"
    IniWrite qpForm['EDT_pushcode'].Text, PUSH_INI, "QPush", "PUSH_CODE"
    IniWrite qpForm['EDT_pbtoken'].Text, PUSH_INI, "Pushbullet", "TOKEN"

    if (deviceOS) {
        ; android
        form['CB_push'].Value := _isBlank("android") ? 0 : form['CB_push'].Value
    } else {
        ; ios
        form['CB_push'].Value := _isBlank("ios") ? 0 : form['CB_push'].Value
    }
    IniWrite form['CB_push'].Value, "settings.ini", "Notification", "ENABLE_PUSH"

    qpForm.Hide()
}