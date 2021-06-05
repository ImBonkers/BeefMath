using System;

namespace BeefMath
{
	public struct Quat
	{
		typealias Value = float;

		Value[4] data;

		public Value X { get => data[0]; set mut { data[0] = value; } };
		public Value Y { get => data[1]; set mut { data[1] = value; } };
		public Value Z { get => data[2]; set mut { data[2] = value; } };
		public Value W { get => data[3]; set mut { data[3] = value; } };

		public this()
		{
			data = .();
		}

		public this(Quat other)
		{
			data = other.data;
		}

		public this(Vec4 vec)
		{
			data = .(vec.X, vec.Y, vec.Z, vec.W);
		}

		public this(float x, float y, float z, float w)
		{
			data = .();
			X = x;
			Y = y;
			Z = z;
			W = w;
		}



		// Indexer operator
		// ~~~~~~~~~~~~~~~~

		public ref Value this[int ind]
		{
			get mut => ref GetValue(ind);
			set mut => SetValue(ind, value);
		}

		private Result<int> GetValueError(int ind)
		{
			if (ind > 0 && ind < 4)
				return .Ok(ind);
			return .Err;
		}

		public ref Value GetValue(int ind) mut
		{
			switch (GetValueError(ind))
			{
			case .Ok(let index): return ref data[index];
			case .Err: Console.WriteLine("Trying write to out of bound value in Quat");
			}
			float tmp = 0.0f;
			return ref tmp;
		}

		public void SetValue(int ind, Value value) mut
		{
			switch (GetValueError(ind))
			{
			case .Ok(let index): data[index] = value;
			case .Err: Console.WriteLine("Trying write to out of bound value in Quat");
			}
		}



		// Static arithmetic methods
		// ~~~~~~~~~~~~~~~~~~~~~~~~~

		private static Quat Add(Quat p, Quat q)
		{
			return Quat(p.X + q.X, p.Y + q.Y, p.Z + q.Z, p.W + q.W);
		}

		private static Quat Add(Quat p, Value val)
		{
			return Quat(p.X + val, p.Y + val, p.Z + val, p.W + val);
		}

		private static Quat Sub(Quat p, Quat q)
		{
			return Quat(p.X - q.X, p.Y - q.Y, p.Z - q.Z, p.W - q.W);
		}

		private static Quat Sub(Quat p, Value val)
		{
			return Quat(p.X - val, p.Y - val, p.Z - val, p.W - val);
		}

		private static Quat Mul(Quat p, Quat q)
		{
			// According to the Hamilton product:
			Quat result = .();
			result.X = p.W * q.X + p.X * q.W + p.Y * q.Z - p.Z * q.Y;
			result.Y = p.W * q.Y + p.Y * q.W + p.Z * q.X - p.X * q.Z;
			result.Z = p.W * q.Z + p.Z * q.W + p.X * q.Y - p.Y * q.X;
			result.W = p.W * q.W - p.X * q.X - p.Y * q.Y - p.Z * q.Z;
			return result;
		}

		private static Quat Mul(Quat p, Value val)
		{
			return .(p.X * val, p.Y * val, p.Z * val, p.W * val);
		}

		private static Quat Div(Quat p, Value val)
		{
			return .(p.X / val, p.Y / val, p.Z / val, p.W / val);
		}

		public static Value Dot(Quat p, Quat q)
		{
			return p.X * q.X + p.Y * q.Y + p.Z * q.Z + p.W * q.W;
		}

		public static Value Length(Quat p)
		{
			return Math.Sqrt(Dot(p, p));
		}

		public static Quat Normalize(Quat p)
		{
			return p / Length(p);
		}

		public static Quat Mix(Quat p, Quat q, Value a)
		{
			Value cosTheta = Dot(p, q);

			if (cosTheta > 1.0f - Value.Epsilon)
			{
				return .(
					Scalar.Mix(p.X, q.X, a),
					Scalar.Mix(p.Y, q.Y, a),
					Scalar.Mix(p.Z, q.Z, a),
					Scalar.Mix(p.W, q.W, a));
			}
			else
			{
				Value angle = Math.Acos(cosTheta);
				return (Math.Sin((1.0f - a) * angle) * p + Math.Sin(a * angle) * q) / Math.Sin(angle);
			}
		}

		public static Quat Lerp(Quat p, Quat q, Value a)
		{
			if (a > 0 && a < 1)
				return p * (1 - a) + (q * a);
			return .();
		}

