extends HTTPRequest

const URL = "http://127.0.0.1:5000"
const URL_REMOTE = "https://cactus-pydot-server.herokuapp.com/"

func request(url: String = "/",\
	custom_headers: PoolStringArray = PoolStringArray(),\
	ssl_validate_domain: bool = true,\
	method = 0,\
	request_data: String = ""):
	
	url = url.trim_prefix("/")
	.request(URL + "/" + url, custom_headers, ssl_validate_domain, method, request_data)

func get(endpoint : String = "/",\
	custom_headers: PoolStringArray = PoolStringArray(),\
	ssl_validate_domain: bool = true):
		
	endpoint = endpoint.trim_prefix("/")
	.request(URL + "/" + endpoint, custom_headers, ssl_validate_domain, HTTPClient.METHOD_GET)
