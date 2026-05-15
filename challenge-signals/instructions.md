# Signal Handler

Run the start script to launch the challenge daemon:

```
./start.sh
```

A background process will start. It has registered handlers for various Unix signals, but only one specific signal will make it reveal the flag. All others will be intercepted and responded to (but won't stop the daemon).

## Your goal

Send the daemon the correct signal to make it print the flag, then submit the flag string.

## Cleanup

When you're done, run the cleanup script:

```
./cleanup.sh
```

## Allowed Commands

- ps
- pgrep
- kill
- cat
- grep
- man
