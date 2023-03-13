# Godot 4 Port Attempt

This is an attempt to port the current gotm plugin/addon.
Godot 4.0 recently released and the developers at gotm.io are currently trying to support it on their platform.
To accelerate the support with the plugin, and to personally get experince with the new gdscript language that has been overhauled, I decided to attempt porting the old plugin.

I will try to adhere to the official style guide here: https://docs.godotengine.org/en/4.0/tutorials/scripting/gdscript/gdscript_styleguide.html


## Process
| File Name                 | Status  | TODOs          | Reviewed | Unit Tested | Documentation |
| ------------------------- |:-------:| --------------:|:--------:|:-----------:|:-------------:|
| impl/_Gotm.gd             | ☑      | 2              | —        | —           | —             |
| impl/_GotmAuth.gd         | 0%      | 0              | —        | —           | —             |
| impl/_GotmAuthLocal.gd    | 0%      | 0              | —        | —           | —             |
| impl/_GotmBlob.gd         | 0%      | 0              | —        | —           | —             |
| impl/_GotmBlobLocal.gd    | 0%      | 0              | —        | —           | —             |
| impl/_GotmContent.gd      | 0%      | 0              | —        | —           | —             |
| impl/_GotmContentLocal.gd | 0%      | 0              | —        | —           | —             |
| impl/_GotmDebugImpl.gd    | 0%      | 0              | —        | —           | —             |
| impl/_GotmImpl.gd         | 0%      | 0              | —        | —           | —             |
| impl/_GotmImplUtility.gd  | Removed | 0              | —        | —           | —             |
| impl/_GotmLeaderboard.gd  | 0%      | 0              | —        | —           | —             |
| impl/_GotmMark.gd         | 0%      | 0              | —        | —           | —             |
| impl/_GotmMarkLocal.gd    | 0%      | 0              | —        | —           | —             |
| impl/_GotmPeriod.gd       | 0%      | 0              | —        | —           | —             |
| impl/_GotmQuery.gd        | 0%      | 0              | —        | —           | —             |
| impl/_GotmScore.gd        | 0%      | 0              | —        | —           | —             |
| impl/_GotmScoreLocal.gd   | 0%      | 0              | —        | —           | —             |
| impl/_GotmStore.gd        | 0%      | 0              | —        | —           | —             |
| impl/_GotmUser.gd         | 0%      | 0              | —        | —           | —             |
| impl/_GotmUserLocal.gd    | ☑      | 1              | —        | —           | —             |
| impl/_GotmUtility.gd      | 90%+    | 2              | —        | —           | —             |
| impl/_LocalStore.gd       | 0%      | 0              | —        | —           | —             |
| Gotm.gd                   | 0%      | 0              | —        | —           | —             |
| GotmAuth.gd               | 0%      | 0              | —        | —           | —             |    
| GotmBlob.gd               | 0%      | 0              | —        | —           | —             |
| GotmConfig.gd             | ☑      | 0              | CR       | N/A         | ☑             |
| GotmContent.gd            | 0%      | 0              | —        | —           | —             |
| GotmDebug.gd              | 0%      | 0              | —        | —           | —             |
| GotmFile.gd               | 0%      | 0              | —        | —           | —             |
| GotmLeaderboard.gd        | 0%      | 0              | —        | —           | —             |
| GotmLobby.gd              | 0%      | 0              | —        | —           | —             |
| GotmLobbyFetch.gd         | 0%      | 0              | —        | —           | —             |
| GotmMark.gd               | 0%      | 0              | —        | —           | —             |
| GotmPeriod.gd             | 0%      | 0              | —        | —           | —             |
| GotmQuery.gd              | 0%      | 0              | —        | —           | —             |
| GotmScore.gd              | 0%      | 0              | —        | —           | —             |
| GotmUser.gd               | 0%      | 0              | —        | —           | —             |
