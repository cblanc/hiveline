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

Set the temperature to 20C

```bash
$ hiveline 20
```