add_library(Qchat_sub
	msglist.cpp
	socketbackend.cpp
)

target_link_libraries(Qchat
  PRIVATE Qt5::Core Qt5::Quick Qt5::QuickControls2)