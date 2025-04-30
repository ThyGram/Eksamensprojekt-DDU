<?php
		include 'db_connection_secure.php';
		
		if(isset($_SERVER['HTTP_ORIGIN'])){
			header("Access-Control-Allow-Origin: *");
			header("Access-Control-Max-Age: 60");
		}
		
		if($_SERVER['REQUEST_METHOD'] === "OPTIONS"){
			header("Access-Control-Allow-Methods: POST, OPTIONS");
			header("Access-Control-Allow-Headers: Authorization, Content-Type, Accept, Origin, cache-control");
			http_response_code(200);
			die;
		}
		
		if ($_SERVER['REQUEST_METHOD'] !== "POST"){
			http_response_code(405);
			die;
		}
		
		
		#Returns information and data to Godot
		function print_response($status, $dictionary = [], $error = "none"){
			$string = "{\"error\" : \"$error\",
						\"command\" : \"$_REQUEST[command]\",
						\"response\" : ". json_encode($dictionary) ."}";
						
			#Print out json to Godot
			echo $string;
		}
		
		function verify_nonce($pdo, $secret = "1234567890"){
			
			//Check if cnonce has been sent in header
			if(!isset($_SERVER['HTTP_CNONCE'])){
				print_response("no_return", [], "invalide_nonce");
				return false;
			}
			
			//Get users nonce from database found by IP adress
			$template = "SELECT nonce FROM `nonces` WHERE ip_address = :ip";
			$sth = $pdo -> prepare($template);
			$sth -> execute(["ip" => $_SERVER['REMOTE_ADDR']]);
			$data = $sth -> fetchAll(PDO::FETCH_ASSOC);
			
			//Check if data is not empty
			if(!isset($data) or sizeof($data) <= 0){
				print_response("no_return", [], "server_missing_nonce");
				return false;
			}
			
			//Get server nonce from user
			$server_nonce = $data[0]['nonce'];
			
			//Compair hash from user with servers hash
			if (hash('sha256', $server_nonce . $_SERVER['HTTP_CNONCE'] . file_get_contents("php://input") . $secret) != $_SERVER["HTTP_HASH"]){
					print_response("no_return", [], "invalid_nonce_or_hash");
					return false;
			}
			
			//If all is good, return true
			return true;			
		}
		
		
		#Handle error: 
		#Missing command
		if (!isset($_REQUEST['command']) or $_REQUEST['command'] === null){
			print_response("no_return", [], "missing_command");
			die;
		}
		
		#Missing data
		if (!isset($_REQUEST['data']) or $_REQUEST['data'] === null){
			print_response("no_return", [], "missing_data");
			die;
		}
				
		
		#Convert Godot json to dictionary
		$dict_from_json = json_decode($_REQUEST['data'], true);
		
		#Is dictionary valid
		if ($dict_from_json === null){
			print_response("no_return", [], "invalid_json");
			die;
		}
		
		//Get the users command and performe it
		switch ($_REQUEST['command']){
			
			//
			case "get_nonce":
			
			$bytes = random_bytes(32);
			//Create new server nonce 
			$nonce = hash('sha256', $bytes);
			
			//Insert new server nonce into database together with users IP address
			$template = "INSERT INTO `nonces` (ip_address, nonce) VALUES (:ip, :nonce) ON DUPLICATE KEY
			UPDATE nonce = :nonce_update";
			
			$pdo = OpenConnPDO();
			
			$sth = $pdo -> prepare($template);
			$sth -> execute(["ip" => $_SERVER['REMOTE_ADDR'], "nonce" => $nonce, "nonce_update" => $nonce]);
			
			CloseConnPDO($pdo);
			
			//Return new nonce to user
			print_response("nonce_return", ["nonce" => $nonce]);			
			die;
			
			break;
			
			#Adding score
			case "add_player":
				#Handle error for add score
                if (!isset($dict_from_json['username'])){
					print_response("no_return", [], "missing_username");
					die;
				}
								
				if (!isset($dict_from_json['passkey'])){
					print_response("no_return", [], "missing_passkey");
					die;
				}
				if (!isset($dict_from_json['displayname'])){
					print_response("no_return", [], "missing_displayname");
					die;
				}
								
				if (!isset($dict_from_json['highscore'])){
					print_response("no_return", [], "missing_highscore");
					die;
				}

				# Username max length 40, -> should be handled in Godot
				$username = $dict_from_json['username'];
                $passkey = $dict_from_json['passkey'];
                $displayname = $dict_from_json['displayname'];
				$highscore = $dict_from_json['highscore'];
               
				
				$template = "INSERT INTO `players` (username, passkey, displayname, highscore) VALUES (:username, :passkey, :displayname, :highscore) ON DUPLICATE
				KEY UPDATE highscore = GREATEST(highscore, VALUES(highscore))";
				
				$pdo = OpenConnPDO();

				//Check for correct nonce (hashing), continue if OK
				if(!verify_nonce($pdo)){
					die;
				}
					
				
                $sth = $pdo -> prepare($template);
				$sth -> bindValue(":username", $username);
				$sth -> bindValue(":passkey", $passkey);
				$sth -> bindValue(":displayname", $displayname);
				$sth -> bindValue(":highscore", $highscore, PDO::PARAM_INT);
                $sth -> execute();
				
				$affected_rows = $sth->rowCount();

				CloseConnPDO($pdo);
				
				if ($affected_rows > 0) {
					print_response("no_return", array("size" => 1));
				}
				else {
					print_response("display_name in use", array("size" => 0));
				}
				
				die;
				
				
			break;
			
			case "get_scores":
			
				$score_number_of = 10;
				$score_offset = 0;
				
				#Check for new values
				if (isset($dict_from_json['score_offset']))
					$score_offset = max(0, (int)$dict_from_json['score_offset']);
								
				if (isset($dict_from_json['score_number']))
					$score_number_of = max(1, (int)$dict_from_json['score_number']);
				
				$template = "SELECT * FROM `players` ORDER BY highscore DESC LIMIT :number OFFSET :offset";
				
				#Make a connection to the DB
				$pdo = OpenConnPDO();
				
				//Check for correct nonce (hashing), continue if OK
				if(!verify_nonce($pdo))
					die;
				
				$sth = $pdo -> prepare($template);
				$sth -> bindValue("number", $score_number_of, PDO::PARAM_INT);
				$sth -> bindValue("offset", $score_offset, PDO::PARAM_INT);
				$sth -> execute();
				
				//Get data containing all players
				$players = $sth -> fetchAll(PDO::FETCH_ASSOC);
				//Add number of players to the return value: "size"  (is used in Godot to control the number of players) 
				$players["size"] = sizeof($players);				

				CloseConnPDO($pdo);
				
				//Return players to user
				print_response("multi_return", $players);
				die;
				
			break;
			
			
			case "get_player":
			
				#Handle missing user id
				if (!isset($dict_from_json['username'])){
					print_response([], "missing_username");
					die;
				}
                if (!isset($dict_from_json['passkey'])){
					print_response([], "missing_passkey");
					die;
				}
				
				# Username max length 40, -> should be handled in Godot (if longer usernames is required simply change the length in the database)
				$username = $dict_from_json['username'];
                $passkey = $dict_from_json['passkey'];
				
				$template = "SELECT * FROM `players` WHERE username = :username AND passkey = :passkey";
                
				#Make a connection to the DB
				$pdo = OpenConnPDO();
				
				//Check for correct nonce (hashing), continue if OK
				if(!verify_nonce($pdo))
					die;
				
				$sth = $pdo -> prepare($template);
                $sth -> bindValue("username", $username);
                $sth -> bindValue("passkey", $passkey);
				$sth -> execute();

				//Get data containing all players (hopefully only one)
				$players = $sth -> fetchAll(PDO::FETCH_ASSOC);
				//Add number of players to the return value: "size"  (should be one, is not really necessary in Godot) 
				$players["size"] = sizeof($players);				

				CloseConnPDO($pdo);
				
				$data_status = "one_return";
				if (sizeof($players) == 0) $data_status = "no_return";
				
				//Return player to user
				print_response($data_status, $players);
				die;
		
			
			break;
				
			case "update_player":
				#Handle missing user id
				if (!isset($dict_from_json['displayname'])){
					print_response([], "missing_displayname");
					die;
				}
                if (!isset($dict_from_json['highscore'])){
					print_response([], "missing_highscore");
					die;
				}
				
				# Username max length 40, -> should be handled in Godot (if longer usernames is required simply change the length in the database)
				$displayname = $dict_from_json['displayname'];
                $highscore = $dict_from_json['highscore'];
				
				$template = "UPDATE `players` SET highscore = :highscore WHERE displayname = :displayname";
                
				#Make a connection to the DB
				$pdo = OpenConnPDO();
				
				//Check for correct nonce (hashing), continue if OK
				if(!verify_nonce($pdo))
					die;
				
				$sth = $pdo -> prepare($template);
                $sth -> bindValue("displayname", $displayname);
                $sth -> bindValue("highscore", $highscore);
				$sth -> execute();		
				
				// https://www.php.net/manual/en/pdostatement.rowcount.php Where i got row_count from
				$affected_rows = $sth->rowCount();

				CloseConnPDO($pdo);
				
				if ($affected_rows > 0) $data_status = "score_updated";
				
				else $data_status = "failed_to_update_score";
				
				//Reture update status
				print_response($data_status, []);
				die;
			break;
			
			#Handle none excisting request
			default:
				print_response([], "invalide_command");
				die;
			break;
		}

    ?>