# Day02

## メモリマップの確認

QEMUでLoader.efiを起動する。

    make qemu

run_qemu.shを使ってQEMUを起動察せると、カレントディレクトリにdisk.imgというファイルが生成される。これはUSBメモリの内容を1つのファイルにしたディスクイメージと呼ばれるファイルで、マウントすることで中身を見ることができる。

    mkdir -p mnt && sudo mount -o loop disk.img mnt
    ls mnt
    cat mnt/memmap

NOTE: `mount`はLinuxの基本操作の1つで、ファイルシステムを開いて使えるようにする操作である。USBメモリやCD-ROM、ネットワークドライブなど、外部記憶装置をLinuxで使うときによく実行する操作だが、今回のようにディスクイメージを開いて読み書きするような用途にも使うことができる。

一通り確認次第、ディスクイメージをアンマウントしておく。

    sudo umount mnt
