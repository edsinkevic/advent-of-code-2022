#!usr/bin/perl
use warnings;
use strict;

use Data::Dumper;
use Scalar::Util qw(looks_like_number);

my $file_name = "data.txt";

my %state = ();
my $pwd = "";

sub extract_cd_arg {
  my ($line) = @_;
  return $line =~ m/cd (\S*)/;
}

sub extract_dir_name {
  my ($line) = @_;
  return $line =~ m/dir (\S*)/;
}

sub extract_size {
  my ($line) = @_;
  return $line =~ m/(\d*)/;
}

sub prev_dir {
  my ($path) = @_;
  my ($new_path) = $path =~ m/(.*[^a-z]+)/;
  if(length($new_path) > 1) {
    chop($new_path);
  }
  return $new_path;
}

sub concat_dirs {
  my ($pwd, $arg) = @_;
  return ($pwd eq "/") ? "$pwd$arg": "$pwd/$arg";
}

sub cd {
  my ($arg, $pwd) = @_;

  if($arg eq "/") {
    return "/";
  }

  if($arg eq "..") {
    return prev_dir($pwd);
  }

  return concat_dirs($pwd, $arg)
}

sub interpret_line {
  my ($line) = @_;

  if(my ($arg) = extract_cd_arg($line)) {
    $pwd = cd($arg, $pwd);
    return;
  }
  
  if(my ($name) = extract_dir_name($line)) {
    my $path = concat_dirs($pwd, $name);
    push @{ $state{$pwd} }, $path;
    return;
  }
  
  if(my ($size) = extract_size($line)) {
    push @{ $state{$pwd} }, $size;
    return;
  }
}

sub interpret_file {
  my ($file_name) = @_;
  # my %state = ();

  open(file_handler, '<', $file_name) or die $!;

  my $line = <file_handler>;
  while($line){
    interpret_line($line);
    $line = <file_handler>;
  }

  close(file_handler);
}

interpret_file("data.txt");

sub sum {
  my ($key) = @_;
  my $sum = 0;
  foreach my $elem (@{ $state{$key} }) {
    if(!looks_like_number($elem)) {
      $sum = $sum + sum($elem);
    }
    else {
      $sum = $sum + $elem;
    }
  }
  return $sum;
}

my $result = 0;

foreach my $key (keys %state) {
  my $sum = sum($key);
  # print "Sum: $sum\n";
  my $add = $sum < 100000 ? $sum : 0;
  $result = $result + $add;
}

print "$result\n";

my $full_size = 70000000;
$result = $full_size;
my $free_space = $full_size - sum("/");
my $goal = 30000000;

foreach my $key (keys %state) {
  my $sum = sum($key);
  my $potential_free = $free_space + $sum;
  if ($sum <= $result && $potential_free > $goal) {
    $result = $sum;
  }
}

print "$result\n";



