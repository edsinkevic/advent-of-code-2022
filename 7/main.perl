#!usr/bin/perl
use warnings;
use strict;

use Data::Dumper;
use Scalar::Util qw(looks_like_number);

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
  my ($line, $pwd, %state) = @_;

  if(my ($arg) = extract_cd_arg($line)) {
    return (cd($arg, $pwd), %state);
  }
  
  if(my ($name) = extract_dir_name($line)) {
    my $path = concat_dirs($pwd, $name);
    push @{ $state{$pwd} }, $path;
    return ($pwd, %state);
  }
  
  if(my ($size) = extract_size($line)) {
    push @{ $state{$pwd} }, $size;
    return ($pwd, %state);
  }
}

sub interpret_file {
  my ($file_name) = @_;
  my %state = ();
  my $pwd = "";

  open(file_handler, '<', $file_name) or die $!;

  my $line = <file_handler>;
  while($line){
    ($pwd, %state) = interpret_line($line, $pwd, %state);
    $line = <file_handler>;
  }

  close(file_handler);
  return %state;
}


sub sum {
  my ($key, %state) = @_;
  my $sum = 0;
  foreach my $elem (@{ $state{$key} }) {
    if(!looks_like_number($elem)) {
      (my $result, %state) = sum($elem, %state);
      $sum = $sum + $result;
    }
    else {
      $sum = $sum + $elem;
    }
  }

  @{ $state{$key} } = ($sum);
  return ($sum, %state);
}


sub solve1 {
  my (%state) = @_;
  my $result = 0;

  foreach my $key (keys %state) {
    (my $sum, %state) = sum($key, %state);
    my $add = $sum < 100000 ? $sum : 0;
    $result = $result + $add;
  }
  return ($result, %state);
}

sub solve2 {
  my (%state) = @_;
  my $full_size = 70000000;
  my $result = $full_size;
  (my $taken_space, %state) = sum("/", %state);
  my $free_space = $full_size - $taken_space;
  my $goal = 30000000;

  foreach my $key (keys %state) {
    (my $sum, %state) = sum($key, %state);
    my $potential_free = $free_space + $sum;
    if ($sum <= $result && $potential_free > $goal) {
      $result = $sum;
    }
  }
  return ($result, %state);
}

my %state = interpret_file("data.txt");

(my $result, %state) = solve1(%state);
print "$result\n";

($result, %state) = solve2(%state);
print "$result\n";
