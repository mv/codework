# s3cmd #

    by Michal Ludvig
    http://s3tools.org/s3cmd
    https://github.com/s3tools/s3cmd


## Install

*__'s3cmd'__* is a python utility script. To install it:


    # Mac
    brew install s3cmd

    # RPM
    curl http://s3tools.org/repo/RHEL_6/s3tools.repo -o /etc/yum.repos.d/s3tools.repo
    yum repolist all
    yum install s3tools

    # Deb
    wget -O- -q http://s3tools.org/repo/deb-all/stable/s3tools.key | sudo apt-key add -
    sudo wget -O/etc/apt/sources.list.d/s3tools.list http://s3tools.org/repo/deb-all/stable/s3tools.list
    sudo apt-get update && sudo apt-get install s3cmd



Amazon credentials must be configured inside *__'~/.s3cfg'_*. To create this file:

    # create .s3cfg
    s3cmd --configure


After created, check these configuration itens:

    # ~/.s3cfg
    access_key = B5JYHPQCXW13EXAMPLE
    secret_key = GAHKWG3+1wxcqyhpj5b1Ggqc0TIxj2EXAMPLE
    bucket_location = sa-east-1


## Usage ##


Basic usage:

    # list, list all, list recursively
    s3cmd ls
    s3cmd la

    s3cmd ls s3://BUCKET_NAME
    s3cmd ls s3://BUCKET_NAME -r
    s3cmd ls s3://BUCKET_NAME/prefix
    s3cmd ls s3://BUCKET_NAME/prefix -r
    s3cmd ls s3://BUCKET_NAME/prefix --list-md5


    # create/remove bucket
    s3cmd mb s3://BUCKET_NAME
    s3cmd mb s3://BUCKET_NAME --bucket-location=sa-east-1
    s3cmd rb s3://BUCKET_NAME
    s3cmd rb s3://BUCKET_NAME -r

    # bucket usage
    s3cmd du s3://BUCKET_NAME
    s3cmd du s3://BUCKET_NAME/prefix

    # files
    s3cmd put FILE s3://BUCKET_NAME/prefix/
    s3cmd get s3://BUCKET_NAME/prefix/file
    s3cmd get s3://BUCKET_NAME/prefix/file  new_filename.txt

    s3cmd del s3://BUCKET_NAME/prefix/file




## Advanced usage ##

    s3cmd info s3://BUCKET_NAME/prefix/file
    s3cmd setacl s3://BUCKET_NAME/prefix/file
    s3cmd accesslog s3://BUCKET_NAME/prefix/file

    # bucket to bucket
    s3cmd cp s3://BUCKET1/object s3://BUCKET2/object
    s3cmd mv s3://BUCKET1/object s3://BUCKET2/object

    # sync download
    s3cmd sync s3://BUCKET_NAME/prefix  local_dir
    s3cmd sync s3://BUCKET_NAME/prefix  local_dir --recursive
    s3cmd sync s3://BUCKET_NAME/prefix  local_dir --preserve
    s3cmd sync s3://BUCKET_NAME/prefix  local_dir --delete-removed
    ...

    # sync upload
    s3cmd sync local_dir s3://BUCKET_NAME/prefix --recursive
    s3cmd sync local_dir s3://BUCKET_NAME/prefix --preserve
    s3cmd sync local_dir s3://BUCKET_NAME/prefix --exclude=GLOB
    s3cmd sync local_dir s3://BUCKET_NAME/prefix --exclude-from=FILE
    s3cmd sync local_dir s3://BUCKET_NAME/prefix --rexclude=REGEX
    s3cmd sync local_dir s3://BUCKET_NAME/prefix --include=GLOB
    s3cmd sync local_dir s3://BUCKET_NAME/prefix --include-from=FILE
    s3cmd sync local_dir s3://BUCKET_NAME/prefix --rinclude=REGEX
    s3cmd sync local_dir s3://BUCKET_NAME/prefix --delete-removed
    s3cmd sync local_dir s3://BUCKET_NAME/prefix --encrypt
    s3cmd sync local_dir s3://BUCKET_NAME/prefix --check-md5
    s3cmd sync local_dir s3://BUCKET_NAME/prefix --no-check-md5


For more details on sync usage:

    http://s3tools.org/s3cmd-sync




