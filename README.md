# Godot 4 Port Attempt

This is an attempt to port the current gotm plugin/addon.
Godot 4.0 recently released and the developers at gotm.io are currently trying to support it on their platform.
To accelerate the support with the plugin, and to personally get experince with the new gdscript language that has been overhauled, I decided to attempt porting the old plugin.

I will try to adhere to the official style guide here: https://docs.godotengine.org/en/4.0/tutorials/scripting/gdscript/gdscript_styleguide.html


## Progress
| File Name                 | Status  | TODOs | Offline Tested | Online Tested | Unit Tested | Documentation | Reviewed |
| ------------------------- |:-------:| -----:|:--------------:|:-------------:|:-----------:|:-------------:|:--------:|
| impl/_Gotm.gd             | ☑      | 2     | N/A            | —             | —           | —             | —        |
| impl/_GotmAuth.gd         | ☑      | 2     | N/A            | —             | —           | —             | —        |
| impl/_GotmAuthLocal.gd    | ☑      | 1     | N/A            | —             | —           | —             | —        |
| impl/_GotmBlob.gd         | ☑      | 1     | N/A            | —             | —           | —             | —        |
| impl/_GotmBlobLocal.gd    | ☑      | 1     | N/A            | —             | —           | —             | —        |
| impl/_GotmContent.gd      | ☑      | 1     | N/A            | —             | —           | —             | —        |
| impl/_GotmContentLocal.gd | ☑      | 0     | N/A            | —             | —           | —             | —        |
| impl/_GotmDebugImpl.gd    | Removed | —     | —              | —             | —           | —             | —        |
| impl/_GotmImpl.gd         | Removed | —     | —              | —             | —           | —             | —        |
| impl/_GotmImplUtility.gd  | Removed | —     | —              | —             | —           | —             | —        |
| impl/_GotmLeaderboard.gd  | ☑      | 1     | N/A            | —             | —           | —             | —        |
| impl/_GotmMark.gd         | ☑      | 0     | N/A            | —             | —           | —             | —        |
| impl/_GotmMarkLocal.gd    | ☑      | 0     | N/A            | —             | —           | —             | —        |
| impl/_GotmPeriod.gd       | ☑      | 0     | N/A            | —             | —           | —             | —        |
| impl/_GotmQuery.gd        | ☑      | 0     | N/A            | —             | —           | —             | —        |
| impl/_GotmScore.gd        | ☑      | 0     | N/A            | —             | —           | —             | —        |
| impl/_GotmScoreLocal.gd   | ☑      | 0     | N/A            | —             | —           | —             | —        |
| impl/_GotmStore.gd        | ☑      | 0     | N/A            | —             | —           | —             | —        |
| impl/_GotmUser.gd         | ☑      | 0     | N/A            | —             | —           | —             | —        |
| impl/_GotmUserLocal.gd    | Removed | —     | —              | —             | —           | —             | —        |
| impl/_GotmUtility.gd      | ☑      | 1     | N/A            | —             | —           | —             | —        |
| impl/_LocalStore.gd       | ☑      | 0     | N/A            | —             | —           | —             | —        |
| Gotm.gd                   | ☑      | 3     | —              | —             | —           | —             | —        |
| GotmAuth.gd               | ☑      | 0     | ☑              | —             | —           | ☑            | —        |
| GotmBlob.gd               | Removed | —     | —              | —             | —           | —             | —        |
| GotmConfig.gd             | ☑      | 0     | N/A            | —             | —           | ☑             | —        |
| GotmContent.gd            | ☑      | 2     | —              | —             | —           | Some          | —        |
| GotmDebug.gd              | Removed | —     | —              | —             | —           | —             | —        |
| GotmFile.gd               | Removed | —     | —              | —             | —           | —             | —        |
| GotmLeaderboard.gd        | ☑      | 0     | ☑              | —             | —           | Some          | —        |
| GotmLobby.gd              | Removed | —     | —              | —             | —           | —             | —        |
| GotmLobbyFetch.gd         | Removed | —     | —              | —             | —           | —             | —        |
| GotmMark.gd               | ☑      | 1     | —              | —             | —           | Some          | —        |
| GotmPeriod.gd             | ☑      | 0     | N/A            | —             | —           | ☑             | —        |
| GotmQuery.gd              | ☑      | 2     | —              | —             | —           | ☑             | —        |
| GotmScore.gd              | ☑      | 0     | ☑              | —             | —           | Some          | —        |
| GotmUser.gd               | ☑      | 0     | N/A            | —             | —           | ☑             | —        |