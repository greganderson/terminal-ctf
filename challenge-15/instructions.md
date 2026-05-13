# Process Explorer

Run the `start_processes.sh` script to begin the challenge.

```
./start_processes.sh
```

Several background processes will start. One of them is named `secret_monitor`.

Your goal is to find the process ID (PID) of `secret_monitor` and submit it as the flag.

Submit just the PID number. For example, if the PID is 4242, submit `4242`.

## Cleanup

When you're done, run the cleanup script to stop all challenge processes:

```
./cleanup.sh
```

## Allowed Commands

- ps
- grep
- |
