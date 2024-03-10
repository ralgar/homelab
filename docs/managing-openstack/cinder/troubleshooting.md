# Cinder: Troubleshooting

On occasion, you may run into issues with Cinder volumes. Here are some common
 cases.

## Dependencies

- [python-cinderclient](https://pypi.org/project/python-cinderclient/)

## Stuck volume state

Sometimes a Cinder volume may get stuck in a transitional state (reserved,
 attaching, etc). Fortunately, this is simple to fix:

!!! warning
    Before running this command, make sure it's the correct course of action.
    Incorrectly changing the state of an in-use volume could have unforeseen
    (and potentially disastrous) consequences.<br><br>
    From `cinder reset-state --help`:<br>
    >Explicitly updates the entity state in the Cinder database. Being a
    database change only, this has no impact on the true state of the entity
    and may not match the actual state.

```sh
cinder reset-state --state available --attach-status detached VOLUME_NAME_OR_ID
```
