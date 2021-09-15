#!/bin/bash
# Restart the deployment
# CAUTION: Restart will restart softhms as well.  Although, that is not expected to create any problems.
NS=ida
kubectl -n $NS rollout restart deploy
