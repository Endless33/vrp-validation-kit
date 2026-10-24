# VRP Validation Kit — Public Manifest Signature Verification

This directory contains public verification material for a signed
VRP Validation Kit documentation integrity manifest.

## Signer

Identity:

    vitalijus-riabovas-vrp

Signature algorithm:

    Ed25519

Signature format:

    OpenSSH SSHSIG

Signature namespace:

    vrp-evidence

Expected public-key fingerprint:

    SHA256:xeyh/yOOAoP41r/D+bHabhMjPaMqRb2dcI1rteShzgQ

## Verification files

    VRP-VALIDATION-KIT-DOCUMENTATION-SHA256-20261024T174146Z.txt
    VRP-VALIDATION-KIT-DOCUMENTATION-SHA256-20261024T174146Z.txt.sig
    vrp-manifest-signing-key.pub
    allowed_signers

The private signing key is not part of this repository.

## Verify the public key

Run from this directory:

    ssh-keygen -lf vrp-manifest-signing-key.pub -E sha256

Expected fingerprint:

    SHA256:xeyh/yOOAoP41r/D+bHabhMjPaMqRb2dcI1rteShzgQ

## Verify the manifest

Run:

    sha256sum VRP-VALIDATION-KIT-DOCUMENTATION-SHA256-20261024T174146Z.txt

Expected SHA-256:

    b772f83f33c3b6b934d14fa8dec1d11888567356f989977d3727080d987c10d5

## Verify the Ed25519 signature

Run:

    ssh-keygen -Y verify \
      -f allowed_signers \
      -I vitalijus-riabovas-vrp \
      -n vrp-evidence \
      -s VRP-VALIDATION-KIT-DOCUMENTATION-SHA256-20261024T174146Z.txt.sig \
      < VRP-VALIDATION-KIT-DOCUMENTATION-SHA256-20261024T174146Z.txt

Successful verification should report a good `vrp-evidence`
signature for `vitalijus-riabovas-vrp`.

## Security boundary

This directory contains public verification material only.

The private signing key and its passphrase must never be committed,
published, copied into this directory, or distributed.

The signature establishes that the manifest was signed by the private
key corresponding to the published Ed25519 public key.

Independent attribution of that key to a person depends on the
provenance and trust established for the public key and fingerprint.
