<?php

function solve($size) {
  $file_name = "data.txt";
  $file = fopen($file_name, "r") or die("Unable to open file!");
  $buffer = fread($file, $size);
  $count = $size;
  while (!all_unique($buffer, $size)) {
    $buffer = substr($buffer, 1) . fread($file, 1);
    $count++;
  }
  fclose($file);
  return $count;
}

function all_unique($str, $size) {
  return strlen(count_chars($str, 3)) == $size;
}

echo solve(4) . ' ';
echo solve(14);
