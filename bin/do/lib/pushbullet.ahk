Pushbullet_send(token:="", msg:="") {
  api := {}
	url := "https://api.pushbullet.com/v2/pushes"
	body := '{"type": "note", "title": "MSL Notifier", "body": "' . msg . '"}'

	WinHTTP := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	WinHTTP.Open("POST", url, true)
  WinHTTP.SetCredentials(token, "", 0)
  WinHTTP.SetRequestHeader("Content-Type", "application/json")
	WinHTTP.Send(body)
	WinHTTP.WaitForResponse()

	Response := WinHTTP.ResponseText

  api.status := WinHTTP.Status
	api.result := api.status = 200 ? "success" : "failure"
  return api
}

Pushbullet_getToken() {
  return IniRead(PUSH_INI, "Pushbullet", "TOKEN")
}