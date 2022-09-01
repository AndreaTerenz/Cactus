extends HTTPRequest

signal lobby_joined(success)
signal lobby_created(success)
signal lobby_left(success)

const URL = "http://127.0.0.1:5000"
const URL_REMOTE = "https://cactus-pydot-server.herokuapp.com/"

const MAKE_LOBBY_URL = URL + "/new-lobby/%s"
const JOIN_LOBBY_URL = URL + "/join-lobby/%s/%s"
const LEAVE_LOBBY_URL = URL + "/leave-lobby/%s/%s"

var lobby_id := ""
var lobby_idx := -1
var player_name := ""
var in_lobby := false

var last_response := {}
var last_resp_code := -1

func _ready() -> void:
	connect("request_completed", self, "_on_response")
	
func send_request(url):
	while request(url) != OK:
		pass

func _on_response(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	last_resp_code = response_code
	print(last_resp_code)
	
	if json.result:
		last_response = json.result
	
func _notification(what: int) -> void:
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		request(LEAVE_LOBBY_URL % [player_name, lobby_id])

func in_lobby() -> bool:
	return (lobby_idx >= 0)

func make_lobby(p_name : String):
	var ok := false
	
	if not in_lobby():
		request(MAKE_LOBBY_URL % p_name)
		yield(self, "request_completed")
		
		ok = last_response["success"]
		
		if ok:
			lobby_id = last_response["lobby_id"]
			lobby_idx = last_response["lobby_idx"]
			player_name = p_name
		
	emit_signal("lobby_created", ok)
	return ok
	
func join_lobby(p_name : String, lobby_id : String):
	var ok := false
	
	if not in_lobby():
		request(JOIN_LOBBY_URL % [p_name, lobby_id])
		yield(self, "request_completed")
		
		ok = last_response["success"]
		
		if ok:
			lobby_id = last_response["lobby_id"]
			print(last_response["lobby_id"])
			print(lobby_id)
			lobby_idx = last_response["lobby_idx"]
			player_name = p_name
		
	emit_signal("lobby_joined", ok)
	return ok
	
func leave_lobby():
	var ok := false
	if in_lobby():
		request(LEAVE_LOBBY_URL % [player_name, lobby_id])
		yield(self, "request_completed")
		
		ok = last_response["success"]
		
		print("adios lobby ", ok)
		
	emit_signal("lobby_left", ok)
	return ok
