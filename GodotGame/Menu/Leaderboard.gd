extends Control

var http_request : HTTPRequest = HTTPRequest.new()

const SERVER_URL : String = "http://localhost:8080/GodotSecure/db_action_secure.php"
const SERVER_HEADERS : Array = ["Content-Type: application/x-www-form-urlencoded", "Cache-Control: max-age=0"]

const SECRET_KEY : int = 1234567890
var nonce = null

var request_queue : Array = []
var is_requesting : bool = false


func _ready():
	randomize()
	add_child(http_request)
	http_request.connect("request_completed", Callable(self, "_http_request_completed"))
	get_scores()

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

func _send_request(request : Dictionary):
	var client = HTTPClient.new()
	var data = client.query_string_from_dict({"data": JSON.stringify(request['data'])})
	var cnonce = str(Crypto.new().generate_random_bytes(32)).sha256_text()
	var body = "command=" + request['command'] + "&" + data + "&cnonce=" + cnonce
	# Generate security hash
	var client_hash = (nonce + cnonce + body + str(SECRET_KEY)).sha256_text()
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
	else:
		pass
	# Debug print
	print("Requesting...\n\tCommand: " + request["command"] + "\n\tBody: " + body)


func _http_request_completed(_result, _response_code, _headers, _body):
	is_requesting = false
	if _result != HTTPRequest.RESULT_SUCCESS:
		printerr("Error w/ connection: " + str(_result))
		return
	
	var response_body = _body.get_string_from_utf8()
	# Parse JSON response
	var json_conv = JSON.new()
	json_conv.parse(response_body)
	var response = json_conv.get_data()
	
	print("Raw response: " + response_body)
	
	if response['error'] != "none":
		printerr("JSON parse error: " + str(response['error']))
		return
	
	# Check if nonce is being requested
	if response['command'] == "get_nonce":
		nonce = response['response']['nonce']
		print("Got nonce: " + response['response']['nonce'])
		return
	
	if response['response']['size'] > 0:
		$Panel/Position/PositionList.text = ""
		$Panel/Player/PlayerList.text = ""
		$Panel/Cash/CashList.text = ""
		for n in (response['response']['size']):
			$Panel/Position/PositionList.text = $Panel/Position/PositionList.text + str(n + 1) + "\n"
			$Panel/Player/PlayerList.text = $Panel/Player/PlayerList.text + str(response['response'][str(n)]['displayname'] + "\n")
			$Panel/Cash/CashList.text = $Panel/Cash/CashList.text + str(response['response'][str(n)]['highscore'] + "$\n")
	else:
		print("No Data")
	# If not requesting a nonce, handle other requests
	print("Response Body:\n" + response_body)

func request_nonce():
	var client = HTTPClient.new()
	var data = client.query_string_from_dict({"data": JSON.stringify({})})
	var body = "command=get_nonce&" + data
	
	# Make request to the server
	var err = http_request.request(SERVER_URL, SERVER_HEADERS, HTTPClient.METHOD_POST, body)
	
	if err != OK:
		printerr("HTTPRequest error: " + str(err))
	else:
		print("Requesting nonce")

func get_scores():
	var command = "get_scores"
	var data = {"score_offset": 0, "score_number": 10}
	request_queue.push_back({"command": command, "data": data})
	print("get scores")

func _on_return_button_pressed():
	get_tree().change_scene_to_file("res://Menu/main_menu.tscn")
