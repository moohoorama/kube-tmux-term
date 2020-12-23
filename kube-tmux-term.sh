pods=`kubectl get pods -o name`
tmux_session=SS_`date +%s`

echo ${tmux_session}
for host in ${pods}; do
    if ! tmux has-session -t "${tmux_session}" 2>/dev/null; then
        tmux new-session -s "${tmux_session}" -d "kubectl exec -it ${host} -- /bin/bash"
    elif [ -n "${tmux_attach_current_session}" ] && ! tmux list-windows -F "#W" | grep -q "${tmux_window}" >/dev/null; then
        tmux new-window ${tmux_window_options} "kubectl exec -it ${host} -- /bin/bash"
    else
        tmux split-window -t "${tmux_session}" -t ${tmux_window} -d "kubectl exec -it ${host} -- /bin/bash"
        tmux select-layout -t "${tmux_session}" tiled
    fi
done



tmux attach-session -t ${tmux_session}
