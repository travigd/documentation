As of version 3.9.0 all future indexes will use 64-bit hashes instead of 32-bit hashes. The system will automatically transisition from 32-bit to 64-bit by writing all new indexes as 64-bit indexes during the merge process.

If you prefer to use only 64-bit indexes immediately you can force this.

For a small db just delete the index folder and let it rebuild (might
take a while)

If you have a large db / remote storage / etc and cannot take the time
you can also do this operation offline on another node:

# Take back up.
# Put on fast local disks
# Let it rebuild
# Restore the index back to a node (index folder)
# Let it catch up from master.
# Repeat 4/5 for other nodes.

For others the index will eventually be 64 bit due to the merging
process that occurs over time.
