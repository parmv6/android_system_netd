LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES:=                                      \
                  BandwidthController.cpp              \
                  ClatdController.cpp                  \
                  CommandListener.cpp                  \
                  DnsProxyListener.cpp                 \
                  FirewallController.cpp               \
                  IdletimerController.cpp              \
                  InterfaceController.cpp              \
                  MDnsSdListener.cpp                   \
                  NatController.cpp                    \
                  NetdCommand.cpp                      \
                  NetdConstants.cpp                    \
                  NetlinkHandler.cpp                   \
                  NetlinkManager.cpp                   \
                  PppController.cpp                    \
                  ResolverController.cpp               \
                  SecondaryTableController.cpp         \
                  TetherController.cpp                 \
                  oem_iptables_hook.cpp                \
                  UidMarkMap.cpp                       \
                  main.cpp                             \
                  RouteController.cpp

LOCAL_MODULE:= netd

LOCAL_C_INCLUDES := $(KERNEL_HEADERS) \
                    external/mdnsresponder/mDNSShared \
                    external/openssl/include \
                    external/stlport/stlport \
                    bionic \
                    bionic/libc/private \
                    $(call include-path-for, libhardware_legacy)/hardware_legacy

LOCAL_CFLAGS := -Werror=format

LOCAL_SHARED_LIBRARIES := libstlport libsysutils liblog libcutils libnetutils \
                          libcrypto libhardware_legacy libmdnssd libdl \
                          liblogwrap

ifdef USES_TI_MAC80211
  LOCAL_SRC_FILES += SoftapControllerTI.cpp
else ifeq ($(WIFI_DRIVER_MODULE_NAME),ar6000)
  ifneq ($(WIFI_DRIVER_MODULE_PATH),rfkill)
    LOCAL_CFLAGS += -DWIFI_MODULE_PATH=\"$(WIFI_DRIVER_MODULE_PATH)\"
  endif
  LOCAL_C_INCLUDES += external/wpa_supplicant_6/wpa_supplicant/src/common
  LOCAL_SRC_FILES += SoftapControllerATH.cpp
  LOCAL_SHARED_LIBRARIES := $(LOCAL_SHARED_LIBRARIES) libwpa_client
else
  LOCAL_SRC_FILES += SoftapController.cpp
endif

ifneq ($(BOARD_HOSTAPD_DRIVER),)
  LOCAL_CFLAGS += -DHAVE_HOSTAPD
  ifneq ($(BOARD_HOSTAPD_DRIVER_NAME),)
    LOCAL_CFLAGS += -DHOSTAPD_DRIVER_NAME=\"$(BOARD_HOSTAPD_DRIVER_NAME)\"
  endif
endif

ifeq ($(BOARD_HAS_QCOM_WLAN_SDK), true)
  LOCAL_SRC_FILES += QsoftapCmd.cpp
  LOCAL_CFLAGS += -DQSAP_WLAN
  LOCAL_SHARED_LIBRARIES += libqsap_sdk
  LOCAL_C_INCLUDES += $(LOCAL_PATH)/../qcom/softap/sdk/
endif

ifeq ($(BOARD_HAVE_LEGACY_HOSTAPD),true)
  LOCAL_CFLAGS += -DHAVE_LEGACY_HOSTAPD
endif

ifeq ($(BOARD_WLAN_NO_FWRELOAD),true)
  LOCAL_CFLAGS += -DWLAN_NO_FWRELOAD
endif

ifeq ($(USE_LEGACY_SOFTAP),true)
  LOCAL_CFLAGS += -DLEGACY_SOFTAP
endif

ifeq ($(WIFI_DRIVER_HAS_LGE_SOFTAP),true)
  LOCAL_CFLAGS += -DLGE_SOFTAP
endif

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_SRC_FILES:=          \
                  ndc.c \

LOCAL_MODULE:= ndc

LOCAL_C_INCLUDES := $(KERNEL_HEADERS)

LOCAL_CFLAGS := 

LOCAL_SHARED_LIBRARIES := libcutils

include $(BUILD_EXECUTABLE)
