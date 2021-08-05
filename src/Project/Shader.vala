using Gsk;

public class App.Shader : Asset {
	public Bytes content { get; set; }

	public GLShader get_node () {
		return new GLShader.from_bytes (content);
	}

}
