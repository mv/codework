
## S3 REST Signature ##

S3 REST interface can be used by curl in the command line.

However, each GET requisition must be correctly formatted to
be accepted as valid.


    Item
    ----
    HTTP-Verb      + "\n" +
    [Content-MD5]  + "\n" +
    [Content-Type] + "\n" +
    Date           + "\n" +
    [CanonicalizedAmzHeaders +/n]
    [CanonicalizedResource]





    Example
    -------
    PUT\n
    4gJE4saaMU4BqNR0kLY+lw==\n
    image/jpeg\n
    Tue, 6 Mar 2007 19:42:41 +0000\n
    x-amz-acl:public-read\n
    x-amz-meta-checksum:crc32\n
    /mybucket/photos/lolcatz.jpg




vim:ft=markdown:

