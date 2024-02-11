# Use a lightweight base image
FROM alpine:3.14

# Install necessary dependencies
RUN apk add --update python3 py3-pip

# Install PyInstaller
RUN pip3 install pyinstaller

# Set the working directory
WORKDIR /app

# Copy your application code into the image
COPY sources /app/sources

# Run PyInstaller on your application code
RUN pyinstaller --onefile /app/sources/add2vals.py

# Set the entrypoint
ENTRYPOINT ["/app/dist/add2vals"]