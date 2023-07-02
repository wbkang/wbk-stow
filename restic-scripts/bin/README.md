

## Install 

sudo stow -d ~/wbk-stow/ restic-scripts -t /usr/local/

## Crontab schedules

root crontab
```crontab
0 * * * * /usr/local/bin/run-restic-backup
```

user crontab
```crontab
30 2 * * * /usr/local/bin/run-restic-forget
30 3 * * * /usr/local/bin/run-restic-copy
```