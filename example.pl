#!/usr/bin/perl

use strict;
use Time::Local;
use HTML::Template;
use CGI;

my $deb = 1;


my $path_work = "/usr/lib/cgi-bin/examples";
my $path_templates = "$path_work/tmpl";
my $log = "$path_work/log/examples.log";



#-------------------------------------------------------------------------------
# Main
#-------------------------------------------------------------------------------

my $q = new CGI;

if ($q->param('index_form') eq 'enviar'){
	my $command = $q->param('command');
    my $parameter = $q->param('parameter');
	_log("index_form-> command : $command $parameter") if $deb;
	proccess_command($command, $parameter);
}

else {
	
    show_index();
}

#-------------------------------------------------------------------------------
# Funciones
#-------------------------------------------------------------------------------

sub show_index {
        my $tmpl = HTML::Template->new(filename => "$path_templates/index.html.tmpl");
	
        print $q->header();
        print $tmpl->output();
}

sub proccess_command{
	my ($command, $parameter)=@_;
    my $systemCommand;
    _log("=>proccess_command command: $systemCommand") if $deb;

    if ($command eq "ping") {
        $systemCommand = "ping -c 6 $parameter";
    }elsif ($command eq "traceroute") {
        $systemCommand = "traceroute -n $parameter";   
    }elsif ($command eq "snmpwalk") {
        $systemCommand = "snmpwalk $parameter ";   
    }else {
        $systemCommand = "Not allowed";   
    }


    my $result = `$systemCommand`;
    _log("=>proccess_command command: $systemCommand") if $deb;
    _log("=>proccess_command result: $result") if $deb;
    my $tmpl = HTML::Template->new(filename => "$path_templates/out.html.tmpl") or die;
    $tmpl->param(DATA_COMMAND => $systemCommand);
    $tmpl->param(DATA_RESULT => $result);
    
    print $q->header();
    print $tmpl->output();


}

sub _log {
        open TMP, ">>$log";
        print TMP time();
        print TMP "@_\n";
        print TMP "\n";
        close TMP;
}

sub esc {
        my ($ref) = @_;
        $ref =~ s/([^ :-a-zA-Z0-9_.@])/\\$&/g;
        return $ref;
}
