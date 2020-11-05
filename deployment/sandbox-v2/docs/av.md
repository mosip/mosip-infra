# Integrating AntiVirus Scanner

Virus scanners may be implemented at various level in MOSIP.  By default, ClamAV is used as antivirus scanner. If you would like to integrate your anti-virus (AV), the same can be done as below: 

## Registration client
It sufficies to run your AV on registration client machine.  Integration with MOSIP in not required.

## Server 

This is implemented as a part of [Kernel ClamAV project](https://github.com/mosip/commons/tree/master/kernel/kernel-virusscanner-clamav) project. MOSIP uses this project to scan registration packets.

You may integrate your anti-virus (AV) in the following ways:

* Option 1:

The registration packets are stored in Minio.  Some AVs offer traffic flow analysis to protect against threats inline with the stream. This kind of network based implementation may be done without any change in MOSIP code. But a careful setup of network is necessary to ensure all network traffic travels through your AV.

* Option 2:

The following Java code has to be altered to support your AV at the code level. The `scanFile/scanFolder/scanDocument` API in [VirusScannerImpl.java](https://github.com/mosip/commons/blob/master/kernel/kernel-virusscanner-clamav/src/main/java/io/mosip/kernel/virusscanner/clamav/impl/VirusScannerImpl.java) needs to be implemented with your AV SDK. 
