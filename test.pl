#!/usr/bin/perl

$c = "traceroute -nI 216.244.192.2";
$result = `$c`;
_log($result);

sub _log {
        open TMP, ">>test.log";
        print TMP time();
        print TMP "@_\n";
        print TMP "\n";
        close TMP;
}