
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Generic Title: "Password Authentication Failure for Postgres User"
---

This incident type occurs when there is a failure in the authentication process for the Postgres user's password. This can happen due to a variety of reasons such as incorrect login credentials, expired passwords, or database configuration issues. It is important to address this type of incident promptly to ensure that the database remains secure and accessible only to authorized users.

### Parameters
```shell
export PATH_TO_POSTGRES_LOG_FILE="PLACEHOLDER"

export POSTGRES_USER="PLACEHOLDER"

export NEW_PASSWORD="PLACEHOLDER"

export PATH_TO_DATABASE_CONFIGURATION_FILE="PLACEHOLDER"
```

## Debug

### Next Step
```shell
shell

# Step 1: Check if Postgres service is running

systemctl status postgresql.service
```

### Step 2: Verify if Postgres user exists
```shell
sudo su - postgres -c "psql -c \"SELECT 1\""
```

### Step 3: Check if the password for Postgres user is correct
```shell
sudo su - postgres -c "psql -c \"\du\""
```

### Step 4: Check if password expiration for Postgres user is enabled
```shell
sudo su - postgres -c "psql -c \"SHOW password_encryption\""
```

### Step 5: Check if there are any relevant logs for the authentication failure
```shell
grep -i "authentication failed" ${PATH_TO_POSTGRES_LOG_FILE}
```

### Step 6: Check if there are any relevant logs for the database connection failure
```shell
grep -i "could not connect" ${PATH_TO_POSTGRES_LOG_FILE}
```

### The database configuration settings have been changed or misconfigured, leading to authentication issues.
```shell


#!/bin/bash



# Define the database configuration file path

DB_CONFIG_FILE=${PATH_TO_DATABASE_CONFIGURATION_FILE}



# Check if the database configuration file exists

if [ -f "$DB_CONFIG_FILE" ]; then



  # Check the configuration settings for the Postgres user

  grep "postgres" $DB_CONFIG_FILE | grep "password"



  # Check if the authentication method is set to "password"

  grep "postgres" $DB_CONFIG_FILE | grep "auth-method"



else

  echo "Database configuration file does not exist."

fi


```

## Repair

### Verify that the user is entering the correct login credentials. If the user is unsure of their login credentials, reset their password and provide them with the new login information.
```shell


#!/bin/bash



# Set variables

POSTGRES_USER=${POSTGRES_USER}

NEW_PASSWORD=${NEW_PASSWORD}



# Verify correct login credentials

if psql -U "$POSTGRES_USER" -c "SELECT 1" > /dev/null 2>&1; then

    echo "User $POSTGRES_USER has authenticated successfully"

else

    # Reset password

    psql -U postgres -c "ALTER USER $POSTGRES_USER PASSWORD '$NEW_PASSWORD';"

    echo "Password for user $POSTGRES_USER has been reset to $NEW_PASSWORD"

fi


```