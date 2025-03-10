extends Control

var http_request : HTTPRequest = HTTPRequest.new()
const SERVER_URL = "http://localhost/databasecontrol.php"
const SERVER_HEADERS = ["Content-Type: application/x-www-form-urlencoded", "Cache-Control: max-age=0"]
const SECRET_KEY = "1234567890"
var nonce = null
var request_queue : Array = []
var is_requesting : bool = false

func _ready():
	randomize()
	# Connect request handler
	add_child(http_request)
	http_request.request_completed.connect(_http_request_completed)

func _process(delta):
	if is_requesting:
		return
	
	if request_queue.is_empty():
		return
	
	is_requesting = true
	
	if nonce == null:
		request_nonce()
	else:
		_send_request(request_queue.pop_front())

func _http_request_completed(_result, _response_code, _headers, _body):
	print("yocompleted")
	is_requesting = false
	if _result != HTTPRequest.RESULT_SUCCESS:
		printerr("Error w/ connection: " + str(_result))
		return
	
	var response_body = _body.get_string_from_utf8()
	print(response_body)
	
	# Parse JSON response
	var response = JSON.parse_string(response_body)
	if response["Error"] != "none":
		printerr("JSON parse error: " + str(response["Error"]))
		return
	
	# Check if nonce is being requested
	if response['command'] == 'get_nonce':
		nonce = response['response']['nonce']
		print("Got nonce: " + response['response']['nonce'])
		return
		
	# If not requesting a nonce, handle other requests
	print("Response Body:\n" + response_body)

func request_nonce():
	print("yononce")
	var client = HTTPClient.new()
	var data = client.query_string_from_dict({"data": JSON.stringify({})})
	var body = "command=get_nonce&" + data
	
	# Make request to the server
	var err = http_request.request(SERVER_URL, SERVER_HEADERS, HTTPClient.METHOD_POST, body)
	
	if err != OK:
		printerr("HTTPRequest error: " + str(err))
	else:
		print("Requesting nonce")

func _send_request(request : Dictionary):
	print("yosend")
	var client = HTTPClient.new()
	var data = client.query_string_from_dict({"data": JSON.stringify(request["data"])})
	
	var body = "command=" + request["command"] + "&" + data
	
	var cnonce = str(Crypto.new().generate_random_bytes(32)).sha256_text()
	# Generate security hash
	var client_hash = (nonce + cnonce + body + SECRET_KEY).sha256_text()
	nonce = null
	
	# Create custom headers for request
	var headers = SERVER_HEADERS.duplicate()
	headers.push_back("cnonce: " + cnonce)
	headers.push_back("hash: " + client_hash)
	
	# Make request to the server with custom headers
	var err = http_request.request(SERVER_URL, headers, HTTPClient.METHOD_POST, body)
	
	if err != OK:
		printerr("HTTPRequest error: " + str(err))
		return
	
	# Debug print
	print("Requesting...\n\tCommand: " + request["command"] + "\n\tBody: " + body)

func _on_add_score_pressed():
	print("yoadd")
	var score = 12
	var username = "test"
	
	var command = "add_score"
	var data = {"username": "scoreman", "score": 1000}
	request_queue.push_back({"command": command, "data": data})

func _on_get_scores_pressed():
	print("yoget")
	var command = "get_scores"
	var data = {"score_offset": 0, "score_number": 10}
	request_queue.push_back({"command": command, "data": data})
