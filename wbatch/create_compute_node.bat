@ECHO OFF

REM This is an automatically generated Windows batch file. It creates the
REM compute VM for an OpenStack training-labs setup.

SETLOCAL ENABLEDELAYEDEXPANSION

ECHO.
ECHO OpenStack labs for VirtualBox on Windows
ECHO Generated by osbash
ECHO.
ECHO Create compute VM
ECHO.

REM vim: set ai ts=4 sw=4 et ft=dosbatch:

REM VBoxManage is not in PATH, but this is a good guess
IF EXIST %ProgramFiles%\Oracle\VirtualBox\VBoxManage.exe (
    SET PATH=%PATH%;%ProgramFiles%\Oracle\VirtualBox
    ECHO.
    ECHO %time% Found %ProgramFiles%\Oracle\VirtualBox\VBoxManage.exe
    ECHO.
    GOTO :vbm_found
)

ECHO.
ECHO %time% Searching %SystemDrive% for VBoxManage, this may take a while
ECHO.
FOR /r %SystemDrive% %%a IN (*) DO (
    IF "%%~nxa"=="VBoxManage.exe" (
        SET PATH=%PATH%;%%~dpa
        ECHO %time% Found %%~dpnxa
        GOTO :vbm_found
    )
)

ECHO.
ECHO %time% Cannot find VBoxManage.exe (part of VirtualBox) on %SystemDrive%.
ECHO %time% Program stops.
ECHO.
GOTO :terminate

:vbm_found

REM vim: set ai ts=4 sw=4 et ft=dosbatch:

SET BATDIR=%~dp0
PUSHD %BATDIR%..
SET TOPDIR=%cd%
POPD

SET AUTODIR=%TOPDIR%\autostart
SET IMGDIR=%TOPDIR%\img
SET LOGDIR=%TOPDIR%\log
SET STATUSDIR=%TOPDIR%\log\status
SET SHAREDIR=%TOPDIR%

ECHO %time% Creating directories (if needed)
IF NOT EXIST %AUTODIR% mkdir %AUTODIR%
IF NOT EXIST %IMGDIR% mkdir %IMGDIR%
IF NOT EXIST %LOGDIR% mkdir %LOGDIR%
IF NOT EXIST %SHAREDIR% mkdir %SHAREDIR%

REM vim: set ai ts=4 sw=4 et ft=dosbatch:

ECHO %time% Cleaning up autostart and log directories
DEL /S /Q %AUTODIR%
DEL /S /Q %LOGDIR%

ECHO %time% Looking for %IMGDIR%\base-vbadd-ubuntu-14.04-server-amd64.vdi
IF EXIST %IMGDIR%\base-vbadd-ubuntu-14.04-server-amd64.vdi goto got_base_disk
ECHO.
ECHO base-vbadd-ubuntu-14.04-server-amd64.vdi not found in %IMGDIR%.
ECHO.
ECHO You need to build a base disk before you can create node VMs.
ECHO.
goto :terminate

:got_base_disk
ECHO.
ECHO %time% Found %IMGDIR%\base-vbadd-ubuntu-14.04-server-amd64.vdi
ECHO.
ECHO %time% Initialization done. Hit any key to continue.
ECHO.
PAUSE

REM vim: set ai ts=4 sw=4 et ft=dosbatch:

CALL :vm_exists compute
ECHO VBoxManage createvm --name compute --register --ostype Ubuntu_64 --groups /oslabs
VBoxManage createvm --name compute --register --ostype Ubuntu_64 --groups /oslabs
IF %errorlevel% NEQ 0 GOTO :vbm_error

ECHO VBoxManage modifyvm compute --rtcuseutc on
VBoxManage modifyvm compute --rtcuseutc on
IF %errorlevel% NEQ 0 GOTO :vbm_error

ECHO VBoxManage modifyvm compute --biosbootmenu disabled
VBoxManage modifyvm compute --biosbootmenu disabled
IF %errorlevel% NEQ 0 GOTO :vbm_error

ECHO VBoxManage modifyvm compute --largepages on
VBoxManage modifyvm compute --largepages on
IF %errorlevel% NEQ 0 GOTO :vbm_error

ECHO VBoxManage modifyvm compute --boot1 disk
VBoxManage modifyvm compute --boot1 disk
IF %errorlevel% NEQ 0 GOTO :vbm_error

ECHO VBoxManage storagectl compute --name SATA --add sata --portcount 1
VBoxManage storagectl compute --name SATA --add sata --portcount 1
IF %errorlevel% NEQ 0 GOTO :vbm_error

