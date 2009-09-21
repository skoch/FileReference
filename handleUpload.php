<?php
	
	// $id = $_POST["id"];
	// 
	// $dbhost = 'localhost';
	// $dbuser = 'skoch';
	// $dbpass = 'qwe123;';
	// 
	// $conn = mysql_connect($dbhost, $dbuser, $dbpass) or die('Error connecting to mysql');
	// 
	// $dbname = 'komielan_track';
	// mysql_select_db($dbname);
	// 
	// $sql = "INSERT INTO outgoing (link_id) VALUES ('$id')";
	// if(!mysql_query($sql,$conn))
	// {
	// 	die('Error: ' . mysql_error());
	// }
	// mysql_close($conn);
	
	if ($_FILES['Filedata']['name'])
	{
		$ext = end(explode(".", basename($_FILES['Filedata']['name'])));
		//$fileName = time() . "_" . basename($_FILES['Filedata']['name'];
		$fileName = time() . "." . $ext;
		if( move_uploaded_file( $_FILES['Filedata']['tmp_name'], 'uploads/' . $fileName ) )
		{
			echo "<file name='$fileName' />";
		}else
		{
			echo "<file name='error' />";
		}
	}
	
	
	/*
	
	$MAXIMUM_FILESIZE = 1024 * 200; // 200KB
	$MAXIMUM_FILE_COUNT = 10; // keep maximum 10 files on server
	echo exif_imagetype($_FILES['Filedata']);
	if ($_FILES['Filedata']['size'] <= $MAXIMUM_FILESIZE)
	{
	    move_uploaded_file($_FILES['Filedata']['tmp_name'], "./temporary/".$_FILES['Filedata']['name']);
	    $type = exif_imagetype("./temporary/".$_FILES['Filedata']['name']);
	    if ($type == 1 || $type == 2 || $type == 3)
	    {
	        rename("./temporary/".$_FILES['Filedata']['name'], "./images/".$_FILES['Filedata']['name']);
	    }
	    else
	    {
	        unlink("./temporary/".$_FILES['Filedata']['name']);
	    }
	}
	$directory = opendir('./images/');
	$files = array();
	while ($file = readdir($directory))
	{
	    array_push($files, array('./images/'.$file, filectime('./images/'.$file)));
	}
	usort($files, sorter);
	if (count($files) > $MAXIMUM_FILE_COUNT)
	{
	    $files_to_delete = array_splice($files, 0, count($files) - $MAXIMUM_FILE_COUNT);
	    for ($i = 0; $i < count($files_to_delete); $i++)
	    {
	        unlink($files_to_delete[$i][0]);
	    }
	}
	print_r($files);
	closedir($directory);

	function sorter($a, $b)
	{
	    if ($a[1] == $b[1])
	    {
	        return 0;
	    }
	    else
	    {
	        return ($a[1] < $b[1]) ? -1 : 1;
	    }
	}
	*/
	
?>