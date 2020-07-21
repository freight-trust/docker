#!/bin/sh

## for entire folder, will generate sha256sum then *append* to a file, for different usage change &>> to w/e.

find . -type f -exec sha256sum {} \; &>> SHA256SUMS

# gpg sign and save into SIGN
gpg --print-md SHA512 -type f &>> SIGN
