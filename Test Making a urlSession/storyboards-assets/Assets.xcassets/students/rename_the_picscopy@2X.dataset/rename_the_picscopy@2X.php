<?php
  echo "hello";

  echo "------------------";
   $path = getcwd();

   echo "\n The current folder is " .$path."\n";




   $lines = file("students10.csv");

   // Loop through our array, show HTML source as HTML source; and line numbers too.
/*
   foreach ($lines as $line_num => $line) {
       echo "Line {$line_num} : " . $line ;
       //$pieces = explode(" ", $line);
       //list($p1, $p2, $p3) = explode(" ", $line);
       //echo "\n" . $p1 . " " . $p2; // piece1

       // echo "\n" . $p1;
   }
*/

   // Open the file for reading
   if (($h = fopen("students10.csv", "r")) !== FALSE)
   {
     // Convert each line into the local $data variable
     while (($data = fgetcsv($h, 1000, ",")) !== FALSE)
     {
       // Read the data from a single line
       echo $data[0]. ".jpg"  .  " " .  $data[1]. ".jpg"    . "\n";
       rename( $data[0]. ".jpg",$data[1]. ".jpg");
       //rename( "STU".$data[1]. ".txt",$data[0]. ".txt");

     }


     // Close the file
     fclose($h);

  }

   echo "\n" . "goodbye" . "\n";


?>
