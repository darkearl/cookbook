#!/bin/bash -e

#########################
# Include another Utils #
#########################
DIR_LIBRARIES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${DIR_LIBRARIES}/stringUtils.bash"

source "${DIR_LIBRARIES}/packageUtils.bash"

source "${DIR_LIBRARIES}/systemUtils.bash"

source "${DIR_LIBRARIES}/fileRemoteUtils.bash"

source "${DIR_LIBRARIES}/fileLocalUtils.bash"

source "${DIR_LIBRARIES}/arrayUtils.bash"

