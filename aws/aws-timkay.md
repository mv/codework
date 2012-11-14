# Perl 'aws' script #

    by Tim Kay
    http://timkay.com/aws/
    http://timkay.com/aws/howto.html
    https://github.com/timkay/aws


## Install

*__'aws'__* is a perl standalone script. To install it:


    wget https://raw.github.com/timkay/aws/master/aws
    chmod +x aws

    Or......

    wget https://raw.github.com/timkay/aws/master/aws
    perl aws --install  # copy to /usr/bin/aws, make executable, create all symlinks



Amazon credentials can be defined in various ways:

    # Set env variables:
    export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
    export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY

    # or create ~/.awssecret:
    AKIAIOSFODNN7EXAMPLE
    wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY



## Usage ##


*__'aws'__* has options to use the most common AWS features, but it does not encompass
all available AWS services.

Currently the following are available:

        ec2
        elb
        iam
        s3
        sdb
        sqs


If command symlinks are enabled, each group of commands can be executed in more than
one way:

        # standalone version
        aws describe-tags | grep instance | grep Name | sort -k 4

        # symlink: long version
        ec2-describe-tags | grep instance | grep Name | sort -k 4

        # symlink: short version
        ec2dtags | grep instance | grep Name | sort -k 4


*__Standalone__* version is always enabled. The symlinks version can be enabled:


        # when installing
        perl aws --install

        # after install
        aws --links


### Default Region ###

If not specified, all manipulation of resources will take place in the default region
of *__'us-east-1'__*.

To see what region you are using currently:

        aws describe-availability-zones

        # or

        aws daz


To specify a different region:

        aws daz --region=sa-east-1


It's possible to change your default region by creating a rc file *__~/.awsrc__*

        # ~/.awsrc
        --region=sa-east-1


### Simple Output ###


All *__'aws'__* script output is ascii table formatted. For some scripting is
possible to remove this nicety using:


        aws daz --simple


To have it permanently set, add it to your rc file:


        # ~/.awsrc
        --region=sa-east-1
        --simple



## S3 commands ##


Commands to use in S3:


        aws ls                                  s3ls
        aws ls BUCKET_NAME                      s3ls BUCKET_NAME
        aws ls BUCKET_NAME/key                  s3ls BUCKET_NAME/key
        aws ls BUCKET_NAME/key/file.txt         s3ls BUCKET_NAME/key/file.txt

        aws mkdir  NEW_BUCKET_NAME              s3mkdir  NEW_BUCKET_NAME
        aws delete NEW_BUCKET_NAME              s3delete NEW_BUCKET_NAME

        aws put    BUCKET_NAME/key/file.txt     s3put    BUCKET_NAME/key/file.txt
        aws get    BUCKET_NAME/key/file.txt     s3get    BUCKET_NAME/key/file.txt
        aws delete BUCKET_NAME/key/file.txt     s3delete BUCKET_NAME/key/file.txt




## EC2 commands ##


* Examples:

        aws describe-addresses   # standalone, long version
        aws dad                  # standalone, short version
        ec2dad                   # symlink, short version


