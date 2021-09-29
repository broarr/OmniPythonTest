#!/usr/bin/env bash

PYTHON="poetry run python"
PROTO_DIR="./OmniProtos"
PROTO_FILES="$(find ${PROTO_DIR} -iname "*.proto")"

# Rebuilding twice in a row makes protoc complain.
# This exits before protoc and error.
if [ -f "device_pb2.py" ]; then
  exit 0
fi

# This makes sure that all the project dependencies are installed
# correctly. Right now those dependencies are grpcio and grpcio-tools
poetry install

# This calls the protoc protobuf compiler with the correct include
# directory and protobuf files. All generated files are output to the
# current working directory
${PYTHON} -m grpc.tools.protoc -I${PROTO_DIR} --python_out=. --grpc_python_out=. ${PROTO_FILES}

# The protobuf compiler will create the proper folder structure
# but it won't create a proper python package. We need to add the
# __init__ file manually in order for python to recognize the
# folder as a proper package.
mkdir -p platform && touch platform/__init__.py
