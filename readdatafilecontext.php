
<?php

$file = $_REQUEST['pathfile'] ;
// echo $dir;
$filesArray = array(); 
// $Counter = 0; 
$lines = file($file);
echo $lines;

//$files = scandir($dir); 
// 
// function get_value_of($name)
// {
//      $lines = file('yourfile.txt');
//      foreach (array_values($lines) AS $line)
//      {
//           list($key, $val) = explode('=', trim($line) );
//           if (trim($key) == $name)
//           {
//                 return $val;
//           }
//      }
//      return false;
// } 
// 
// // $filenames = explode(" ", $files);
// foreach ($files as &$file) { 
//     if ($file!='.' && $file!='..' ) { 
//         // $filesArray[$Counter] = $file; 
//         // echo $filesArray[$Counter].''; 
//         // $Counter++;
// 
// 	 
// 		//echo $lines; 
// 		 foreach (array_values($lines) AS $line)
// 			 	     {
// 			 	      //   echo $line;
// 			 	     }
// 		 // 	
// 		$bus = array(
// 		        'name' => $file,
// 		        'path' => $dir
// 		    );
// 		array_push($filesArray, $bus);
//     }
// } 
// //printf($filesArray);
// echo json_encode($filesArray); 


?>


