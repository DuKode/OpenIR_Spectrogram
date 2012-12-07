<?php
// author ilias koen 
// ilias.koen@dukodestudio.com
// the dukode studio 2012
// http://dukode.com 

$file = $_REQUEST['pathfile'] ;
$spectralData = array(); 
$lines = file($file);
$name = $lines[0];
$d = array();
for ($i=27; $i <sizeof($lines);++$i){
    $name = (string) ($lines[0]);
		
	$data= explode('	', $lines[$i]);
	$wave = (float) ($data[0]);
	$refl = (float) ($data[1]); 
	$d = array(
		'name' => $name,
		'wavelength' => $wave,
		'reflectance' => $refl
	    );
	array_push($spectralData, $d);
   }
echo json_encode($spectralData); 

?>


