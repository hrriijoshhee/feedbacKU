QT += quick quickcontrols2 sql

CONFIG += c++17

# Add your source files here
SOURCES += \
    databasemanager.cpp \
    main.cpp

# Include the .qrc resource file
RESOURCES += Resource.qrc  # Replace with your actual .qrc file name

# Default rules for deployment
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

# Include header files here
HEADERS += \
    databasemanager.h

QT += sql
