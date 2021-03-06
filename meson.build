project('com.github.bleakgrey.bokeh', 'vala', 'c', version: '1.0')

add_global_arguments([
        '-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()),
    ],
    language: 'c',
)

config = configuration_data()
config.set('EXEC_NAME', meson.project_name())
config.set('GETTEXT_PACKAGE', meson.project_name())
config.set('RESOURCES', '/' + '/'.join(meson.project_name().split('.')) + '/' )
config.set('VERSION', meson.project_version())
config.set('PREFIX', get_option('prefix'))
config.set('NAME', 'Bokeh')
config.set('WEBSITE', 'https://github.com/bleakgrey/bokeh')
config.set('SUPPORT_WEBSITE', 'https://github.com/bleakgrey/bokeh/issues')
config.set('COPYRIGHT', '© 2021 bleak_grey')

gnome = import('gnome')
i18n = import('i18n')

asresources = gnome.compile_resources(
  'as-resources', 'data/gresource.xml',
  source_dir: 'data',
  c_name: 'as'
)

libgtk_dep = dependency('gtk4', version: '>=4.0.0', required: true)
libadwaita_dep = dependency('libadwaita-1', version: '>=1.0.0', required: true)

sources = files(
    'src/Application.vala',
    'src/Library/Library.vala',
    'src/Library/Asset.vala',
    'src/Library/Filter.vala',
    'src/View/Base.vala',
    'src/View/Editor.vala',
    'src/View/Sidebar.vala',
    'src/View/Canvas.vala',
    'src/View/Navigator.vala',
    'src/View/AddFilter.vala',
    'src/Widget/LayerRow.vala',
    'src/Window/Main.vala',
    'src/Project/Project.vala',
    'src/Project/Layer.vala',
    'src/Project/SourceLayer.vala',
    'src/Project/FilterLayer.vala',
)

build_file = configure_file(
    input: 'src/Build.vala.in',
    output: 'Build.vala',
    configuration: config
)

executable(
    meson.project_name(),
    asresources,
    build_file,
    sources,
    dependencies: [
        dependency('glib-2.0', version: '>=2.30.0'),
        dependency('gee-0.8', version: '>=0.8.5'),
        dependency('json-glib-1.0', version: '>=1.4.4'),
        libgtk_dep,
        libadwaita_dep,
        #meson.get_compiler('c').find_library('m'),
    ],
    install: true,
)

subdir('data')
subdir('po')

meson.add_install_script('meson/post_install.py')
