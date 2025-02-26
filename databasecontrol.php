<?php
    function print_response($dictionary = [], $error = "none"){
        $string = "";

        # Convert dictionary to JSON string
        $string = "{\"Error\" : \"$error\",
                    \"command\" : \"$_REQUEST[command]\",
                    \"response\" : ". json_encode($dictionary) ."}";

        echo $string
    }

    # Make sure command/message from godot is done correctly.
    if (!isset($_REQUEST['command']) or $_REQUEST['command'] === null){ 
        print_response([], "missing_command");
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
    $dsn = "mysql:dbname=$sql_db;host=$sql_host;charset=utf8mb4;port=3306"

    # Attempt to connect
    try{
        $pdo = new PDO($dsn, $sql_username, $sql_password);
    }

    # If something went wrong, return an error to Godot
    catch(\PDOException $e){
        print_response([], "db_login_error");
        die;
    }

    # Convert godot JSON string into a dictionary
    if ($json === null){
        print_response([], "invalid_json");
        die;
    }

    # Execute godot commands
    switch ($_REQUEST['command']){
        
        # Get scores from the database to set up the leaderboard in Godot
        case "get_score":

            # Determine how many scores to be retrived
            $score_offset = 0;
            $score_number = 10; # Placeholder, value to be declared in Godot

            if (isset($json['score_offset']))
				$score_start = max(0, (int) $json['score_offset']);
				
			if (isset($json['score_number']))
				$score_number = max(1, (int) $json['score_number']);

            # Form SQL request template
            $template = "SELECT * FROM 'highscores' ORDER BY score DESC LIMIT :numer OFSET :offset";

            $sth = $pdo -> prepare($template);
			$sth -> execute(["numer" => $score_number, "offset" => $score_offset]);

            # Grab the data from the request
            $data = $sth -> fetchAll();

            # Add how much data was sent to the godot structure
            $data["size"] = sizeof($data);

            print_response($data);

			die;


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
            $username = $json['username']
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
?>