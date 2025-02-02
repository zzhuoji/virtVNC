# syntax=docker/dockerfile:1.4

FROM --platform=$BUILDPLATFORM docker.io/bitnami/kubectl:1.29.0
ADD static /static
CMD ["proxy", "--www=/static", "--accept-hosts=^.*$", "--address=[::]", "--api-prefix=/k8s/", "--www-prefix="]
