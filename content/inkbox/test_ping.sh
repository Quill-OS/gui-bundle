#!/bin/sh

(ping -c 1 1.1.1.1 && echo "true" > /run/test_ping_status || echo "false" > /run/test_ping_status) &>/dev/null