		public static Quat Slerp(Quat p, Quat q, Value a)
		{
			Quat z = q;

			Value cosTheta = Dot(p, q);

			if (cosTheta < 0.0f)
			{
				z = -q;
				cosTheta = -cosTheta;
			}

			if (cosTheta > 1.0f - Value.Epsilon)
			{
				return .(
					Scalar.Mix(p.X, z.X, a),
					Scalar.Mix(p.Y, z.Y, a),
					Scalar.Mix(p.Z, z.Z, a),
					Scalar.Mix(p.W, z.W, a));
			}
			else
			{
				Value angle = Math.Acos(cosTheta);
				return (Math.Sin((1.0f - a) * angle) * p + Math.Sin(a * angle) * z) / Math.Sin(angle);
			}
		}

		public static Quat Conjugate(Quat p)
		{
			return .(-p.X, -p.Y, -p.Z, p.W);
		}

		public static Quat Inverse(Quat p)
		{
			return Conjugate(p) / Dot(p, p);
		}



		// non-static methods
		// ~~~~~~~~~~~~~~~~~~

		public Value Dot(Quat p)
		{
			return Dot(this, p);
		}

		public Value Length()
		{
			return Length(this);
		}

		public Quat Normalize()
		{
			return Normalize(this);
		}

		public Quat Mix(Quat p, Value a)
		{
			return Mix(this, p, a);
		}

		public Quat Lerp(Quat p, Value a)
		{
			return Lerp(this, p, a);
		}

		public Quat Slerp(Quat p, Value a)
		{
			return Slerp(this, p, a);
		}

		public Quat Conjugate()
		{
			return Conjugate(this);
		}

		public Quat Inverse()
		{
			return Inverse(this);
		}



		// Unary arithmetic operators
		// ~~~~~~~~~~~~~~~~~~~~~~~~~~~

		public static Quat operator+(Quat other)
		{
			return other;
		}

		public static Quat operator-(Quat other)
		{
			return Quat(-other.X, -other.Y, -other.Z, -other.W);
		}

		public void operator+=(Quat other) mut
		{
			this = Add(this, other);
		}

		public void operator+=(Value val) mut
		{
			this = Add(this, val);
		}

		public void operator-=(Quat other) mut
		{
			this = Sub(this, other);
		}

		public void operator-=(Value val) mut
		{
			this = Sub(this, val);
		}

		public void operator*=(Quat other) mut
		{
			this = Mul(this, other);
		}

		public void operator*=(Value val) mut
		{
			this = Mul(this, val);
		}

		public void operator/=(Value val) mut
		{
			this = Div(this, val);
		}



		// Binary arithmetic operators
		// ~~~~~~~~~~~~~~~~~~~~~~~~~~~

		public static Quat operator+(Quat p, Quat q)
		{
			return Add(p, q);
		}

		public static Quat operator+(Quat p, Value val)
		{
			return Add(p, val);
		}

		public static Quat operator-(Quat p, Quat q)
		{
			return Sub(p, q);
		}

		public static Quat operator-(Quat p, Value val)
		{
			return Sub(p, val);
		}

		public static Quat operator*(Quat p, Quat q)
		{
			return Mul(p, q);
		}

		public static Quat operator*(Quat p, Value val)
		{
			return Mul(p, val);
		}

		public static Quat operator/(Quat p, Value val)
		{
			return Div(p, val);
		}



		// Increment and decrement operators
		// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		public void operator++() mut
		{
			++this.X; ++this.Y; ++this.Z; ++this.W;
		}

		public void operator--() mut
		{
			--this.X; --this.Y; --this.Z; --this.W;
		}

		public static Quat operator++(Quat p)
		{
			return ++Quat(p);
		}

		public static Quat operator--(Quat p)
		{
			return --Quat(p);
		}


		// Logic operators
		// ~~~~~~~~~~~~~~~

		public static bool operator==(Quat p, Quat q)
		{
			return
				p.X == q.X &&
				p.Y == q.Y &&
				p.Z == q.Z &&
				p.W == q.W;
		}

		public static bool operator!=(Quat p, Quat q)
		{
			return !(p == q);
		}

		public static bool operator>(Quat p, Quat q)
		{
			return Length(p) > Length(q);
		}

		public static bool operator>=(Quat p, Quat q)
		{
			return p > q || p == q;
		}

		public static bool operator<(Quat p, Quat q)
		{
			return Length(p) < Length(q);
		}

		public static bool operator<=(Quat p, Quat q)
		{
			return p < q || p == q;
		}
	}
}
