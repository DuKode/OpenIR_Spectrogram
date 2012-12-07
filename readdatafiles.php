<?php
// author ilias koen 
// ilias.koen@dukodestudio.com
// the dukode studio 2012
// http://dukode.com 

$dir = $_REQUEST['dir'] ;
$filesArray = array(); 
$Counter = 0; 
$files = scandir($dir); 
foreach ($files as &$file) { 
    if ($file!='.' && $file!='..' ) { 
		$bus = array(
		        'name' => $file,
		        'path' => $dir
		    );
		array_push($filesArray, $bus);
    }
} 
echo json_encode($filesArray); 


?>


