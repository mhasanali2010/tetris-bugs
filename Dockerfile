# Use a base imagine I made earlier
FROM ghcr.io/owl-corp/python-poetry-base:3-slim

# Pul in all the node binaries and libraries from the node image
COPY --from=node /usr/lib /usr/lib
COPY --from=node /usr/local/share /usr/local/share
COPY --from=node /usr/local/lib /usr/local/lib
COPY --from=node /usr/local/include /usr/local/include
COPY --from=node /usr/local/bin /usr/local/bin

# Install the image
WORKDIR /app
COPY pyproject.toml poetry.lock ./
RUN poetry install

# Copy & build the source code
COPY . .
WORKDIR /app/frontend
RUN npm install && npm run build

ENTRYPOINT ["poetry", "run"]
CMD ["python", "-m", "http.server"]
