extends HTTPRequest

signal lobby_joined(success)
signal lobby_created(success)
signal lobby_left(success)

const URL = "http://127.0.0.1:5000"
const URL_REMOTE = "https://cactus-pydot-server.herokuapp.com/"

var lobby_id := ""
var lobby_idx := -1
var player_name := ""
var in_lobby := false

var last_response := {}
var last_resp_code := -1

func _ready() -> void:
	connect("request_completed", self, "_on_response")

func request(url: String = "/",\
	custom_headers: PoolStringArray = PoolStringArray(),\
	ssl_validate_domain: bool = true,\
	method = 0,\
	request_data: String = ""):
	
	url = url.trim_prefix("/")
	.request(URL + "/" + url, custom_headers, ssl_validate_domain, method, request_data)

func send_get(endpoint : String = "/",\
	custom_headers: PoolStringArray = PoolStringArray(),\
	ssl_validate_domain: bool = true):
		
	endpoint = endpoint.trim_prefix("/")
	.request(URL + "/" + endpoint, custom_headers, ssl_validate_domain, HTTPClient.METHOD_GET)

func _on_response(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	last_resp_code = response_code
	print(last_resp_code)
	last_response = json.result
	
func _notification(what: int) -> void:
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		send_get("leave-lobby/%s/%s" % [player_name, lobby_id])

func in_lobby() -> bool:
	return (lobby_idx >= 0)

func make_lobby(p_name : String):
	send_get("new-lobby/%s" % p_name)
	yield(self, "request_completed")
	
	var ok : bool = last_response["success"]
	
	if ok:
		print(last_response)
		lobby_id = last_response["lobby_id"]
		lobby_idx = last_response["lobby_idx"]
		player_name = p_name
		
	emit_signal("lobby_created", ok)
	return ok
	
func join_lobby(player_name : String, lobby_id : String):
	pass
	
func leave_lobby():
	var ok := false
	if in_lobby():
		send_get("leave-lobby/%s/%s" % [player_name, lobby_id])
		yield(self, "request_completed")
		
		ok = last_response["success"]
		
		print("adios lobby ", ok)
		
	emit_signal("lobby_left", ok)
	return ok
