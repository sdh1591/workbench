
# runtime

## 0.0.1
### - unbuntu20.04
docker build --tag ghcr.io/dhshin/workbench:0.0.1-ubuntu20.04 -f ./dist/0.0.1/ubuntu2004/Dockerfile .
### - cuda1120ubuntu20.04-base
docker build --tag ghcr.io/dhshin/workbench:0.0.1-base-cuda1120ubuntu20.04 -f ./dist/0.0.1/cuda1120ubuntu2004/base/Dockerfile .
### - cuda1120ubuntu20.04-runtime
docker build --tag ghcr.io/dhshin/workbench:0.0.1-runtime-cuda1120ubuntu20.04 -f ./dist/0.0.1/cuda1120ubuntu2004/runtime/Dockerfile .
### - cuda1120ubuntu20.04-devel
docker build --tag ghcr.io/dhshin/workbench:0.0.1-devel-cuda1120ubuntu20.04 -f ./dist/0.0.1/cuda1120ubuntu2004/devel/Dockerfile .
### - cuda1130ubuntu20.04-runtime
docker build --tag ghcr.io/dhshin/workbench:0.0.1-runtime-cuda1130ubuntu20.04 -f ./dist/0.0.1/cuda1130ubuntu2004/runtime/Dockerfile .
### - cuda1170ubuntu20.04-runtime
docker build --tag ghcr.io/dhshin/workbench:0.0.1-runtime-cuda1170ubuntu20.04 -f ./dist/0.0.1/cuda1170ubuntu2004/runtime/Dockerfile .
### - cuda1200ubuntu20.04-runtime
docker build --tag ghcr.io/dhshin/workbench:0.0.1-runtime-cuda1200ubuntu20.04 -f ./dist/0.0.1/cuda1200ubuntu2004/runtime/Dockerfile .
### - default
docker build --tag ghcr.io/dhshin/workbench:v0.0.1 -f ./dist/0.0.1/ubuntu2004/Dockerfile .
