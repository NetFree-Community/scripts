@echo off

IF NOT EXIST "keytool.exe" (
msg * שהוא קריטי לפעולה תקינה KEYTOOL.EXE חסר קובץ בשם
GOTO EOF
)

powershell -Command "(New-Object Net.WebClient).DownloadFile('http://netfree.link/netfree-ca.crt', 'netfree-ca.crt')"

COPY keytool.exe %LOCALAPPDATA%\Degoo\jre\bin\keytool.exe /v
COPY netfree-ca.crt %LOCALAPPDATA%\Degoo\jre\bin\netfree-ca.crt /v

COPY ..\lib\security\cacerts ..\lib\security\cacerts.bak

CD %LOCALAPPDATA%\Degoo\jre\bin

keytool -importcert -noprompt -trustcacerts -storepass "changeit" -file netfree-ca.crt  -keystore ..\lib\security\cacerts 

pause

:EOF
