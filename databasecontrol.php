<?php
    # Precode check
    if (isset($_SERVER['HTTP_ORIGIN'])){
        header("Access-Control-Allow-Origin: *"); # Allow external connections
        header("Access-Control-Max-Age: 60"); # Keep connections open for 60 seconds or 1 minute

        # Check if a site is requesting acces to the site
        if ($_SERVER["REQUEST_METHOD"] === "OPTIONS"){
            header("Access-Control-Allow-Methods: POST, OPTIONS");
            header("Access-Control-Allow-Headers: Authorization, Content-Type, Accept, Origin cache-control");
            http_response_code(200); #Report that request can be made
            die;
        }
    }

    #if ($_SERVER['REQUEST_METHOD'] !== "POST"){
    #    http_response_code(405); # Report "DENIED ACCESS"
    #    die;
    #}

    # Make sure command/message from godot is done correctly.
    if (!isset($_REQUEST['command']) or $_REQUEST['command'] === null){ 
        #print_response([], "missing_command");
        echo "{\"error\" : \"missing_command\", \"response\" : {}}";
        die;
    }

    # Makes sure data is sent properly, even if empty.
    if (!isset($_REQUEST['data']) or $_REQUEST['data'] === null){ 
        print_response([], "missing_data");
        die;
    }
    
    # Set connection properties for the database
    $sql_host = "localhost";	# Where the database is located
	$sql_db = "database_db";			# Name of the database
	$sql_username = "root";		# Login username for the database
	$sql_password = "";			# Login password for the database

    # Set up data in PDO format.
    $dsn = "mysql:dbname=$sql_db;host=$sql_host;charset=utf8mb4;port=3306";
    $pdo = null;

   # Attempt to connect
    try{
        $pdo = new PDO($dsn, $sql_username, $sql_password);
    }

    # If something went wrong, return an error to Godot
    catch(\PDOException $e){
        print_response([], "db_login_error");
        die;
    }

    # Convert Godot JSON string into a dictionary
    $json = json_decode($_REQUEST["data"], true);
    # Check that the JSON was valid
    if ($json === null){
        print_response([], "invalid_json");
        die;
    }

    # Execute godot commands
    switch ($_REQUEST['command']){
        
        # Generate single-use nonce for godot
        case "get_nonce":
            $bytes = random_bytesfix(32);
            $nonce = hash("sha256", $bytes);
        
            $template = "INSERT INTO `nonces` (`ip_address`, `nonce`) VALUES (:ip, :nonce) ON DUPLICATE KEY UPDATE `nonce` = :nonce_update";
        
            $sth = $pdo->prepare($template);
            $sth -> execute(["ip" => $_SERVER["REMOTE_ADDR"], "nonce" => $nonce, "nonce_update" => $nonce]);
            print_response(["nonce" => $nonce]);
        
            die;
        break;

        # Get scores from the database to set up the leaderboard in Godot
        case "get_scores":

            #Check for valid nonce
            if (!verify_nonce($pdo)){
                die;
            }

            # Determine how many scores to be retrived
            $score_offset = 0;
            $score_number = 10; # Placeholder, value to be declared in Godot

            if (isset($json['score_offset']))
				$score_start = max(0, (int) $json['score_offset']);
				
			if (isset($json['score_number']))
				$score_number = max(1, (int) $json['score_number']);

            # Form SQL request template
            $template = "SELECT * FROM `highscores` ORDER BY score DESC LIMIT :numer OFFSET :offset";

            $sth = $pdo -> prepare($template);
            $sth -> bindValue("number", $score_number, PDO::PARAM_INT);
            $sth -> bindValue("offset", $score_offset, PDO::PARAM_INT);
            $sth -> execute(["numer" => $score_number, "offset" => $score_offset]);
            
            # Grab the data from the request
            $data = $sth -> fetchAll(PDO::FETCH_ASSOC);

            # Add how much data was sent to the godot structure
            $data["size"] = sizeof($data);

            print_response($data);

			die;
        break;


        # Add score to highscore table
        case "add_score":

            # Check if data includes username and score
            if (!isset($json['score'])){
                print_response([], "missing_score");
                die;
            }

            if (!isset($json['username'])){
                print_response([], "missing_username");
                die;
            }

            # Make sure username is under 25 charachters. Limit clarified in the database.
            $username = $json['username'];
            if (strlen($username) > 24){
                $username = substr($username, 25);
            }

            # Form SQL request string:
			$template = "INSERT INTO `highscores` (username, score) VALUES (:username, :score) ON DUPLICATE KEY UPDATE score = GREATEST(score, VALUES(score))";
			
			# Prepare and send the request to the DB:
			$sth = $pdo -> prepare($template);
			$sth -> execute(["username" => $username, "score" => $json['score']]);
			
			# Print back an empty response signifying succes:
			print_response();
			die;
		break;
	
		# Handle invalid requests:
		default:
			print_response([], "invalid_command");
			die;
		break;      
    }

    function random_bytesfix($length)
    {
        $characters = '0123456789';
        $characters_length = strlen($characters);
        $output = '';
        for ($i = 0; $i < $length; $i++)
            $output .= $characters[rand(0, $characters_length - 1)];

        return $output;
    }

    # Verify that the user has permission and hasnt made an invalid command
    function verify_nonce($pdo, $secret = "1234567890")
    {
        #Make sure the Godot user sent over a CNONCE
        if (!isset($_SERVER['HTTP_CNONCE'])){
			print_response([], "invalid_nonce");
			return false;
		}
		
		# Make a request to pull the nonce from the server
		$template = "SELECT nonce FROM `nonces` WHERE ip_address = :ip";
		$sth = $pdo -> prepare($template);
		$sth -> execute(["ip" => $_SERVER['REMOTE_ADDR']]);
		$data = $sth -> fetchAll(PDO::FETCH_ASSOC);
		
		# Check that there was a nonce for this user on the database
		if (!isset($data) or sizeof($data) <= 0){
			print_response([], "server_missing_nonce");
			return false;
		}
		
		# Delete the nonce off the database
		$sth = $pdo -> prepare("DELETE FROM `nonces` WHERE ip_address = :ip");
		$sth -> execute(["ip" => $_SERVER["REMOTE_ADDR"]]);
		
		# Check the nonce hash to make sure it is valid:
		$server_nonce = $data[0]['nonce'];
		
		if (hash('sha256', $server_nonce . $_SERVER['HTTP_CNONCE'] . file_get_contents("php://input") . $secret) != $_SERVER["HTTP_HASH"]){
			print_response([], "invalid_nonce_or_hash");
			return false;
		}
		
		return true;
    }

    function print_response($dictionary = [], $error = "none")
    {
        $string = "";

        # Convert dictionary to JSON string
        $string = "{\"Error\" : \"$error\",
                    \"command\" : \"$_REQUEST[command]\",
                    \"response\" : ". json_encode($dictionary) ."}";

        echo $string;
    }

?>