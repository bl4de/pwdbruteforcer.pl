#!/usr/bin/perl
#
# bl4de <deebiaan@gmail.com>
#
# usage: pwdbruteforcer.pl [hash] [algorithm] [passwords list file | - for brute force] [tries] [password length]
#
# TODO: other algoritms (SHA1)
# 
# btw, czemu ja tu wszedzie nawijam po angielsku? :D :D
#

use Digest::MD5 qw(md5_hex);
use POSIX;

$trycounter = 1;

# script args:

if (@ARGV < 1) {
        print "\nusage: pwdbruteforcer.pl [hash] [algorithm] [passwords list file | - for brute force] [tries] [password length]\n\n";
        exit(0)
}#if

$pwdlist = @ARGV[2];
$hash = @ARGV[1];
$algorithm = @ARGV[0];
$tries = ( @ARGV[3] ) ? @ARGV[3] : -1;
$infostep = 10000;
# w przypadku nie podania dlugosci hasla - domyslnie 6 znakow
$password_length = ( @ARGV[4] ) ? @ARGV[4] : 6;

if ($pwdlist ne '-') { 
    open(PWDS, $pwdlist);
    @pwds = <PWDS>;
}#if


# ok, let's start searching...
$start = strftime "%H:%M:%S", localtime;

print "\n\n    ##########################################################################\n";
print "\n\tStarting at " . $start . " ,  trying to crack '" . $hash ."'\n";
print "\twith " .$algorithm . ", " . $password_length . "th signs length password \n";
print "\n\tYou can go drink coffee or something.... :P\n\n    ##########################################################################\n\n";
if ($pwdlist ne '-') {
    foreach $pwd (@pwds) {
            chomp($pwd);
            $digest = ret_hash($pwd);
            # system("clear");
            # print "try ". $trycounter . " :\t" . $pwd . " ->";
            if ($digest eq $hash) {
                # I found it !!! I found it !!! :D
                print "\n\nHuh, it is working! Password is: " . $pwd . "\n";
                print "start: " . $start . "\n stop: " . strftime("%H:%M:%S", localtime) . "\n\n";
                exit(0);
            }# if
            
            $trycounter++;
            if ($trycounter % $infostep == 0) {
                print "\n####   " . strftime ("%H:%M:%S", localtime) . "   ###   " . $trycounter . " tries so far and keep on....  :P"
            }#if
            if ($tries > 0 && $trycounter > $tries) {
                print "\n\nstart: " . $start . "\n stop: " . strftime("%H:%M:%S", localtime) . "\n\n";
                exit(0);
            }# if
    }# foreach
} else {
        # let's bruteforce him... :D
        
        while ($trycounter < $tries) {
            $pwd = generate_passwd($password_length);
            $digest = ret_hash($pwd, $algorithm);
            # system("clear");
            # adding generated pair password:hash to hashtable file:
            system ("echo " . $pwd . ":" . $digest ." >> hashtable." . $algorithm);
            # print "try ". $trycounter . " :\t" . $pwd . " generated: " . $digest . " ->";
            if ($digest eq $hash) {
                # I found it !!! I found it !!! :D
                print "\n\nHuh, it is working! Password is: " . $pwd . "\n";
                print "start: " . $start . "\n stop: " . strftime("%H:%M:%S", localtime) . "\n\n";
                exit(0);
            }# if 
            $trycounter++;
            if ($trycounter % $infostep == 0) {
                print "\n####   " . strftime ("%H:%M:%S", localtime) . "   ###   " . $trycounter . " tries so far and keep on....  :P"
            }#if
        }#while
}
print "\n\nDamn, nothing was found....   :/\n\nstart: " . $start . "\n stop: " . strftime("%H:%M:%S", localtime) . "\n\n";
exit(0);

# f-cja zwraca zakodowane w podanym algorytmie haslo
sub ret_hash {
        $_pwd = shift;
        $_algorithm = shift;
        if ($_algorithm eq "md5") {
            return md5_hex($_pwd);
        }#if
        
        return $_pwd;
}#ret_hash

# f-cja generuje losowy ciag znakow
sub generate_passwd {
    # znaki ASCII od 0x21 do 0x7e
    $_start = 74;
    $_end = 48;
    $_i = 0;
    $_passwd_length = shift;
    $_passwd = '';
    for($_i; $_i < $_passwd_length; $_i++) {
        $_ascii = int(rand($_start))+$_end;
        if (($_ascii > 57 && $_ascii < 65) || ($_ascii > 90 && $_ascii < 97)) {
            $_ascii += 8;
        }#if
        $_passwd .= chr($_ascii);
    }#for
    return $_passwd;    
}
# that's it :P
 

