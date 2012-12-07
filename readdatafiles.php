
<?php

$dir = $_REQUEST['dir'] ;
echo $dir;
$filesArray = array(); 
$Counter = 0; 
$files = scandir($dir); 

foreach ($files as &$file) { 
    if ($file!='.' && $file!='..' ) { 
        $filesArray[$Counter] = $file; 
        echo $filesArray[$Counter].''; 
        $Counter++;
    }
} 

echo json_encode($filesArray); 
?>

