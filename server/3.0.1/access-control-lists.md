---
title: "Access Control Lists"
section: "Server"
version: 3.0.1
---

All information about the ACL of a stream is kept in metadata. There are 5 fields that can be set. You can also put [your own information in metadata](../stream-metadata), these are reserved fields within the stream metadata remember that in general anything that starts with a $ is considered a reserved space and you should not be naming your own things this way or you may end up with a conflict in the future.

The ACL is set with json. As an example:

```json
{
   "$acl" : {
      "$w"  : "$admins",
      "$r"  : "$all",
      "$d"  : "$admins",
      "$mw" : "$admins",
      "$mr" : "$admins"
   }
}
```

These fields represent the following

- $w  : The permission to write to this stream
- $r  : The permission to read from this stream
- $d  : The permission to delete this stream
- $mw : The permission to write the metadata associated with this stream
- $mr : The permission to read the metadata associated with this stream

These fields can be updated with either a single string or an array strings representing users or groups ($admins, $all, or your own custom groups). It is not normally recommended to give people access to $mw as then they can change their privileges on any other permission.

As an example if I had a stream that I wanted to be accessible only for Greg to write to but Greg and John could read from it I might set it up something like:

```json
{
   "$acl" : {
      "$w"  : "greg",
      "$r"  : ["greg", "john"],
      "$d"  : "$admins",
      "$mw" : "$admins",
      "$mr" : "$admins"
   }
}
```

*It is important to note that caching will be allowed on a stream if you have enabled it to be visible to $all. This is done as a performance optimization to avoid having to set cache=private on all data. As such if people are bookmarking your URIs and they have been cached by an intermediary then they may still be accessible after you change the permissions from $all to say only the user ouro. While clients should not be bookmarking urls in this way it is an important consideration.*

## Default ACLs

There is also a special ACL that is used as the default ACL. This can be found in the stream $settings. This stream controls the default ACLs for streams without ACLs and also controls who can for instance create streams in the system.


```json
{
    "$userStreamAcl" : {
        "$r"  : "$all",
        "$w"  : "$all",
        "$d"  : "$all",
        "$mr" : "$all",
        "$mw" : "$all"
    },
    "$systemStreamAcl" : {
        "$r"  : "$admins",
        "$w"  : "$admins",
        "$d"  : "$admins",
        "$mr" : "$admins",
        "$mw" : "$admins"
    }
}
```

The `$userStreamAcl` controls the default ACLs for user streams. The $systemStreamAcl is used as the default for all system streams. By default these are set as above. `$w` in the `$userStreamAcl` also applies to the ability to create a stream. Members of `$admins` always have access to everything (you cannot take this privilege away so be careful who you make admins!).

For example if I wanted to make it so that only `ouro` and `$admins` could create and write to streams in my system while everyone else can read from them I would configure the `$settings` as:

```json
{
    "$userStreamAcl" : {
        "$r"  : "$all",
        "$w"  : "ouro",
        "$d"  : "ouro",
        "$mr" : "ouro",
        "$mw" : "ouro"
    },
    "$systemStreamAcl" : {
        "$r"  : "$admins",
        "$w"  : "$admins",
        "$d"  : "$admins",
        "$mr" : "$admins",
        "$mw" : "$admins"
    }
}
```

If a stream in your system does not have an ACL set the default will be used as its ACL as well. If you specify say $r in your stream’s ACL it will override the default. As an example if I were to have the above defaults but on a specific stream (foostream) I were to put the stream level ACL of:

```json
{
   "$acl" : {
      "$r"  : ["greg", "john"],
   }
}
```

This would have an effective ACL of:


```json
{
   "$acl" : {
      "$r"  : ["greg", "john"],
      "$w"  : "ouro",
      "$d"  : "ouro",
      "$mr" : "ouro",
      "$mw" : "ouro"
   }
}

```

If for example I wanted ouro to be able to write to a stream but not create streams in the system I would setup my `$settings` to look like:

```json
{
    "$userStreamAcl" : {
        "$r"  : "$all",
        "$w"  : "$admins",
        "$d"  : "$admins",
        "$mr" : "$admins",
        "$mw" : "$admins"
    },
    "$systemStreamAcl" : {
        "$r"  : "$admins",
        "$w"  : "$admins",
        "$d"  : "$admins",
        "$mr" : "$admins",
        "$mw" : "$admins"
    }
}
```

Then I would setup the stream ACL of the stream with:

```json
{
   "$acl" : {
      "$w"  : "ouro"
   }
}
```

This will allow `ouro` to write to the stream but will not allow ouro to create streams in the system. 

This mechanism can also be used for removing things from the default. As an example I could setup the default with three users but then override the default on the stream level to only allow one user (and `$admins` which is by default).

```json
{
    "$userStreamAcl" : {
        "$r"  : "$all",
        "$w"  : ["ouro", "james", "greg"],
        "$d"  : "$admins",
        "$mr" : "$admins",
        "$mw" : "$admins"
    }
}
{
   "$acl" : {
      "$w"  : "ouro"
   }
}
```

If you put an empty array into an override it will just use the empty array as opposed to anything that was set on the default. In other words it will remove all permissions except for the default to `$admins`. If you were to write:

```json
{
    "$userStreamAcl" : {
        "$r"  : "$all",
        "$w"  : ["ouro", "james", "greg"],
        "$d"  : "$admins",
        "$mr" : "$admins",
        "$mw" : "$admins"
    }
}
{
   "$acl" : {
      "$w"  : []
   }
}
```

Is the equivalent of saying:

```json
{
    "$userStreamAcl" : {
        "$r"  : "$all",
        "$w"  : ["ouro", "james", "greg"],
        "$d"  : "$admins",
        "$mr" : "$admins",
        "$mw" : "$admins"
    }
}
{
   "$acl" : {
      "$w"  : "$admins"
   }
}
```