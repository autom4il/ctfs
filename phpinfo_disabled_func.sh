#!/usr/bin/env bash

URL=$1

dangerous_functions=(
    pcntl_alarm
    pcntl_fork
    pcntl_waitpid
    pcntl_wait
    pcntl_wifexited
    pcntl_wifstopped
    pcntl_wifsignaled
    pcntl_wifcontinued
    pcntl_wexitstatus
    pcntl_wtermsig
    pcntl_wstopsig
    pcntl_signal
    pcntl_signal_get_handler
    pcntl_signal_dispatch
    pcntl_get_last_error
    pcntl_strerror
    pcntl_sigprocmask
    pcntl_sigwaitinfo
    pcntl_sigtimedwait
    pcntl_exec
    pcntl_getpriority
    pcntl_setpriority
    pcntl_async_signals
    error_log
    system
    exec
    shell_exec
    popen
    proc_open
    passthru
    link
    symlink
    syslog
    ld
    mail
    eval
    base64_decode
)

mapfile -t disabled_functions < <(curl --silent "${URL}" |grep -E "disable_functions<\/td><td class=\"v\">.*?<" |awk -F '"v">|</' '{print $3}' |tr -s "," " ")

echo "[+] PHP available functions!"
for i in ${dangerous_functions[*]}
do
    # shellcheck disable=SC2076
    if [[  ! "${disabled_functions[*]}" =~ "$i"  ]]
    then
        echo "${i}"
    fi
done
