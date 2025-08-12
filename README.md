# PanoSETI Control Container
This is the container for the PanoSETI control software.

## Set up
1. install [miniconda](https://www.anaconda.com/docs/getting-started/miniconda/install#linux-terminal-installer)(optional, but recommended) 
2. install [HASHPIPE](https://casper.astro.berkeley.edu/wiki/HASHPIPE) on the host computer
    ```
    git clone https://github.com/david-macmahon/hashpipe.git
    ```
    ```
    cd hashpipe
    ```
    ```
    git checkout 6b16dc80354d44a12a25faa8e6797aad3a54ceaf
    ```
3. install [podman](https://podman.io)
    ```
    sudo apt install podman
    ```
4. clone the `panoseti-pod` repo and the `panoseti` repo
    ```
    git clone -b podman https://github.com/panoseti/panoseti-pod.git
    cd panoseti-pod
    git submodule init
    git submodule update
    ```
5. install necessary python packages
    ```
    pip install -r requirements.txt
    ```
6. run `config.py` to generate the `panoseti-pod.yaml`
    ```
    python3 config.py --clone_sw
    ```
7. create pod
    ```
    ./setup.sh
    ```
8. use the terminal
    ```
    ./terminal.sh
    ```
9.  modify the config file in the `panoseti-control` directory
    ```
    cd panoseti-control/control/configs
    cp container/daq_config.json daq_config.json
    ```
    Then, modify the `head_node_ip_addr` and `ip_addr` to the host computer IP, and the `data_dir` to `panoseti-pod/data/daq`
