

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