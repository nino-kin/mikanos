# Docker

## Install Docker Engine

Docker Engineは、CentOS・Debian・Fedora・Raspbian・RHEL・SLES・Ubuntuの各ディストリビューションに対応します。

### Install Docker using `apt` repository

Dockerのパッケージは、aptリポジトリに保管されるため、このリポジトリをaptのソースリストに追加する必要があります（追加しなければaptでDockerパッケージが見つかりません）。

まずは、既存のパッケージ情報を更新して、いくつかの依存関係をインストールします。また、ca-certificates、curl、gnupg、lsb_releaseを使って、Dockerのaptリポジトリの詳細情報と、使用しているシステムに対応した署名鍵をダウンロードしてください。こちらはすでに入手しているかと思いますが、念のため。

    sudo apt update
    sudo apt install ca-certificates curl gnupg lsb-release

次に、DockerのGPGの鍵をaptに登録します。これで、aptによる、インストールしたDockerパッケージの検証が可能になります。

    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

curlコマンドで、Ubuntuで利用できるDockerのGPG鍵をダウンロードし、標準のOpenGPGエンコーディングに変換して、aptのキーリングディレクトリに保存します。chmodは、aptが確実に検出できる様、キーリングファイルに対して権限を設定するコマンドです。

これで、Dockerパッケージのソースをシステムに追加できます。以下のコマンドを実行してください。

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

実行すると、シェルの置換を利用して、AMD64やARM64など、システムのアーキテクチャが自動で検出され、パッケージ情報がダウンロードされます。先ほど追加したGPG鍵を用いて認証が行われ、リポジトリが、新たなパッケージリストとしてapt /etc/apt/sources.list.d directory.に追加されます。

その後、aptがDockerパッケージの存在を検出できるよう、パッケージ情報を再度更新します。

    sudo apt update

これで、apt installコマンドで、Dockerのコンポーネントをシステムに追加することができます。以下3つの最新版のDocker Community Edition（CE）をインストールしましょう。

* docker-ce：Docker Engineのデーモン
* docker-ce-cli：操作することになるDocker CLI
* containerd.io：コンテナの起動と実行に利用するコンテナランタイム/ソフトウェア(containerd)

    sudo apt install docker-ce docker-ce-cli containerd.io

## Check the behavior of Docker Engine on your machine

Dockerをインストールしたら、コンテナを起動して、正常に動作することを確認します。

    sudo docker run hello-world

もし下記のようなエラーが発生した場合は、dockerのサービスを起動できていないことが考えられます。

> Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?

以下のコマンドを入力し、dockerを起動してください。

    sudo service docker start

## Manage Docker as a non-root user

For more information, please click[here](https://docs.docker.com/engine/install/linux-postinstall/).

1. Create the docker group.

        sudo groupadd docker

1. Add your user to the `docker` group.

        sudo usermod -aG docker $USER


1. Log out and log back in so that your group membership is re-evaluated.

        su - ${USER}

    > If you’re running Linux in a virtual machine, it may be necessary to restart the virtual machine for changes to take effect.

    You can also run the following command to activate the changes to groups:

        newgrp docker

1. Check to see if your user name has been added to the docker group.

        id -nG

1. Verify that you can run `docker` commands without `sudo`.

        docker run hello-world
