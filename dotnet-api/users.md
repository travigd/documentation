---
title: "User Management"
section: ".NET API"
version: "4.0.2"
---

The Event Store Client API includes helper methods that use the HTTP API to allow for the management of users. This document will describe the methods found in the `UsersManager` class. All methods in this class are asynchronous.

## Methods

### Create a User

Creates a user, the credentials for this operation must be a member of the `$admins` group.

```csharp
public Task CreateUserAsync(string login, string fullName, string[] groups, string password, UserCredentials userCredentials = null)
```

### Disable a User

Disables a user, the credentials for this operation must be a member of the `$admins` group.

```csharp
public Task DisableAsync(string login, UserCredentials userCredentials = null)
```

### Enable a User

Enables a user, the credentials for this operation must be a member of the `$admins` group.

```csharp
public Task EnableAsync(string login, UserCredentials userCredentials = null)
```

### Delete a User

Deletes (non-recoverable) a user, the credentials for this operation must be a member of the `$admins` group. If you prefer this action to be recoverable, disable the user as opposed to deleting the user.

```csharp
public Task DeleteUserAsync(string login, UserCredentials userCredentials = null)
```

### List all Users

Lists all users.

```csharp
public Task<List<UserDetails>> ListAllAsync(UserCredentials userCredentials = null)
```

### Get Details of User

This will return the details of the user supplied in user credentials (e.g. the user making the request).

```csharp
public Task<UserDetails> GetCurrentUserAsync(UserCredentials userCredentials)
```

<!-- TODO: Explanations of the below -->

### Get Details of Logged in User

```csharp
public Task<UserDetails> GetUserAsync(string login, UserCredentials userCredentials)
```

### Update User Details

```csharp
public Task UpdateUserAsync(string login, string fullName, string[] groups, UserCredentials userCredentials = null)
```

### Reset User Password

Resets the password of a user. The credentials doing this operation must be part of the `$admins` group.

```csharp
public Task ResetPasswordAsync(string login, string newPassword, UserCredentials userCredentials = null)
```
