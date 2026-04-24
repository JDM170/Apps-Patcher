<a href="https://github.com/JDM170/Morphe_Builder/actions"><img src="https://img.shields.io/github/actions/workflow/status/JDM170/Morphe_Builder/Build.yml?label=GitHub%20Actions&logo=GitHub"></a>

# Morphe builder
Build Morphe package (.apk) easily than ever using latest Morphe patches and dependencies locally or via cloud

## Usage

### Locally
* To build YouTube or Reddit locally you need just to run [`Build_Youtube.ps1`](https://github.com/JDM170/Morphe_Builder/blob/main/Build_Youtube.ps1) or [`Build_Reddit.ps1`](https://github.com/JDM170/Morphe_Builder/blob/main/Build_Reddit.ps1) via PowerShell;
* All patches except the followings applied to Youtube:
  * Custom branding
  * Change header
  * Shorts autoplay
  * Theme
  * Alternative thumbnails
* Script displays a link to download the latest supported version of the selected application from the [APKMirror](https://apkmirror.com) (latest compatible version is obtained from the patch list from the Morphe team) and all dependencies and build package using [Zulu JDK](https://www.azul.com/downloads/?package=jdk);
* Script does not install any applications - everything will be stored in the `Script Location\Morphe` folder;
* After compilation, you will receive the files of the selected application (`morphe-youtube.apk`, `microg.apk` - for YouTube, `reddit.apk` - for Reddit), ready for installation;

#### Requirements if you compile locally
* Windows 10 x64 or Windows 11
* Windows PowerShell 5.1
  * if you want to use PowerShell 7, you will have to install a 3rd party HTML parser ([AngleSharp](https://github.com/AngleSharp/AngleSharp))

### By using CI/CD
Trigger the [`Build`](https://github.com/JDM170/Morphe_Builder/actions/workflows/Build.yml) action manually to create [release page](https://github.com/JDM170/Morphe_Builder/releases/latest) with configured release notes showing dependencies used for building.

![image](https://user-images.githubusercontent.com/10544660/187949763-82fd7a07-8e4e-4527-b631-11920077141f.png)

Every 1st of the month, releases are created automatically according to the schedule.

Release notes are generated dynamically using the [ReleaseNotesTemplate.md](https://github.com/JDM170/ReVanced_Builder/blob/main/ReleaseNotesTemplate.md) template.

The release will contain two files:
`Youtube.zip` - `morphe-youtube.apk` and `microg.apk` - ready for installation/update.
`Reddit.apk` - ready for installation/update.

## Links
* [APKPure](https://apkpure.net)
* [APKMirror](https://apkmirror.com)
* [Morphe CLI](https://github.com/MorpheApp/morphe-cli)
* [Morphe Patches](https://github.com/MorpheApp/morphe-patches)
* [Morphe MicroG](https://github.com/MorpheApp/MicroG-RE)
* [AngleSharp](https://github.com/AngleSharp/AngleSharp)
* [Selenium](https://github.com/SeleniumHQ/selenium)
* [Zulu JDK](https://github.com/ScoopInstaller/Java)
