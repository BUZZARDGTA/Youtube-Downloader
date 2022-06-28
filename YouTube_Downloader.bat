::------------------------------------------------------------------------------
:: NAME
::     YouTube_Downloader.bat - YouTube Downloader
::
:: DESCRIPTION
::     Download videos from youtube.com or other video platforms.
::
:: AUTHOR
::     IB_U_Z_Z_A_R_Dl
::
::     A project created in the "server.bat" Discord: https://discord.gg/GSVrHag
::------------------------------------------------------------------------------
@echo off
cls

setlocal DisableDelayedExpansion
for /f "tokens=2delims=:." %%A in ('2^>nul chcp') do (
    set /a "CP=%%A"
)
>nul chcp 65001
pushd "%~dp0"
for /f %%A in ('forfiles /m "%~nx0" /c "cmd /c echo 0x1B"') do (
    set "\E=%%A"
)
(set \N=^
%=leave unchanged=%
)
set @DISP_HEAD=^
echo !BRIGHTBLACK!Welcome in !RED!!UNDERLINE!YouTube Downloader!UNDERLINEOFF!!BRIGHTBLACK! by IB_U_Z_Z_A_R_Dl, greetz to server.bat ^^(https://discord.gg/GSVrHag^^)!WHITE!!\N!The script detects all available resolutions, then asks the user in which resolution he wishes to download.!WHITE!!\N!!WHITE!Type anytime !BRIGHTMAGENTA![EXIT]!WHITE! / !BRIGHTMAGENTA![BACK]!WHITE! / !BRIGHTMAGENTA![CTRL+C]!WHITE! for their according behaviour in the script.!WHITE!!\N!!WHITE!Selected file extension output: !BRIGHTBLUE![VIDEO:!FORMAT_VIDEO!]!WHITE! ^^^| !BRIGHTBLUE![AUDIO:!FORMAT_AUDIO!]!WHITE!!\N!!infos_head!
set @STRIP_WHITE_SPACES=^
(for %%a in (4096 2048 1024 512 256 128 64 32 16 8 4 2 1) do (^
    (set "_s=!?:~0,%%a!"^&^
    if "!_s: =!"==""^
        set^^ ?=!?:~%%a!)^&^
    (set "_s=!?:~-%%a!"^&^
    if "!_s: =!"==""^
        set^^ ?=!?:~0,-%%a!)^
))^&^
set _s=
setlocal EnableDelayedExpansion

call :GET_DATE_TIME

set VERSION_CURRENT=v1.0.1 - 28/06/2022
set VERSION_SUPPORTED_YT_DLP=2022.06.22.1
:: yt-dlp settings:
:: The arguments that are always going to be triggered for any downloads:
set YT_DLP_BASE_ARGUMENTS=--console-title --force-overwrites --geo-bypass --add-metadata
:: Leaving a FORMAT undefined will keep the original downloaded file.
:: Supported FORMATS are:
set ITER[SUPPORTED_FORMATS_VIDEO]=mp4 mkv flv webm mov avi mka ogg aac flac mp3 m4a opus vorbis wav alac
set FORMAT_VIDEO=mp4
:: Supported FORMATS are:
set ITER[SUPPORTED_FORMATS_AUDIO]=best aac flac mp3 m4a opus vorbis wav alac
set FORMAT_AUDIO=mp3
:: Supported FORMATS are:
set ITER[SUPPORTED_FORMATS_SUBTITLE]=srt vtt ass lrc
set FORMAT_SUBTITLE=
:: Supported FORMATS are:
set ITER[SUPPORTED_FORMATS_THUMBNAIL]=jpg png webp
set FORMAT_THUMBNAIL=
:: The output template, see: https://github.com/yt-dlp/yt-dlp#output-template
set "OUTPUT_TEMPLATE=%%(id)s\%%(title)s.%%(ext)s"
:: Folder or PATH where yt-dlp will extract the downloaded files.
set "OUTPUT_TEMPLATE=output\[!DATE_TIME!].!OUTPUT_TEMPLATE!"

for /f "tokens=4,5delims=. " %%A in ('ver') do (
    if "%%A.%%B"=="10.0" (
        for %%C in (UNDERLINE`4 UNDERLINEOFF`24 RED`31 GREEN`32 YELLOW`33 CYAN`36 BRIGHTBLACK`90 BRIGHTBLUE`94 BRIGHTMAGENTA`95 BRIGHTWHITE`97 WHITE`37) do (
            for /f "tokens=1,2delims=`" %%D in ("%%C") do (
                set %%D=!\E![%%Em
            )
        )
    )
)

%@DISP_HEAD%

if defined ProgramFiles(x86) (
    set ARCH=64
) else (
    set ARCH=86
)
for %%A in (yt-dlp.exe ffmpeg.exe ffprobe.exe) do (
    if %%A==yt-dlp.exe (
        if !ARCH!==64 (
            set %%A=lib\yt-dlp.exe
        ) else (
            set %%A=lib\yt-dlp_x86.exe
        )
    ) else (
        set %%A=lib\%%A
    )
)
if defined file_not_found (
    set file_not_found=
)
for %%A in (!yt-dlp.exe! !ffmpeg.exe! !ffprobe.exe! choice.exe findstr.exe) do (
    >nul 2>&1 where %%A || (
        if %%A==choice.exe (
            set file_not_found=1
        ) else if %%A==findstr.exe (
            set file_not_found=1
        ) else (
            if not exist %%A (
                set file_not_found=1
            )
        )
        if defined file_not_found (
            echo:
            echo !RED!ERROR:!WHITE! "%%A" not found in your system PATH.
            goto :END
        )
    )
)

echo:
echo Searching for a new update ...
call :UPDATER || (
    echo !RED!ERROR:!WHITE! Failed updating. Try updating manually:
    echo https://github.com/Illegal-Services/Youtube-Downloader
    echo:
    <nul set /p=Press {ANY KEY} to continue ...
    >nul pause
    cls
    %@DISP_HEAD%
)

for /f "delims=" %%A in ('!yt-dlp.exe! --version') do (
    if not "%%A"=="!VERSION_SUPPORTED_YT_DLP!" (
        echo !YELLOW!WARNING:!WHITE! You are not using the recommended !yt-dlp.exe! v!VERSION_SUPPORTED_YT_DLP!!WHITE!
        echo:
        <nul set /p=!WHITE!Press !BRIGHTMAGENTA!{ANY KEY}!WHITE! to ignore ...
        >nul pause
    )
)
for %%A in (
    "timeout.exe`>nul timeout /t ?"
    "PING.EXE`>nul ping -n ? -l 0 -w 1000 127.0.0.1"
) do (
    for /f "tokens=1,2delims=`" %%B in ("%%~A") do (
        >nul 2>&1 where %%B && (
            >nul 2>&1 %%B /? && (
                set "@sleep=%%C"
                goto :GENERATE_CUSTOM_USER_MACRO_SETTINGS
            )
        )
    )
)
if not defined @sleep (
    set @sleep=for /l %%. in ^(1,1,?000000^) do rem
)
:GENERATE_CUSTOM_USER_MACRO_SETTINGS
if defined YT_DLP_BASE_ARGUMENTS (
    set "@yt_dlp_base_arguments= !YT_DLP_BASE_ARGUMENTS!"
) else (
    set @yt_dlp_base_arguments=
)
set array[1]="FORMAT_VIDEO`VIDEO`@format_video`--merge-output-format !FORMAT_VIDEO! --recode-video !FORMAT_VIDEO!"
set array[2]="FORMAT_AUDIO`AUDIO`@format_audio`--audio-format !FORMAT_AUDIO!"
set array[3]="FORMAT_SUBTITLE`SUBTITLE`@format_subtitle`--convert-subs !FORMAT_SUBTITLE!"
set array[4]="FORMAT_THUMBNAIL`THUMBNAIL`@format_thumbnail`--convert-thumbnails !FORMAT_THUMBNAIL!"
set array[#]=4
for /l %%A in (1,1,!array[#]!) do (
    if defined valid_format (
        set valid_format=
    )
    for /f "tokens=1-4delims=`" %%B in (!array[%%A]!) do (
        if defined %%B (
            set "%%B=!%%B:"=!"
            if defined %%B (
                for %%F in (!ITER[SUPPORTED_FORMATS_%%C]!) do (
                    if not defined valid_format (
                        if /i "%%F"=="!%%B!" (
                            set valid_format=1
                            set "%%D=%%E"
                        )
                    )
                )
            )
        )
        if not defined valid_format (
            if defined %%D (
                set %%D=
            )
        )
    )
    set array[%%A]=
)
if defined valid_format (
    set valid_format=
)
set array[#]=

:PROMPT_URL
cls
for %%A in (playlist_url[ line[) do (
    for /f "delims==" %%B in ('2^>nul set %%A') do (
        if defined %%B (
            set %%B=
        )
    )
)
for %%A in (infos_head stder_stream playlist_item_counter input_url download_url) do (
    if defined %%A (
        set %%A=
    )
)
%@DISP_HEAD%
echo:
set /p "input_url=!WHITE!Enter an URL: !BRIGHTMAGENTA!"
if defined input_url (
    set "input_url=!input_url:"=!"
)
if not defined input_url (
    goto :PROMPT_URL
)
if /i "!input_url!"=="EXIT" (
    goto :_END
) else if /i "!input_url!"=="BACK" (
    echo:
    echo !RED!ERROR:!WHITE! Function "[BACK]" is not supported in the script root.
    %@sleep:?=3%
    goto :PROMPT_URL
)
echo:
echo !WHITE!Retrieving yt-dlp playlist URLs from URL ...
echo:
set first=1
:: Searching manually STDER error streams because yt-dlp contributor @pukkandan doesn't want to add a correct method for it. (https://github.com/yt-dlp/yt-dlp/issues/3792)
for /f "delims=" %%A in ('2^>^&1 !yt-dlp.exe! --console-title -v --simulate --get-url --yes-playlist --flat-playlist "!input_url!" ^| findstr /brc:"\[download\] Downloading playlist:" /c:"https*:\/\/" /c:"ERROR:"') do (
    set "line=%%A"
    if defined first (
        set first=
        if /i "!line:~0,32!"=="[download] Downloading playlist:" (
            set /a playlist_url[#]=0, playlist_item_counter=1
        )
    ) else (
        if defined playlist_url[#] (
            if /i "!line:~0,4!"=="http" (
                if /i not "!line:~0,6!"=="httpss" (
                    set /a playlist_url[#]+=1
                    set "playlist_url[!playlist_url[#]!]=%%A"
                )
            )
        )
    )
    if "!line:~0,6!"=="ERROR:" (
        set "stder_stream=%%A"
    )
)
if defined stder_stream (
    echo !RED!ERROR:!WHITE!!stder_stream:~6!!WHITE!
    call :ERROR_YT_DLP playlist
    goto :PROMPT_URL
)
if defined playlist_url[#] (
    if !playlist_url[#]!==0 (
        for %%A in (playlist_url[#] playlist_item_counter) do (
            set %%A=
        )
    ) else (
        set "download_url=!playlist_url[1]!"
    )
)
if not defined download_url (
    set "download_url=!input_url!"
)
:RETRIEVE_URL_FORMATS
echo !WHITE!Retrieving yt-dlp formats from URL ...
echo:
for %%A in (header_description[ line_format[ line_subtitle[ line_thumbnail[) do (
    for /f "delims==" %%B in ('2^>nul set %%A') do (
        if defined %%B (
            set %%B=
        )
    )
)
for %%A in (_errorlevel iter_resolution_order found_thumbnail found_subtitle found_format) do (
    if defined %%A (
        set %%A=
    )
)
for /f "tokens=1-26" %%A in ('!yt-dlp.exe! --console-title --quiet --list-thumbnails --list-subs --list-formats "!download_url!" ^& call echo %%^^^^errorlevel%%') do (
    set "line=%%A %%B %%C %%D %%E %%F %%G %%H %%I %%J %%K %%L %%M %%N %%O %%P %%Q %%R %%S %%T %%U %%V %%W %%X %%Y %%Z"
    %@STRIP_WHITE_SPACES:?=line%
    if defined line (
        if /i "%%A %%B %%C %%D"=="ID Width Height URL" (
            for %%1 in (found_subtitle found_format) do (
                if defined %%1 (
                    set %%1=
                )
            )
            set found_thumbnail=1
            set "header_description[thumbnail]=!line!"
        ) else if /i "%%A %%B %%C"=="Language Name Formats" (
            for %%1 in (found_thumbnail found_format) do (
                if defined %%1 (
                    set %%1=
                )
            )
            set found_subtitle=1
            set "header_description[subtitle]=!line!"
        ) else if /i "%%A %%B"=="Language Formats" (
            for %%1 in (found_thumbnail found_format) do (
                if defined %%1 (
                    set %%1=
                )
            )
            set found_subtitle=1
            set "header_description[subtitle]=!line!"
        ) else if /i "%%A %%B %%C"=="ID EXT RESOLUTION" (
            for %%1 in (found_thumbnail found_subtitle) do (
                if defined %%1 (
                    set %%1=
                )
            )
            set found_format=1
            set "header_description[format]=!line!"
        ) else if "%%B"=="" (
            set "_errorlevel=%%A"
        ) else (
            if defined found_thumbnail (
                set /a line_thumbnail[#]+=1
                set "line_thumbnail[!line_thumbnail[#]!]=!line!"
            ) else if defined found_subtitle (
                set /a line_subtitle[#]+=1
                set "line_subtitle[!line_subtitle[#]!]=!line!"
            ) else if defined found_format (
                set /a line_format[#]+=1
                set "line_format[!line_format[#]!]=!line!"
                if /i "%%C %%D"=="audio only" (
                    if defined iter_resolution_order (
                        if "!iter_resolution_order:`%%C %%D`=!"=="!iter_resolution_order!" (
                            set "iter_resolution_order=`%%C %%D` !iter_resolution_order!"
                        )
                    ) else (
                        set "iter_resolution_order=`%%C %%D` !iter_resolution_order!"
                    )
                    set "line_format_resolution[%%C %%D]=!line!"
                ) else (
                    if defined iter_resolution_order (
                        if "!iter_resolution_order:`%%C`=!"=="!iter_resolution_order!" (
                            set "iter_resolution_order=`%%C` !iter_resolution_order!"
                        )
                    ) else (
                        set "iter_resolution_order=`%%C` !iter_resolution_order!"
                    )
                    set "line_format_resolution[%%C]=!line!"
                )
            )
        )
    )
)
call :CHECK_NUMBER _errorlevel || (
    set _errorlevel=
)
if defined _errorlevel (
    if !_errorlevel!==0 (
        >nul 2>&1 set header_description[ && (
            if defined iter_resolution_order (
                set "iter_resolution_order=!iter_resolution_order:`="!"
                goto :CHOOSE_RESOLUTION
            ) else if defined line_subtitle[1] (
                goto :CHOOSE_RESOLUTION
            ) else if defined line_thumbnail[1] (
                goto :CHOOSE_RESOLUTION
            )
        )
    )
)
call :ERROR_YT_DLP format
goto :PROMPT_URL
:CHOOSE_RESOLUTION
cls
:: In a future update, try to set this somewhere else so that it get skipped when not needed. (these only need to really be triggered when a download start)
for %%A in (@arguments id) do (
    if defined %%A (
        set %%A=
    )
)
if defined playlist_url[#] (
    set "infos_head=!WHITE!Infos: !BRIGHTBLUE![URL: !download_url!]!WHITE! | !BRIGHTBLUE![Playlist:!playlist_item_counter!/!playlist_url[#]!]!WHITE!!\N!"
) else (
    set "infos_head=!WHITE!Infos: !BRIGHTBLUE![URL: !download_url!]!WHITE! | !BRIGHTBLUE![Playlist:1/1]!WHITE!!\N!"
)
%@DISP_HEAD%
echo Choose a resolution:
:: In a future update, cache all of this results in a one time setup, in order to save time in retries.
for %%A in (task[ line[) do (
    for /f "delims==" %%B in ('2^>nul set %%A') do (
        if defined %%B (
            set %%B=
        )
    )
)
set counter[#]=0
for %%A in (thumbnail subtitle format video audio image) do (
    set first[%%A]=1
)
for /l %%A in (1,1,!line_thumbnail[#]!) do (
    if defined first[thumbnail] (
        set first[thumbnail]=
        echo:
        echo !CYAN!ALL available [thumbnail] formats:!WHITE!
        echo     !header_description[thumbnail]!
    )
    set /a counter[#]+=1
    set task[!counter[#]!]=thumbnail
    set "line[!counter[#]!]=!line_thumbnail[%%A]!"
    echo !BRIGHTMAGENTA!!counter[#]!!WHITE!. !line_thumbnail[%%A]!
)
for /l %%A in (1,1,!line_subtitle[#]!) do (
    if defined first[subtitle] (
        set first[subtitle]=
        echo:
        echo !CYAN!ALL available [subtitle] formats:!WHITE!
        echo     !header_description[subtitle]!
    )
    set /a counter[#]+=1
    set task[!counter[#]!]=subtitle
    set "line[!counter[#]!]=!line_subtitle[%%A]!"
    echo !BRIGHTMAGENTA!!counter[#]!!WHITE!. !line_subtitle[%%A]!
)
for /l %%A in (1,1,!line_format[#]!) do (
    if defined first[format] (
        set first[format]=
        echo:
        echo !CYAN!ALL available [format] formats:!WHITE!
        echo     !header_description[format]!
    )
    set /a counter[#]+=1
    set task[!counter[#]!]=format
    set "line[!counter[#]!]=!line_format[%%A]!"
    echo !BRIGHTMAGENTA!!counter[#]!!WHITE!. !line_format[%%A]!
)
for %%A in (!iter_resolution_order!) do (
    for /f "delims=" %%B in ("!line_format_resolution[%%~A]!") do (
        set "line=%%B"
        call :RESOLVE_FORMAT_IS_IMAGE_OR_VIDEO_OR_AUDIO || (
            if !errorlevel!==1 (
                if defined first[video] (
                    set first[video]=
                    echo:
                    echo !CYAN!BEST available [video]+[audio] formats:!WHITE!
                    echo     !header_description[format]!
                )
                set /a counter[#]+=1
                set task[!counter[#]!]=format`video
                set "line[!counter[#]!]=%%B"
                echo !BRIGHTMAGENTA!!counter[#]!!WHITE!. %%B
            ) else if !errorlevel!==2 (
                if defined first[audio] (
                    set first[audio]=
                    echo:
                    echo !CYAN!BEST available [audio]+[video] formats:!WHITE!
                    echo     !header_description[format]!
                )
                set /a counter[#]+=1
                set task[!counter[#]!]=format`audio
                set "line[!counter[#]!]=%%B"
                echo !BRIGHTMAGENTA!!counter[#]!!WHITE!. %%B
            ) else if !errorlevel!==3 (
                if defined first[image] (
                    set first[image]=
                    echo:
                    echo !CYAN!BEST available [image] formats:!WHITE!
                    echo     !header_description[format]!
                )
                set /a counter[#]+=1
                set task[!counter[#]!]=format`image
                set "line[!counter[#]!]=%%B"
                echo !BRIGHTMAGENTA!!counter[#]!!WHITE!. %%B
            )
        )
    )
)
echo:
:: add a detection so only possible stuff get displayed here.
echo !CYAN!OR, you can also choose one of this preset:!WHITE!
echo !BRIGHTMAGENTA!A!WHITE!. ^> Video (only best video) (beta)
echo !BRIGHTMAGENTA!B!WHITE!. ^> Audio (only best audio) (ideal for music downloading)
echo !BRIGHTMAGENTA!C!WHITE!. ^> Subtitles (only all subtitles)
echo !BRIGHTMAGENTA!D!WHITE!. ^> Image (only all images)
echo !BRIGHTMAGENTA!E!WHITE!. ^> Live (only live) (experimental)
echo:
echo !BRIGHTMAGENTA!REFRESH!WHITE! ^> Refresh the format and resolution list.
echo:
if defined input_resolution (
    set input_resolution=
)
set /p "input_resolution=!WHITE!Select your desired resolution ([!BRIGHTMAGENTA!1!WHITE!,!BRIGHTMAGENTA!1!WHITE!,!BRIGHTMAGENTA!!counter[#]!!WHITE!] / [!BRIGHTMAGENTA!A!WHITE!-!BRIGHTMAGENTA!E!WHITE!] / [!BRIGHTMAGENTA!REFRESH!WHITE!]): !BRIGHTMAGENTA!"
if /i "!input_resolution!"=="BACK" (
    goto :PROMPT_URL
) else if /i "!input_resolution!"=="EXIT" (
    goto :_END
) else if /i "!input_resolution!"=="REFRESH" (
    echo:
    goto :RETRIEVE_URL_FORMATS
)
for /l %%A in (1,1,!counter[#]!) do (
    if "%%A"=="!input_resolution!" (
        if !task[%%A]!==thumbnail (
            goto :DOWNLOAD[THUMBNAIL]
        ) else if !task[%%A]!==subtitle (
            goto :DOWNLOAD[SUBTITLE]
        ) else if !task[%%A]!==format (
            goto :DOWNLOAD[FORMAT]
        ) else if !task[%%A]!==format`video (
            goto :DOWNLOAD[FORMAT`VIDEO]
        ) else if !task[%%A]!==format`audio (
            goto :DOWNLOAD[FORMAT`AUDIO]
        ) else if !task[%%A]!==format`image (
            goto :DOWNLOAD[FORMAT`IMAGE]
        )
    )
)
for %%A in (A B C D E) do (
    if /i "%%A"=="!input_resolution!" (
        if %%A==A  (
            goto :DOWNLOAD[ONLY_VIDEO]
        ) else if %%A==B  (
            goto :DOWNLOAD[ONLY_AUDIO]
        ) else if %%A==C  (
            goto :DOWNLOAD[ONLY_SUBTITLE]
        ) else if %%A==D  (
            goto :DOWNLOAD[ONLY_IMAGE]
        ) else if %%A==E  (
            goto :DOWNLOAD[ONLY_LIVE]
        )
    )
)
goto :CHOOSE_RESOLUTION
:DOWNLOAD_FINISHED
if defined download_folder (
    set download_folder=
)
for /f "delims=" %%A in ('2^>nul dir "output\" /a:d /b /o:d') do (
    set "download_folder=output\%%A"
)
if defined download_folder (
    if exist "!download_folder!\" (
        start "" "!download_folder!\"
    )
)
if defined playlist_url[#] (
    if !playlist_item_counter! lss !playlist_url[#]! (
        set /a playlist_item_counter+=1
        for %%A in (!playlist_item_counter!) do (
            set "download_url=!playlist_url[%%A]!"
        )
        goto :RETRIEVE_URL_FORMATS
    )
)
echo:
:LOOP_CHOICE_DOWNLOAD_FINISHED
<nul set /p=!WHITE!Do you want to go Back in the resolution menu (!BRIGHTMAGENTA!B!WHITE!) or give a New URL (!BRIGHTMAGENTA!N!WHITE!) ?
choice /n /c BN
if !errorlevel!==1 (
    goto :CHOOSE_RESOLUTION
) else if !errorlevel!==2 (
    goto :PROMPT_URL
)
goto :LOOP_CHOICE_DOWNLOAD_FINISHED

:DOWNLOAD[THUMBNAIL]
for /f %%A in ("!line[%input_resolution%]!") do (
    set "id=%%A"
    set @arguments=--format "!id!" !@format_thumbnail!
    call :DOWNLOAD_START
)
goto :DOWNLOAD_FINISHED

:DOWNLOAD[SUBTITLE]
for /f %%A in ("!line[%input_resolution%]!") do (
    set "id=%%A"
    set @arguments=--format "!id!" !@format_subtitle!
    call :DOWNLOAD_START
)
goto :DOWNLOAD_FINISHED

:DOWNLOAD[FORMAT]
for /f %%A in ("!line[%input_resolution%]!") do (
    set "id=%%A"
    set @arguments=--format "!id!"
    call :DOWNLOAD_START
)
goto :DOWNLOAD_FINISHED

:DOWNLOAD[FORMAT`VIDEO]
for /f %%A in ("!line[%input_resolution%]!") do (
    set "id=%%A"
    set @arguments=--format "!id!+(ba/(bv/b))" --video-multistreams --audio-multistreams !@format_video!
    call :DOWNLOAD_START
)
goto :DOWNLOAD_FINISHED

:DOWNLOAD[FORMAT`AUDIO]
for /f %%A in ("!line[%input_resolution%]!") do (
    set "id=%%A"
    set @arguments=--format "!id!+(bv/b)" --video-multistreams --audio-multistreams !@format_video!
    call :DOWNLOAD_START
)
goto :DOWNLOAD_FINISHED

:DOWNLOAD[FORMAT`IMAGE]
for /f %%A in ("!line[%input_resolution%]!") do (
    set "id=%%A"
    set @arguments=--format "!id!" !@format_thumbnail!
    call :DOWNLOAD_START
)
goto :DOWNLOAD_FINISHED

:DOWNLOAD[ONLY_VIDEO]
set @arguments=--format "bv" !@format_video!
call :DOWNLOAD_START
goto :DOWNLOAD_FINISHED

:DOWNLOAD[ONLY_AUDIO]
set @arguments=--extract-audio --audio-quality 0 !@format_audio!
call :DOWNLOAD_START
goto :DOWNLOAD_FINISHED

:DOWNLOAD[ONLY_SUBTITLE]
set @arguments=--skip-download --sub-langs all --write-subs --write-auto-subs !@format_subtitle!
call :DOWNLOAD_START
goto :DOWNLOAD_FINISHED

:DOWNLOAD[ONLY_IMAGE]
:: Need a FIX because duplicate files are overwritting, my understanding is that it can't be done the way I want using yt-dlp.
set @arguments=--skip-download --write-thumbnail --write-all-thumbnails !@format_thumbnail!
call :DOWNLOAD_START
for /f "tokens=1,2delims==" %%A in ('2^>nul set task[') do (
    if "%%B"=="format`image" (
        for /f "tokens=2delims=[]" %%C in ("%%A") do (
            for /f %%D in ("!line[%%C]!") do (
                set @arguments=-f "%%D"
                call :DOWNLOAD_START
            )
        )
    )
)
goto :DOWNLOAD_FINISHED

:DOWNLOAD[ONLY_LIVE]
set @arguments=--live-from-start --hls-use-mpegts --sub-langs live_chat --write-subs --write-auto-subs !@format_subtitle!
call :DOWNLOAD_START
goto :DOWNLOAD_FINISHED

:ERROR_DOWNLOADING
echo:
echo !RED!ERROR:!WHITE! Something went wrong while downloading the file.
echo !YELLOW!DEBUG:!WHITE!
for %%A in (input_url download_url) do (
    echo %%A=!%%A!
)
for /l %%A in (1,1,!counter[#]!) do (
    echo task[%%A]=!task[%%A]!
)
for %%A in (input_resolution id @arguments) do (
    if %%A==id (
        if defined id (
            echo %%A=!%%A!
        )
    ) else (
        echo %%A=!%%A!
    )
)
echo:
<nul set /p=!WHITE!Press !BRIGHTMAGENTA!{ANY KEY}!WHITE! to continue ...
>nul pause
goto :CHOOSE_RESOLUTION

:END
<nul set /p=!WHITE!Press !BRIGHTMAGENTA!{ANY KEY}!WHITE! to exit ...
>nul pause
:_END
<nul set /p=!\E![0m
popd
>nul chcp !CP!
endlocal
exit /b 0

:ERROR_YT_DLP
echo:
echo !RED!ERROR:!WHITE! yt-dlp did not found any %1 on URL.
echo:
<nul set /p=!WHITE!Press !BRIGHTMAGENTA!{ANY KEY}!WHITE! to continue ...
>nul pause
exit /b

:DOWNLOAD_START
if defined @arguments (
    set "@arguments=  !@arguments!"
    call :STRIP_DOUBLE_SPACES @arguments
)
echo !WHITE!
!yt-dlp.exe!!@yt_dlp_base_arguments!!@arguments! --output "!OUTPUT_TEMPLATE!" "!download_url!" || (
    goto :ERROR_DOWNLOADING
)
exit /b

:RESOLVE_FORMAT_IS_IMAGE_OR_VIDEO_OR_AUDIO
if not "!line:|=!"=="!line!" (
    set "line=!line:*|=!"
    if defined line (
        set "line=!line:*|=!"
        if defined line (
            for /f "tokens=1,2" %%A in ("!line!") do (
                %= leaving some placeholder formats in case they are added in the future development of yt-dlp =%
                %= same for unsensitive search =%
                if /i "%%A %%B"=="video only" (
                    exit /b 1
                ) else if /i "%%A %%B"=="videos only" (
                    exit /b 1
                ) else if /i "%%A %%B"=="audio only" (
                    exit /b 2
                ) else if /i "%%A %%B"=="audios only" (
                    exit /b 2
                ) else if /i "%%A"=="video" (
                    exit /b 1
                ) else if /i "%%A"=="videos" (
                    exit /b 1
                ) else if /i "%%A"=="audio" (
                    exit /b 2
                ) else if /i "%%A"=="audios" (
                    exit /b 2
                ) else if /i "%%A"=="images" (
                    exit /b 3
                ) else if /i "%%A"=="unknown" (
                    %= leaving this like that for now, but I should resolve it's 'EXT' to try a true detection =%
                    exit /b 1
                ) else (
                    exit /b 1
                )
            )
        )
    )
)
exit /b 0

:CHECK_NUMBER
set data=%1
if "!data:~0,1!!data:~-1!"=="""" (
set "data=%~1"
) else set "data=!%1!"
if not defined data exit /b 1
for /f "delims=0123456789" %%A in ("!data!") do exit /b 1
exit /b 0

:STRIP_DOUBLE_SPACES
if "!%1:  =!"=="!%1!" (
    exit /b
) else (
    set "%1=!%1:  = !"
)
goto :STRIP_DOUBLE_SPACES

:GET_DATE_TIME
if defined date_time (
    set date_time=
)
for /f "tokens=2delims==." %%A in ('2^>nul wmic os get Localdatetime /value') do (
    set "date_time=%%A"
    set "date_time=!date_time:~0,-10!-!date_time:~-10,2!-!date_time:~-8,2!_!date_time:~-6,2!-!date_time:~-4,2!-!date_time:~-2,2!"
)
call :CHECK_DATE_TIME date_time && (
    exit /b 0
)
if defined powershell (
    if defined date_time (
        set date_time=
    )
    for /f "delims=" %%A in (
        '^>nul chcp 437^& 2^>nul powershell get-date -format "yyyy-MM-dd_HH-mm-ss"^& ^>nul chcp 65001'
    ) do (
        set "date_time=%%A"
    )
    call :CHECK_DATE_TIME date_time && (
        exit /b 0
    )
)
call :ERROR_FATAL DATE_TIME

:CHECK_DATE_TIME
if not defined %1 (
    exit /b 1
)
if not "!%1:~-15,1!"=="-" (
    exit /b 1
)
if not "!%1:~-12,1!"=="-" (
    exit /b 1
)
if not "!%1:~-9,1!"=="_" (
    exit /b 1
)
if not "!%1:~-6,1!"=="-" (
    exit /b 1
)
if not "!%1:~-3,1!"=="-" (
    exit /b 1
)
for /f "delims=0123456789-_" %%A in ("!%1!") do (
    exit /b 1
)
for /f "tokens=1-6delims=-_" %%A in ("!%1!") do (
    call :CHECK_NUMBER "%%A" && (
        if "%%B"=="01" (
            set y1=31
        ) else if "%%B"=="02" (
            set "years=%%A"
            call :IS_LEAP_YEAR_OR_NOT
            if !leap!==1 (
                set y1=29
            ) else (
                set y1=28
            )
        ) else if "%%B"=="03" (
            set y1=31
        ) else if "%%B"=="04" (
            set y1=30
        ) else if "%%B"=="05" (
            set y1=31
        ) else if "%%B"=="06" (
            set y1=30
        ) else if "%%B"=="07" (
            set y1=31
        ) else if "%%B"=="08" (
            set y1=31
        ) else if "%%B"=="09" (
            set y1=30
        ) else if "%%B"=="10" (
            set y1=31
        ) else if "%%B"=="11" (
            set y1=30
        ) else if "%%B"=="12" (
            set y1=31
        )
        if defined y1 (
            call :CHECK_NUMBER_BETWEEN_CUSTOM "%%C" 01-!y1! && (
                call :CHECK_NUMBER_BETWEEN_CUSTOM "%%D" 00-23 && (
                    call :CHECK_NUMBER_BETWEEN_CUSTOM "%%E" 00-59 && (
                        call :CHECK_NUMBER_BETWEEN_CUSTOM "%%F" 00-59 && (
                            exit /b 0
                        )
                    )
                )
            )
        )
    )
)
exit /b 1

:CHECK_NUMBER_BETWEEN_CUSTOM
if "%~1"=="" exit /b 1
for /f "delims=0123456789" %%A in ("%~1") do exit /b 1
for /f "tokens=1,2delims=-" %%A in ("%~2") do (
    if %~1 lss %%A exit /b 1
    if %~1 gtr %%B exit /b 1
)
exit /b 0

:IS_LEAP_YEAR_OR_NOT
::https://stackoverflow.com/questions/35157817/batch-file-leap-year
set /a "leap=^!(years%%4) + (^!^!(years%%100)-^!^!(years%%400))"
exit /b

:UPDATER
for /f "delims=" %%A in ('curl.exe -fks "https://raw.githubusercontent.com/Illegal-Services/Youtube-Downloader/version/version.txt"') do (
    set "version_last=%%~A"
    goto :JUMP_UPDATER
)
:JUMP_UPDATER
if not defined version_last (
    exit /b 1
)
if "!VERSION_CURRENT:~1,5!" geq "!version_last:~1,5!" (
    exit /b 0
)
echo New version found. Do you want to update?
echo:
echo Current version: !VERSION_CURRENT!
echo Latest version : !version_last!
echo:
<nul set /p="!WHITE!Yes (!BRIGHTMAGENTA!Y!WHITE!) / No (!BRIGHTMAGENTA!N!WHITE!): !BRIGHTMAGENTA!"
choice /n /c YN
if not !errorlevel!==1 (
    exit /b 0
)
if exist "[UPDATED]_YouTube_Downloader.bat" (
    del /f /q /a "[UPDATED]_YouTube_Downloader.bat" || (
        exit /b 1
    )
)
curl.exe -f#ko "[UPDATED]_YouTube_Downloader.bat" "https://raw.githubusercontent.com/Illegal-Services/Youtube-Downloader/main/YouTube_Downloader.bat" && (
    >nul move /y "[UPDATED]_YouTube_Downloader.bat" "%~f0" && (
        call "%~f0" && (
            exit 0
        )
    )
)
exit /b 1
