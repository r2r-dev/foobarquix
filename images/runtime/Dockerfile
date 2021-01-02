# gcr.io/distroless/cc-debian10:nonroot
FROM gcr.io/distroless/cc-debian10@sha256:54c7c58597fef585fd57e66dba643df135a6b24d221ead7318b1e6787f369fe6
USER nonroot
WORKDIR /
COPY --chown=nonroot:nonroot bin/wsgi.dist /app
CMD ["/app/wsgi"]  

