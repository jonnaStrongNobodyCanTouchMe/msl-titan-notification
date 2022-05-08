; using unofficial api
QPush_send(qpName:="", qpCode:="", msg:="") {
	api := {}
	url := "https://qpush.me/pusher/push_site/"
  body := "name=" qpName "&code=" qpCode "&sig=" "&cache=false" "&msg[text]=" msg

	WinHTTP := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	WinHTTP.Open("POST", url, true)
	WinHTTP.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=utf-8")
	WinHTTP.Send(body)
	WinHTTP.WaitForResponse()

	Response := WinHTTP.ResponseText

	api.status := WinHTTP.Status
	api.result := api.status = 200 ? "success" : "failure"
  return api
}

QPush_getUserInfo() {
	user := {}
  user.name := IniRead(QPUSH_INI, "Authorization", "PUSH_NAME")
  user.code := IniRead(QPUSH_INI, "Authorization", "PUSH_CODE")
	return user
}