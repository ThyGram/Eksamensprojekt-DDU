extends Control

var http_request : HTTPRequest = HTTPRequest.new()
const SERVER_URL = "http://localhost/databasecontrol.php"
const SERVER_HEADERS = ["Content-Type: applications/x-www-form-urlencoded", "Cache-Control: max-age=0" ]
const SECRET_KEY = "1234567890"
var nonce = null
var request_queue : Array = []
var is_requesting : bool = false

func _ready():
	randomize()
	
	# Connect request handler
	add_child(http_request);
	http_request.connect("request_completed", _http_request_completed);

func _process(delta):
	if is_requesting:
		return
	
	if request_queue.is_empty():
		return
		
	is_requesting = true
	if (nonce == null):
		request_nonce()
	else:
		_send_request(request_queue.pop_front())

func _http_request_completed(_result, _response_code, _headers, _body):
	print("yocompleted")
	is_requesting = true
	if (_result != HTTPRequest.RESULT_SUCCESS):
		printerr("Error w/ connection: " + String(_result))
		return
	
	var response_body = _body.get_string_from_utf8()
	
	# Grab JSON and handle errors in PHP code
	var response = JSON.parse_string(response_body)
	if response['error'] != "none":
		nonce = response['result']['nonce']
		print("Got nonce: " + response['response']['nonce'])
		return
	
	# If not requesting nonce handle other requests
	print("Response Body:\n" + response_body)
	
func request_nonce():
	print("yononce")
	var client = HTTPClient.new()
	var data = client.query_string_from_dict({"data" : JSON.stringify({})})
	var body = "command=get_nonce&" + data
	
	# Make request to the server
	var err = http_request.request(SERVER_URL, SERVER_HEADERS, HTTPClient.METHOD_POST, body)
	
	# Check for problems
	if err != OK:
		printerr("HTTPRequest error: " + String(err))
		return
	
	print("Requesting nonce")
	
func _send_request(request : Dictionary):
	print("yosend")
	var client = HTTPClient.new()
	var data = client.query_string_from_dict({"data" : JSON.stringify(request["data"])})
	var body = "command=" + request['command'] + "&" + data
	
	# Generate Response nonce
	var cnonce = Crypto.new().sha256(Crypto.new().generate_random_bytes(32)).hex_encode()
	
	# Generate security hash
	var client_hash = (nonce + cnonce+ body + SECRET_KEY).sha256_text()
	nonce = null
	
	# Create custom headers for request
	var headers = SERVER_HEADERS.duplicate()
	headers.push_back("cnonce: " + cnonce)
	headers.push_back("hash: " + client_hash)
	
	# Make request to the server
	var err = http_request.request(SERVER_URL, SERVER_HEADERS, HTTPClient.METHOD_POST, body)
	
	if err != OK:
		printerr("HTTPRequest error: " + String(err))
		return
	
	# Print debuggning
	print("Requesting...\n\tCommand: " + request['command'] + "\n\tBody: " + body)


func _on_add_score_pressed():
	print("yoadd")
	var score = 0
	var username = "test"
	
	var command = "add_score"
	var data = {"score" : score, "username" : username}
	request_queue.push_back({"command" : command, "data" : data})


func _on_get_scores_pressed():
	print("yoget")
	var command = "get_scores"
	var data = {"score_offset" : 0, "score_number" : 10}
	request_queue.push_back({"command" : command, "data" : data})
