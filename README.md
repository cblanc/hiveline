# Hiveline

Adjust your [Hive](https://my.hivehome.com/) thermostat via your terminal.

Warning: This uses hives unofficial and undocumented API. It can break at any time.

## Install

```bash
gem install hiveline
```

## Configure

Export credentials to your environment in `.bashrc` or `.bash_profile`

```bash
export HIVE_USERNAME="your_hive_email"

export HIVE_PASSWORD="your_hive_password"
```

Alternatively pass then as flags to hiveline

```
$ hiveline -u <email> -p <password> 
```

## Use

Get temperature

```bash
$ hiveline

Inside Temperature: 16.8°C (17°C todays average)
Outide Temperature: 7.2°C (Partly Cloudy)
```

Set temperature

```bash
$ hiveline 19 # Set temperature to 19°C

Setting temperature to 19°C
Successfully updated temperature. Set to 19°C
```

Get temperature history

```bash
$ hiveline --history

Retrieving history
00 AM ==================================  19.9°C
01 AM =================================   19.4°C
02 AM =================================   19.0°C
03 AM ================================    18.6°C
04 AM ===============================     18.3°C
05 AM ===============================     18.0°C
06 AM ==============================      17.8°C
07 AM =================================   19.1°C
08 AM =================================   19.0°C
09 AM =================================   19.1°C
10 AM ==================================  19.8°C
11 AM =================================   19.2°C
12 PM ================================    18.7°C
13 PM ================================    18.5°C
14 PM ===============================     18.2°C
15 PM =================================   19.3°C
16 PM ==================================  19.9°C
17 PM =================================   19.2°C
18 PM =================================   19.4°C
19 PM =================================   19.2°C
20 PM ==================================  20.1°C
21 PM ==================================  20.0°C
22 PM ==================================  19.9°C
```