# vnstat-limit
Automatically manage and limit your bandwidth consumption to avoid overcharges


# Installation

```shell
apt-get install vnstat

wget -O /root/limit.sh https://raw.githubusercontent.com/Athlon1600/vnstat-limit/master/limit.sh
 
```

# Usage

This command will stop your Apache server once your total UPLOAD amount (data going outside) exceeds 1 terabyte:

```shell
bash limit.sh OUT 1000 "service apache2 stop"
```

Shows the total bandwidth consumption over the last 30 days and tells us if it exceeded our specified limit.

```shell
bash limit.sh TOTAL 8000
```

![vnstat](http://i.imgur.com/Wd5FSlT.png)
