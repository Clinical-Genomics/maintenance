alias jobinfo="scontrol show jobid -d |    /mnt/hds/proj/bioinfo/SCRIPTS/jobinfo.pl"
alias rjobinfo="scontrol show jobid -d |   /mnt/hds/proj/bioinfo/SCRIPTS/jobinfo.pl | grep '#\|RUNNING'"

alias myjobinfo="scontrol show jobid -d |  /mnt/hds/proj/bioinfo/SCRIPTS/jobinfo.pl -u $USER"
alias myrjobinfo="scontrol show jobid -d | /mnt/hds/proj/bioinfo/SCRIPTS/jobinfo.pl -u $USER | grep '#\|RUNNING'"