* All EC2 commands:

            # standalone, longversion             # short versions
            # aws <command>                       # aws <command> | ec2<command>
            ===================================== ==============================
            add-group                             addgrp
            add-keypair                           addkey
            allocate-address                      allad
            associate-address                     aad
            attach-volume                         attvol
            authorize                             auth
            create-image                          cimg
            cancel-spot-instance-requests         cancel       csir
            confirm-product-instance
            create-snapshot                       csnap
            describe-spot-instance-requests       dsir
            describe-spot-price-history           dsph
            create-volume                         cvol
            delete-group                          delgrp
            delete-keypair                        delkey
            delete-snapshot                       delsnap
            delete-volume                         delvol
            deregister
            describe-addresses                    dad
            describe-availability-zones           daz
            describe-groups                       dgrp
            describe-image-attribute
            describe-images                       dim
            describe-instances                    din
            describe-keypairs                     dkey
            describe-regions                      dreg
            describe-reserved-instances
            describe-reserved-instances-offerings
            describe-snapshot-attribute           dsa
            reset-snapshot-attribute              rsa
            modify-snapshot-attribute             msa
            describe-snapshots                    dsnap
            describe-volumes                      dvol
            detach-volume                         detvol
            disassociate-address                  disad
            get-console-output                    gco
            purchase-reserved-instance-offering
            reboot-instances                      reboot
            release-address                       rad
            register-image                        register
            request-spot-instances                req-spot     rsi
            revoke
            run-instances                         run-instance run
            start-instances                       start
            stop-instances                        stop
            terminate-instances                   tin
            create-tags                           ctags
            describe-tags                         dtags
            delete-tags                           deltags


## ELB commands ##

ELB: Elastic Load Balancer

            # standalone, longversion           # short version
            # aws <command>                     # aws <command>
            ===========================         ==============================
            configure-healthcheck               ch
            create-app-cookie-stickiness-policy cacsp
            create-lb-cookie-stickiness-policy  clbcsp
            create-lb                           clb
            create-lb-listeners                 clbl
            delete-lb                           dellb
            delete-lb-listeners                 dlbl
            delete-lb-policy                    dlbp
            describe-instance-health            dih
            describe-lbs                        dlb
            disable-zones-for-lb                dlbz
            enable-zones-for-lb                 elbz
            register-instances-with-lb          rlbi
            deregister-instances-from-lb        dlbi
            set-lb-listener-ssl-cert            slblsc
            set-lb-policies-of-listener         slbpol


## IAM commands ##

IAM: Identity and Access Management

            # standalone, longversion   # short version
            # aws <command>             # aws <command>
            =========================== ==============================
            groupaddpolicy              pgp
            groupadduser
            groupcreate                 cg
            groupdel
            groupdelpolicy
            grouplistbypath             lg
            grouplistpolicies           lgp
            groupgetpolicy
            grouplistusers              gg
            groupmod
            groupremoveuser
            groupuploadpolicy
            useraddcert
            useraddkey                  cak
            useraddloginprofile         clp
            useraddpolicy               pup
            usercreate                  cu
            userdeactivatemfadevice
            userdel
            userdelcert
            userdelkey
            userdelloginprofile         dlp
            userdelpolicy
            userenablemfadevice
            usergetattributes           gu
            usergetloginprofile         glp
            userlistbypath              lu
            userlistcerts
            userlistgroups
            userlistkeys
            userlistmfadevices
            userlistpolicies            lup
            usergetpolicy
            usermod
            usermodcert
            usermodkey
            usermodloginprofile         ulp
            userresyncmfadevice
            useruploadpolicy
            servercertdel
            servercertgetattributes
            servercertlistbypath
            servercertmod
            servercertupload
            accountaliascreate          caa
            accountaliasdelete          daa
            accountaliaslist            laa


## SDB commands ##

SBD: Simple DB

            # standalone, longversion   # short version
            # aws <command>             # aws <command>
            =========================== ==============================

            create-domain               cdom
            delete-attributes           datt
            delete-domain               ddom
            get-attributes              gatt
            list-domains                ldom
            put-attributes              patt
            select



## SQS commands ##

SQS: Simple Queue Service

            # standalone, longversion   # short version
            # aws <command>             # aws <command>
            =========================== ==============================
            add-permission              addperm
            change-message-visibility   cmv
            create-queue                cq
            delete-message              dm
            delete-queue                dq
            get-queue-attributes        gqa
            list-queues                 lq
            receive-message             recv
            remove-permission           remperm
            send-message                send
            set-queue-attributes        sqa

## Meta



    Created by: Marcus Vinicius Fereira            ferreira.mv[ at ].gmail.com
          When: 2012-10



vim:ft=markdown

