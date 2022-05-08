#Include %A_ScriptDir%
#NoTrayIcon

;QPUSH_INI := ENV = "Production" ? "qpush.ini" : "qpushForDev.ini"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Create GUI
global qpForm := GuiCreate()
qpForm.Opt("-SysMenu" )
qpForm.SetFont(, "consolas")
qpForm.Title := "QPush UserInfo"
; Inputs and buttons
qpForm.Add("Text", "x9 y10 w80 h20", "QPush Name:")
qpForm.Add("Edit", "x90 y8 w100 h20 vEDT_pushname", IniRead(QPUSH_INI, "Authorization", "PUSH_NAME")).SetFont("s10","consolas")
qpForm.Add("Text", "x9 y35 w80 h20", "QPush Code:")
qpForm.Add("Edit", "x90 y33 w100 h20 vEDT_pushcode", IniRead(QPUSH_INI, "Authorization", "PUSH_CODE")).SetFont("s10","consolas")
qpForm.Add("Button", "x10 y65 w60 h20 vBTN_applyQP", "apply").SetFont("s8") ;x67
qpForm['BTN_applyQP'].OnEvent("Click", "_onClick_applyQpushSettings")
qpForm.Add("Button", "x75 y65 w115 h20 vBTN_testQP", "send test message").SetFont("s8")
qpForm['BTN_testQP'].OnEvent("Click", "_onClick_testQpushSettings")


_onClick_testQpushSettings(_ctrlObj, info:="") {
    pn := qpForm['EDT_pushname'].Text
    pc := qpForm['EDT_pushcode'].Text
    pm := "Hi! This is the test message from your sending test."

    resObj := QPush_send(pn, pc, pm)
    MsgBox(resObj.result = "success" ? "Success! Check the message on your phone." : "Failed. ERROR: " resObj.status, "Result")
    return
}

_onClick_applyQpushSettings(_ctrlObj, info:="") {
    qpForm['EDT_pushname'].Text := Trim(qpForm['EDT_pushname'].Text)
    qpForm['EDT_pushcode'].Text := Trim(qpForm['EDT_pushcode'].Text)

    IniWrite qpForm['EDT_pushname'].Text, QPUSH_INI, "Authorization", "PUSH_NAME"
    IniWrite qpForm['EDT_pushcode'].Text, QPUSH_INI, "Authorization", "PUSH_CODE"
    qpForm.Hide()
}