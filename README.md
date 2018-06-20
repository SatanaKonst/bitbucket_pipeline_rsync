# bitbucket_pipeline_rsync

<b>bitbucket-pipelines.yml</b>

<pre>
image: debian

pipelines:
  default:
    - step:
        script:
          - apt-get update && apt-get install -y ssh rsync expect
          -  chmod +x sync_files.sh
          - ./sync_files.sh
</pre>	

<b>sync_files.sh</b>

<pre>
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

	#Запускаем синхронизацию
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
</pre>	