ECHO VBoxManage storagectl compute --name SATA --hostiocache on
VBoxManage storagectl compute --name SATA --hostiocache on
IF %errorlevel% NEQ 0 GOTO :vbm_error

ECHO VBoxManage storagectl compute --name IDE --add ide
VBoxManage storagectl compute --name IDE --add ide
IF %errorlevel% NEQ 0 GOTO :vbm_error

ECHO VBoxManage modifyvm compute --memory 1024
VBoxManage modifyvm compute --memory 1024
IF %errorlevel% NEQ 0 GOTO :vbm_error

ECHO VBoxManage modifyvm compute --cpus 2
VBoxManage modifyvm compute --cpus 2
IF %errorlevel% NEQ 0 GOTO :vbm_error

ECHO VBoxManage modifyvm compute --nictype1 virtio --nic1 nat
VBoxManage modifyvm compute --nictype1 virtio --nic1 nat
IF %errorlevel% NEQ 0 GOTO :vbm_error

ECHO VBoxManage modifyvm compute --nictype2 virtio --nic2 hostonly --hostonlyadapter2 "VirtualBox Host-Only Ethernet Adapter" --nicpromisc2 allow-all
VBoxManage modifyvm compute --nictype2 virtio --nic2 hostonly --hostonlyadapter2 "VirtualBox Host-Only Ethernet Adapter" --nicpromisc2 allow-all
IF %errorlevel% NEQ 0 GOTO :vbm_error

ECHO VBoxManage modifyvm compute --nictype3 virtio --nic3 hostonly --hostonlyadapter3 "VirtualBox Host-Only Ethernet Adapter #2" --nicpromisc3 allow-all
VBoxManage modifyvm compute --nictype3 virtio --nic3 hostonly --hostonlyadapter3 "VirtualBox Host-Only Ethernet Adapter #2" --nicpromisc3 allow-all
IF %errorlevel% NEQ 0 GOTO :vbm_error

ECHO VBoxManage modifyvm compute --natpf1 ssh,tcp,127.0.0.1,2232,,22
VBoxManage modifyvm compute --natpf1 ssh,tcp,127.0.0.1,2232,,22
IF %errorlevel% NEQ 0 GOTO :vbm_error

ECHO VBoxManage sharedfolder add compute --name osbash --hostpath %SHAREDIR%
VBoxManage sharedfolder add compute --name osbash --hostpath %SHAREDIR%
IF %errorlevel% NEQ 0 GOTO :vbm_error

ECHO VBoxManage modifyhd --type multiattach %IMGDIR%\base-vbadd-ubuntu-14.04-server-amd64.vdi
VBoxManage modifyhd --type multiattach %IMGDIR%\base-vbadd-ubuntu-14.04-server-amd64.vdi
IF %errorlevel% NEQ 0 GOTO :vbm_error

ECHO VBoxManage storageattach compute --storagectl SATA --port 0 --device 0 --type hdd --medium %IMGDIR%\base-vbadd-ubuntu-14.04-server-amd64.vdi
VBoxManage storageattach compute --storagectl SATA --port 0 --device 0 --type hdd --medium %IMGDIR%\base-vbadd-ubuntu-14.04-server-amd64.vdi
IF %errorlevel% NEQ 0 GOTO :vbm_error

COPY %TOPDIR%\scripts\osbash\init_xxx_node.sh %AUTODIR%\00_init_compute_node.sh
COPY %TOPDIR%\scripts\etc_hosts.sh %AUTODIR%\01_etc_hosts.sh
COPY %TOPDIR%\scripts\osbash\enable_vagrant_ssh_keys.sh %AUTODIR%\02_enable_vagrant_ssh_keys.sh
COPY %TOPDIR%\scripts\osbash\shutdown.sh %AUTODIR%\03_shutdown.sh
ECHO VBoxManage startvm compute --type headless
VBoxManage startvm compute --type headless
IF %errorlevel% NEQ 0 GOTO :vbm_error

ECHO %time% Waiting for autostart files to execute.
CALL :wait_auto
ECHO %time% All autostart files executed.
ECHO %time% Waiting for VM compute to power off.
CALL :wait_poweroff compute
ECHO %time% VM compute powered off.
ECHO VBoxManage snapshot compute take network_configured
VBoxManage snapshot compute take network_configured
IF %errorlevel% NEQ 0 GOTO :vbm_error

