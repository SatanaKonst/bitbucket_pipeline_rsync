#!/usr/bin/expect
set host "Host"
set user "Username"
set pass "Password"
set remote_path "remote_path"
set local_path "local_path"

#Создаем временный конфиг для ssh
set outFileId [open "~/.ssh/config" "w"] 
puts -nonewline $outFileId "Host $host\n    StrictHostKeyChecking no\n   UserKnownHostsFile=/dev/null"
close $outFileId

#ЗАпускаем синхронизаци.
spawn rsync -avzhe ssh $local_path $user@$host:$remote_path

#отвечаем на вопросы
expect {
	"Are you sure you want to continue connecting (yes/no)?" { send -- "yes\n" }
	"password:" { send -- "$pass\n"}
	"$user@$host's password: " { send -- "$pass\n" }
	eof
}

if [catch wait] {
    puts "rsync failed"
    exit 1
}
exit 0