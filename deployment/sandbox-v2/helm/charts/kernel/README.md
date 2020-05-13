TODO: Idgen has been removed for now as it is crashing, include it after fix.

TODO: maxUnavailable has been made to 0 in rolling strategy, otherwise helm does not wait with --wait option.  Change it later.

Sequence:
* Kernel services do not depend on each other to boot up.  They can start in any order.  TODO: confirm this.
