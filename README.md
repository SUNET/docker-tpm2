TPM 2.0 tools in a Docker container

What is this?
-------------
Current Debian/Ubuntu (18.04) doesn't include late-enough versions of the tools to
work with TPM 2.0 chips. This Docker container is meant to be useful as a toolbox
to provision a TPM 2.0 chip and use it to sign CSRs etc.

It installs some generic crypto tools, and builds the following from source:

  - tpm2-tss
  - tpm2-tools
  - tpm2-abrmd
  - tpm2-pk11
