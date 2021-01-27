@echo off

cd %PROTOBUF_DIR%\src\google\protobuf

REM see: https://medium.com/@0xflarion/using-ue4-w-google-protocol-buffers-ae7cab820d84 step2
REM Error C4647	behavior change: __is_pod(google::protobuf::internal::AuxillaryParseTableField) has different value in previous versions \
REM Pirates	C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Tools\MSVC\14.14.26428\INCLUDE\type_traits
powershell -Command "$text=Get-Content generated_message_table_driven.h ;" ^
                    "$text[206]='// ' ;" ^
                    "$text| Set-Content generated_message_table_driven.h"

REM disable warning: 4946 4582 4996
powershell -Command "$text=Get-Content descriptor.h ;" ^
                    "$text[0]='#ifdef _MSC_VER' ;" ^
                    "$text[1]='#pragma warning (disable: 4946)' ;" ^
                    "$text[2]='#pragma warning (disable: 4582)' ;" ^
                    "$text[3]='#pragma warning (disable: 4996)' ;" ^
                    "$text[4]='#endif' ;" ^
                    "$text| Set-Content descriptor.h"

powershell -Command "$text=Get-Content port_def.inc ;" ^
                    "$text[571]='#if defined(_MSC_VER)' ;" ^
                    "$text| Set-Content port_def.inc"

REM build client android in MAC or WINDOWS, error: undefined bswap_16 bswap_32 bswap_64
pushd stubs
    powershell -Command "$text=Get-Content port.h ;" ^
                        "$text[241]='#elif !defined(__GLIBC__) && !defined(__BIONIC__) && !defined(__CYGWIN__) || !defined(bswap_16)' ;" ^
                        "$text| Set-Content port.h"
popd
