#!/bin/bash

# Variables
USERNAME="pakkapon"
USER_UID=10013
GROUPNAME="pakkapon"
GROUP_UID=10014
DEFAULT_PASSWORD="123456"

# Check if the group already exists
if getent group $GROUPNAME > /dev/null 2>&1; then
    echo "Group '$GROUPNAME' already exists."
else
    # Create the group
    groupadd -g $GROUP_UID $GROUPNAME
    echo "Group '$GROUPNAME' created with GID $GROUP_UID."
fi

# Check if the user already exists
if id -u $USERNAME > /dev/null 2>&1; then
    echo "User '$USERNAME' already exists."
else
    # Create the user with the specified UID and group
    useradd -m -u $USER_UID -g $GROUP_UID -s /bin/bash $USERNAME
    echo "User '$USERNAME' created with UID $USER_UID and GID $GROUP_UID."

    # Set the default password
    echo "$USERNAME:$DEFAULT_PASSWORD" | chpasswd
    echo "Default password set for user '$USERNAME'."
fi
