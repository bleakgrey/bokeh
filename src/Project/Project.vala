public class App.Project : Object {

	protected Window.Main? window { get; set; }

	public File source_file { get; set; }
	public GLib.ListStore layers { get; set; default = new GLib.ListStore (typeof(Layer)); }

	public Project (File source_file) {
		this.source_file = source_file;
	}

	public void load (Window.Main win) {
		message ("Loading project: "+source_file.get_path ());
		this.window = win;
		window.project = this;

		add_layer (new SourceLayer (){
			name = _("Source File"),
			removable = false,
			togglable = false
		});

		// add_layer (new ShaderLayer (){
		// 	name = _("Sepia"),
		// 	shader_name = "sepia"
		// });
	}

	public void add_layer (Layer layer) {
		//layers.append (layer);
		layers.insert (0, layer);
		layer.on_added (window);
	}

	public void remove_layer (Layer layer) {
		uint pos = 0;
		layers.find (layer, out pos);
		layers.remove (pos);

		layer.on_removed ();
	}

}
