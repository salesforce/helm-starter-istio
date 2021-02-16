#! /bin/sh
LINT=$(helm lint auth-policy ingress-service mesh-egress mesh-service | grep -v "<CHARTNAME>")
echo "${LINT}"

# grep Extended(regex) insensitive inverted quiet
echo $LINT | grep -Eivq "WARNING|ERROR"