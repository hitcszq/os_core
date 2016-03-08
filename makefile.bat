:Define variables
@SET BOOT=os_mbr
@SET KERNEL=os_core
@SET USER_1=user_program_1
@SET USER_2=user_program_2
@SET IMAGE=Image.bin
@SET extBinary=bin
@SET extASM=asm
@SET oneSectorSize=512
@SET onloadPosKernel=512
@SET onloadPosUser1=25600
@SET onloadPosUser2=51200
@SET sizeImageFile=1024000

:Compile
@ECHO 1. Compile %BOOT%.%extASM% and %KERNEL%.%extASM%
@IF NOT EXIST %BOOT%.%extASM% ECHO %BOOT%.%extASM% does not exist
@IF NOT EXIST %KERNEL%.%extASM% ECHO %KERNEL%.%extASM% does not exist
@IF NOT EXIST %USER_1%.%extASM% ECHO %USER_1%.%extASM% does not exist
@IF NOT EXIST %USER_2%.%extASM% ECHO %USER_2%.%extASM% does not exist
@ECHO/
@IF EXIST %BOOT%.%extBinary% DEL %BOOT%.%extBinary%
@IF EXIST %KERNEL%.%extBinary% DEL %KERNEL%.%extBinary%
@IF EXIST %USER_1%.%extBinary% DEL %USER_1%.%extBinary%
@IF EXIST %USER_2%.%extBinary% DEL %USER_2%.%extBinary%
@nasm -f bin %BOOT%.%extASM% -o %BOOT%.%extBinary%
@nasm -f bin %KERNEL%.%extASM% -o %KERNEL%.%extBinary%
@nasm -f bin %USER_1%.%extASM% -o %USER_1%.%extBinary%
@nasm -f bin %USER_2%.%extASM% -o %USER_2%.%extBinary%

:Link
@ECHO 2. Combine %BOOT%.%extBinary% and %KERNEL%.%extBinary% into one bin file %IMAGE%
@ECHO/
@IF EXIST %IMAGE% DEL %IMAGE%
@ECHO 2.1 Create new file %IMAGE%
@fsutil file createnew %IMAGE% %sizeImageFile% 1>nul
@ECHO/
@ECHO 2.2 Copy %BOOT%.%extBinary% data to %IMAGE%
@sfk partcopy %BOOT%.%extBinary% -allfrom 0 %IMAGE% 0 -yes
@ECHO/
@ECHO 2.3 Copy %KERNEL%.%extBinary% data to %IMAGE%
@sfk partcopy %KERNEL%.%extBinary% -allfrom 0 %IMAGE% %onloadPosKernel% -yes
@ECHO/
@ECHO 2.4 Copy %USER_1%.%extBinary% data to %IMAGE%
@sfk partcopy %USER_1%.%extBinary% -allfrom 0 %IMAGE% %onloadPosUser1% -yes
@ECHO/
@ECHO 2.5 Copy %USER_2%.%extBinary% data to %IMAGE%
@sfk partcopy %USER_2%.%extBinary% -allfrom 0 %IMAGE% %onloadPosUser2% -yes

:Successfully
@ECHO/
@ECHO Successfully !

:Author
@ECHO/
@ECHO/
@ECHO/
@ECHO Last Updated on 2015-12-13
@ECHO/
@ECHO/

@PAUSE