TIMEOUT /T 1 /NOBREAK
COPY %TOPDIR%\scripts\setup_nova_compute.sh %AUTODIR%\00_setup_nova_compute.sh
COPY %TOPDIR%\scripts\osbash\shutdown.sh %AUTODIR%\01_shutdown.sh
ECHO VBoxManage startvm compute --type headless
VBoxManage startvm compute --type headless
IF %errorlevel% NEQ 0 GOTO :vbm_error

ECHO %time% Waiting for autostart files to execute.
CALL :wait_auto
ECHO %time% All autostart files executed.
ECHO %time% Waiting for VM compute to power off.
CALL :wait_poweroff compute
ECHO %time% VM compute powered off.
ECHO VBoxManage snapshot compute take nova-compute_installed
VBoxManage snapshot compute take nova-compute_installed
IF %errorlevel% NEQ 0 GOTO :vbm_error

TIMEOUT /T 1 /NOBREAK
COPY %TOPDIR%\scripts\setup_neutron_compute.sh %AUTODIR%\00_setup_neutron_compute.sh
COPY %TOPDIR%\scripts\setup_cinder_volumes.sh %AUTODIR%\01_setup_cinder_volumes.sh
COPY %TOPDIR%\scripts\osbash\shutdown.sh %AUTODIR%\02_shutdown.sh
ECHO VBoxManage startvm compute --type headless
VBoxManage startvm compute --type headless
IF %errorlevel% NEQ 0 GOTO :vbm_error

ECHO %time% Waiting for autostart files to execute.
CALL :wait_auto
ECHO %time% All autostart files executed.
ECHO %time% Waiting for VM compute to power off.
CALL :wait_poweroff compute
ECHO %time% VM compute powered off.
ECHO VBoxManage snapshot compute take compute_node_installed
VBoxManage snapshot compute take compute_node_installed
IF %errorlevel% NEQ 0 GOTO :vbm_error

TIMEOUT /T 1 /NOBREAK
COPY %TOPDIR%\scripts\shutdown_controller.sh %AUTODIR%\00_shutdown_controller.sh
ECHO VBoxManage startvm compute --type headless
VBoxManage startvm compute --type headless
IF %errorlevel% NEQ 0 GOTO :vbm_error

ECHO %time% Waiting for autostart files to execute.
CALL :wait_auto
ECHO %time% All autostart files executed.
ECHO %time% Waiting for VM controller to power off.
CALL :wait_poweroff controller
ECHO %time% VM controller powered off.
ECHO VBoxManage snapshot controller take compute_node_installed
VBoxManage snapshot controller take compute_node_installed
IF %errorlevel% NEQ 0 GOTO :vbm_error

TIMEOUT /T 1 /NOBREAK
ECHO VBoxManage startvm controller --type headless
VBoxManage startvm controller --type headless
IF %errorlevel% NEQ 0 GOTO :vbm_error

ECHO %time% Waiting for autostart files to execute.
CALL :wait_auto
ECHO %time% All autostart files executed.
ECHO.
ECHO %time% Batch script seems to have succeeded.
ECHO.

GOTO :terminate

REM Note: vbm_error falls through to terminate
:vbm_error
ECHO.
ECHO %time% VBoxManage returned with an error. Aborting.
ECHO.

:terminate
ENDLOCAL
PAUSE
EXIT
GOTO :eof

REM ============================================================================
REM
REM End of program, function definitions follow
REM
REM ============================================================================
:wait_auto
IF EXIST %STATUSDIR%\done (
    DEL %STATUSDIR%\done
    GOTO :eof
)
IF EXIST %STATUSDIR%\error (
    ECHO.
    ECHO %time% ERROR Script returned error:
    ECHO.
    TYPE %STATUSDIR%\error
    ECHO.
    ECHO %time% Aborting.
    ECHO.
    DEL %STATUSDIR%\error
    GOTO :terminate
)
TIMEOUT /T 5 /NOBREAK
GOTO :wait_auto
REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
:wait_poweroff
VBoxManage showvminfo %~1 --machinereadable|findstr poweroff
IF %errorlevel% EQU 0 GOTO :eof
TIMEOUT /T 2 /NOBREAK
GOTO :wait_poweroff
REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
:vm_exists
VBoxManage list vms|findstr %~1
IF %errorlevel% NEQ 0 GOTO :eof
ECHO.
ECHO %time% VM %~1 already exists. Aborting.
ECHO.
GOTO :terminate
REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

REM vim: set ai ts=4 sw=4 et ft=dosbatch:

