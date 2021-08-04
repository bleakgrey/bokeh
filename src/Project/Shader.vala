using Gsk;

public class App.Shader : Object {

	public string name { get; set; }
	public Bytes content { get; set; }

	public GLShader get_node () {
		return new GLShader.from_bytes (content);
	}

}
