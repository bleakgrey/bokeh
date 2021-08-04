public class App.Project : Object {

	public File source_file { get; set; }
	public GLib.ListStore layers { get; set; default = new GLib.ListStore (typeof(Layer)); }

	public Project (File source_file) {
		this.source_file = source_file;

		var background = new Layer (){
			name = _("Source"),
			removable = false,
			togglable = false
		};
		layers.append (background);

		var test_shader = new ShaderLayer (){
			name = _("Sepia")
		};
		layers.append (test_shader);
	}



}
