project('Qchat', 'cpp', default_options : ['cpp_std=c++11'])

qt5 = import('qt5')
qt5dep = dependency('qt5', modules : ['Core', 'Quick', 'QuickControls2', 'Multimedia'])


incdir = include_directories('src_c++', 'src_c++/test')

qchat_headers = ['src_c++/msglist.h',
				 'src_c++/serverslist.h',
				 'src_c++/socketbackend.h',
				 'src_c++/test/audiobackend.h']

qchat_sources = ['main.cpp',
				 'src_c++/msglist.cpp',
				 'src_c++/serverslist.cpp',
				 'src_c++/socketbackend.cpp',
				 'src_c++/test/audiobackend.cpp']

qchat_resources = ['qml.qrc']

q5prep = qt5.preprocess(
                    moc_headers : qchat_headers,
                    qresources : qchat_resources,
                    include_directories : incdir)

q5exe = executable('Qchat',
                    sources : [qchat_sources, q5prep],
                    dependencies : [qt5dep],
                    include_directories : incdir)