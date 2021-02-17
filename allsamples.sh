#! /bin/sh
# Installs all sample charts

helm template --namespace default -f samples/bookinfo-product/values.yaml ingress-service | kubectl apply -f -
helm template --namespace default -f samples/bookinfo-details/values.yaml mesh-service | kubectl apply -f -
helm template --namespace default -f samples/bookinfo-reviews/values.yaml mesh-service | kubectl apply -f -
helm template --namespace default -f samples/bookinfo-auth-policy/values.yaml auth-policy | kubectl apply -f -
helm template --namespace default -f samples/egress/values.yaml mesh-egress | kubectl apply -f -