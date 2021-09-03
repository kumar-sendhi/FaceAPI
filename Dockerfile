FROM ubuntu:18.04 as sgxbase
RUN apt-get update && apt-get install -y \
    gnupg \
    wget
############################          START OF SGX       ##################################

RUN echo 'deb [arch=amd64] https://download.01.org/intel-sgx/sgx_repo/ubuntu bionic main' > /etc/apt/sources.list.d/intel-sgx.list
RUN wget -qO - https://download.01.org/intel-sgx/sgx_repo/ubuntu/intel-sgx-deb.key | apt-key add -
RUN apt-get update 

FROM sgxbase as sgx_sample_builder
# App build time dependencies
RUN apt-get install -y build-essential

WORKDIR /opt/intel
RUN wget https://download.01.org/intel-sgx/sgx-linux/2.8/distro/ubuntu18.04-server/sgx_linux_x64_sdk_2.8.100.3.bin
RUN chmod +x sgx_linux_x64_sdk_2.8.100.3.bin
RUN echo 'yes' | ./sgx_linux_x64_sdk_2.8.100.3.bin
WORKDIR /opt/intel/sgxsdk/SampleCode/SampleEnclave
RUN SGX_DEBUG=0 SGX_MODE=HW SGX_PRERELEASE=1 make

FROM sgxbase as sample
RUN apt-get install -y \
    libcurl4 \
    libprotobuf10 \
    libssl1.1

# No AESM daemon, only AESM client side API support for launch.
# For applications requiring attestation, add libsgx-quote-ex
RUN apt-get install -y --no-install-recommends libsgx-launch libsgx-urts

COPY --from=sgx_sample_builder /opt/intel/sgxsdk/SampleCode/SampleEnclave/app .
COPY --from=sgx_sample_builder /opt/intel/sgxsdk/SampleCode/SampleEnclave/enclave.signed.so .

RUN adduser -q --disabled-password --gecos "" --no-create-home sgxuser
USER sgxuser
CMD ./app

FROM sgxbase as aesm 
RUN apt-get install -y \
    libcurl4 \
    libprotobuf10 \
    libssl1.1 \
    make \
    module-init-tools

# More aesm plugins, e.g libsgx-aesm-quote-ex-plugin, are needed if application requires attestation. See installation guide.
RUN apt-get install -y libsgx-aesm-launch-plugin

# Run the aesm service as root to ensure its access to /dev/sgx/provision
WORKDIR /opt/intel/sgx-aesm-service/aesm
ENV LD_LIBRARY_PATH=.
CMD ./aesm_service --no-daemon
############################          END OF SGX       ##################################

############################           FaceApi         ##############################
FROM python:3.9.1
copy . /app
WORKDIR /app/FaceAPI/
RUN pip install -r requirements.txt
CMD ["python3","app.py"]
