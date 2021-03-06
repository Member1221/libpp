module polyplex.core.render.camera;
import polyplex.math;
import std.stdio;

/**
	A basis of a camera.
*/
public class Camera {
	protected Matrix4x4 matrix;
	protected float znear;
	protected float zfar;

	public @property Matrix4x4 Matrix() { Update(); return this.matrix; }
	public @property void Matrix(Matrix4x4 value) { this.matrix = value; Update(); }

	/**
		Update the camera rotation, scale and translation.
	*/
	public abstract void Update();

	/**
		Creates a dimension dependant projection. (Recommended)
	*/
	public abstract Matrix4x4 Project(float width, float height);

	/**
		Creates an perspective projection with the specified width and height.
	*/
	public Matrix4x4 ProjectPerspective(float width, float fov, float height) {
		return Matrix4x4.Perspective(width, height, fov, znear, zfar);
	}

	/**
		Creates an othrographic projection with the specified width and height.
	*/
	public Matrix4x4 ProjectOrthographic(float width, float height) {
		return Matrix4x4.Identity.Orthographic(0f, width, height, 0f, znear, zfar);
	}
}

/**
	A basic 3D camera, optimized for use in 3D environments.
*/
public class Camera3D : Camera {
	private float fov;
	public Vector3 Position;
	public Quaternion Rotation;
	public float Zoom;


	this(Vector3 position, Quaternion rotation = Quaternion.Identity, float zoom = 1f, float near = 0.1f, float far = 100f, float fov = 90f) {
		this.Position = position;
		this.Rotation = rotation;
		this.Zoom = zoom;

		this.znear = near;
		this.zfar = far;
		this.fov = fov;
		Update();
	}

	/**
		Update the camera rotation, scale and translation.
	*/
	public override void Update() {
		this.matrix = Matrix4x4.Identity;
		this.matrix
		.Translate(Position)
		.RotateX(this.Rotation.X)
		.RotateY(this.Rotation.Y)
		.RotateZ(this.Rotation.Z)
		.Scale(Vector3(Zoom, Zoom, Zoom));
	}

	/**
		Creates an perspective projection with the specified width and height.
	*/
	public override Matrix4x4 Project(float width, float height) {
		return ProjectPerspective(width, this.fov, height);
	}
}

public class Camera2D : Camera {
	public Vector3 Position;
	public float Rotation;
	public float RotationY;
	public float RotationX;
	public float Zoom;
	public Vector3 Origin;

	this(Vector2 position, float rotation = 0f, float zoom = 1f, float near = 0.01f, float far = 100f) {
		this.Position = Vector3(position.X, position.Y, -5);
		this.Rotation = rotation;
		this.RotationX = 0;
		this.RotationY = 0;
		this.Zoom = zoom;
		this.Origin = Vector3(0, 0, -5);

		this.znear = near;
		this.zfar = far;
		this.matrix = Matrix4x4.Identity;
		Update();
	}

	/**
		Update the camera rotation, scale and translation.
	*/
	public override void Update() {
		this.matrix = Matrix4x4.Identity
		.Translate(Vector3(-Position.X, -Position.Y, 0))
		.RotateX(this.RotationX)
		.RotateY(this.RotationY)
		.RotateZ(this.Rotation)
		.Scale(Vector3(Zoom, Zoom, Zoom))
		.Translate(Vector3(Origin.X, Origin.Y, Origin.Z));
	}

	/**
		Creates an othrographic projection with the specified width and height.
	*/
	public override Matrix4x4 Project(float width, float height) {
		return ProjectOrthographic(width, height);
	}
}