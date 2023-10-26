#!/usr/bin/env python3

import json
import requests
import sys


def lookup_metadata(mbid: str) -> dict:
    """Looks up the metadata for a listen using mbid."""
    params = {
        "recording_mbids": mbid,
        "inc": "release"
    }
   
    params["metadata"] = True
    response = requests.get(
        url="https://api.listenbrainz.org/1/metadata/recording/",
        params=params
    )
    response.raise_for_status()
    return response.json()


if __name__ == "__main__":
    #mbid_target = input('Please input the mbid of the recording: ').strip()

    metadata = lookup_metadata(str(sys.argv[1]))
    #metadata = lookup_metadata(mbid_target)

    print()
    if metadata:
        print("Metadata found.")
        print(json.dumps(metadata, indent=4))
    else:
        print("No metadata found.")
