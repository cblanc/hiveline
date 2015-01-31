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

Inside Temperature: 19.9°C
Weather in London: Cloudy With Light Rain (2.8°C)
```

Set temperature

```bash
$ hiveline 19 # Set temperature to 19°C

Setting temperature to 19°C
Successfully updated temperature. Set to 19°C
```