# Godot 4 Port

UPDATE: This has been merged with to the main branch, but alas, as of 6th of February 2024, gotm.io is no more. Thank you Mikael for your support and all the learning expierence. It has been fun while it lasted.

This is an attempt to port the current gotm plugin/addon.
Godot 4.0 recently released and the developers at gotm.io are currently trying to support it on their platform.
To accelerate the support with the plugin, and to personally get experince with the new gdscript language that has been overhauled, I decided to attempt porting the old plugin.

I will try to adhere to the official style guide here: https://docs.godotengine.org/en/4.0/tutorials/scripting/gdscript/gdscript_styleguide.html


## I want to try this plugin now

If you want to help with testing or can't wait for a completed plugin release, you simply clone/download the repository and copy the "addons" folder into your Godot 4 project, (TestSuite/addons). Optionally, you can enable the plugin in Project -> Project Settings -> Plugins for more functionality (i.e. Gotm Toolbar). To get an idea on how I use this plugin for testing, you can open up the project "TestSuite" in Godot 4.

NOTE: There are still bugs. Updates happen very frequent. Please refer to the progress below to see what is implemented. If you have any questions or feedback please reach out to me preferably through Gotm's Discord.


## Progress
| File Name                 | Status  | TODOs | Offline Tested | Online Tested | Unit Tested | Documentation | Reviewed |
| ------------------------- |:-------:| -----:|:--------------:|:-------------:|:-----------:|:-------------:|:--------:|
| impl/_Gotm.gd             | ☑      | 2     | N/A            | N/A           | —           | —             | —        |
| impl/_GotmAuth.gd         | ☑      | 0     | N/A            | N/A           | —           | —             | —        |
| impl/_GotmAuthLocal.gd    | ☑      | 1     | N/A            | N/A           | —           | —             | —        |
| impl/_GotmBlob.gd         | ☑      | 1     | N/A            | N/A           | —           | —             | —        |
| impl/_GotmBlobLocal.gd    | ☑      | 1     | N/A            | N/A           | —           | —             | —        |
| impl/_GotmContent.gd      | ☑      | 0     | N/A            | N/A           | —           | —             | —        |
| impl/_GotmContentLocal.gd | ☑      | 0     | N/A            | N/A           | —           | —             | —        |
| impl/_GotmDebugImpl.gd    | Removed | —     | —              | —             | —           | —             | —        |
| impl/_GotmImpl.gd         | Removed | —     | —              | —             | —           | —             | —        |
| impl/_GotmImplUtility.gd  | Removed | —     | —              | —             | —           | —             | —        |
| impl/_GotmLeaderboard.gd  | ☑      | 1     | N/A            | N/A           | —           | —             | —        |
| impl/_GotmMark.gd         | ☑      | 0     | N/A            | N/A           | —           | —             | —        |
| impl/_GotmMarkLocal.gd    | ☑      | 0     | N/A            | N/A           | —           | —             | —        |
| impl/_GotmPeriod.gd       | ☑      | 0     | N/A            | N/A           | —           | —             | —        |
| impl/_GotmQuery.gd        | ☑      | 0     | N/A            | N/A           | —           | —             | —        |
| impl/_GotmScore.gd        | ☑      | 0     | N/A            | N/A           | —           | —             | —        |
| impl/_GotmScoreLocal.gd   | ☑      | 0     | N/A            | N/A           | —           | —             | —        |
| impl/_GotmStore.gd        | ☑      | 0     | N/A            | N/A           | —           | —             | —        |
| impl/_GotmUser.gd         | ☑      | 0     | N/A            | N/A           | —           | —             | —        |
| impl/_GotmUserLocal.gd    | Removed | —     | —              | —             | —           | —             | —        |
| impl/_GotmUtility.gd      | ☑      | 1     | N/A            | N/A           | —           | —             | —        |
| impl/_LocalStore.gd       | ☑      | 0     | N/A            | N/A           | —           | —             | —        |
| Gotm.gd                   | ☑      | 3     | —              | —             | —           | —             | —        |
| GotmAuth.gd               | ☑      | 0     | ☑              | —             | —           | ☑            | —        |
| GotmBlob.gd               | Removed | —     | —              | —             | —           | —             | —        |
| GotmConfig.gd             | ☑      | 0     | N/A            | N/A           | —           | ☑             | —        |
| GotmContent.gd            | ☑      | 2     | ☑              | ☑            | —           | Some          | —        |
| GotmDebug.gd              | Removed | —     | —              | —             | —           | —             | —        |
| GotmFile.gd               | Removed | —     | —              | —             | —           | —             | —        |
| GotmLeaderboard.gd        | ☑      | 0     | ☑              | ☑            | —           | Some          | —        |
| GotmLobby.gd              | Removed | —     | —              | —             | —           | —             | —        |
| GotmLobbyFetch.gd         | Removed | —     | —              | —             | —           | —             | —        |
| GotmMark.gd               | ☑      | 1     | —              | —             | —           | Some          | —        |
| GotmPeriod.gd             | ☑      | 0     | N/A            | N/A           | —           | ☑             | —        |
| GotmQuery.gd              | ☑      | 2     | N/A            | N/A           | —           | ☑             | —        |
| GotmScore.gd              | ☑      | 0     | ☑              | ☑            | —           | Some          | —        |
| GotmUser.gd               | ☑      | 0     | N/A            | —             | —           | ☑             | —        |
