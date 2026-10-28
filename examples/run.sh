#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHONPATH=src python -m gbt_media_stamp info
PYTHONPATH=src python -m gbt_media_stamp check --payload '{}'
PYTHONPATH=src python -m gbt_media_stamp run   --payload '{}'
