using System;
using System.Collections;

namespace BeefMath
{
	typealias Vec1 = Vec<const 1>;
	typealias Vec2 = Vec<const 2>;
	typealias Vec3 = Vec<const 3>;
	typealias Vec4 = Vec<const 4>;

	[Packed, CRepr]
	public struct Vec<D> where D : const int
	{
		typealias Value = float;

		private Value[D] data;

		public Value X { get => data[0]; set mut { data[0] = value; } };
		public Value Y { get => data[1]; set mut { data[1] = value; } };
		public Value Z { get => data[2]; set mut { data[2] = value; } };
		public Value W { get => data[3]; set mut { data[3] = value; } };

		public Value R { get => data[0]; set mut { data[0] = value; } };
		public Value G { get => data[1]; set mut { data[1] = value; } };
		public Value B { get => data[2]; set mut { data[2] = value; } };
		public Value A { get => data[3]; set mut { data[3] = value; } };

		public Value U { get => data[0]; set mut { data[0] = value; } };
		public Value V { get => data[1]; set mut { data[1] = value; } };

		public int Size { get => D; };

		public this()
		{
			data = .();
		}

		public this(Value s)
		{
			data = .();
			for (var i < D)
			{
				data[i] = s;
			}
		}

		public this(params Value[] values)
		{
			data = .();
			int min = Math.Min(values.Count, D);
			for (var i < min)
			{
				data[i] = values[i];
			}
		}

		public this(Vec<D> other)
		{
			data = .();
			data = other.data;
		}



		// Enumeration
		// ~~~~~~~~~~~

		public Enumerator GetEnumerator()
		{
			return Enumerator(this);
		}

		public struct Enumerator : IEnumerator<Value>
		{
			private Vec<D> v;

			private int current;

			public this(Vec<D> v)
			{
				this.v = v;
				current = 0;
			}

			private bool MoveNext() mut
			{
				if (current < v.Size)
				{
					return true;
				}
				return false;
			}

			public Result<Value> GetNext() mut
			{
				return MoveNext() ? v.GetValue(current++) : .Err;
			}
		}

		// Static methods
		// ~~~~~~~~~~~~~~

		public void* Ptr() mut
		{
			return &data;
		}



		// Indexer overload
		// ~~~~~~~~~~~~~~~~

		public ref Value this[int ind]
		{
			get mut => ref GetValue(ind);
			set mut => SetValue(ind, value);
		}

		private Result<int> GetValueError(int ind)
		{
			if (ind < 0 && ind > D)
				return .Err;
			return .Ok(ind);
		}

		private ref Value GetValue(int ind) mut
		{
			switch (GetValueError(ind))
			{
			case .Ok(let index): return ref data[index];
			case .Err: Console.WriteLine("Trying to access out of bound value in Vec");
			}

			Value tmp = 0.0f;
			return ref tmp;
		}

		private void SetValue(int ind, Value value) mut
		{
			switch (GetValueError(ind))
			{
			case .Ok(let index): data[index] = value;
			case .Err: Console.WriteLine("Trying write to out of bound value in Vec");
			}
		}



		// Static arithmetic operators
		// ~~~~~~~~~~~~~~~~~~~~~~~~~~~

		public static Vec<D> Add(Vec<D> a, Vec<D> b)
		{
			Vec<D> result = a;
			for (var i < D)
			{
				result[i] += b.data[i];
			}
			return result;
		}

		public static Vec<D> Add(Vec<D> a, Value val)
		{
			Vec<D> result = a;
			for (var i < D)
			{
				result[i] += val;
			}
			return result;
		}

		public static Vec<D> Sub(Vec<D> a, Vec<D> b)
		{
			Vec<D> result = a;
			for (var i < D)
			{
				result[i] -= b.data[i];
			}
			return result;
		}

		public static Vec<D> Sub(Vec<D> a, Value val)
		{
			Vec<D> result = a;
			for (var i < D)
			{
				result[i] -= val;
			}
			return result;
		}

		public static Vec<D> Mul(Vec<D> a, Vec<D> b)
		{
			Vec<D> result = a;
			for (var i < D)
			{
				result[i] *= b.data[i];
			}
			return result;
		}

		public static Vec<D> Mul(Vec<D> a, Value val)
		{
			Vec<D> result = a;
			for (var i < D)
			{
				result[i] *= val;
			}
			return result;
		}

		public static Vec<D> Div(Vec<D> a, Vec<D> b)
		{
			Vec<D> result = a;
			for (var i < D)
			{
				result[i] /= b.data[i];
			}
			return result;
		}

		public static Vec<D> Div(Vec<D> a, Value val)
		{
			Vec<D> result = a;
			for (var i < D)
			{
				result[i] /= val;
			}
			return result;
		}

		public static Vec<D> Mod(Vec<D> a, Vec<D> b)
		{
			Vec<D> result = a;
			for (var i < D)
			{
				result[i] %= b.data[i];
			}
			return result;
		}

		public static Vec<D> Mod(Vec<D> a, Value val)
		{
			Vec<D> result = a;
			for (var i < D)
			{
				result[i] %= val;
			}
			return result;
		}

		public static Value Dot(Vec<D> a, Vec<D> b)
		{
			Value total = 0.0f;
			for (var i < D)
			{
				total += a.data[i] * b.data[i];
			}
			return total;
		}

		public static Value Length(Vec<D> v)
		{
			return Math.Sqrt(Dot(v, v));
		}

		public static Vec<D> Normalize(Vec<D> v)
		{
			Value denominator = 1.0f / Length(v);
			return v * denominator;
		}

		public static Vec3 Cross(Vec3 a, Vec3 b)
		{
			Vec3 tmp = .();
			tmp.X = a.Y * b.Z - b.Y * a.Z;
			tmp.Y = a.Z * b.X - b.Z * a.X;
			tmp.Z = a.X * b.Y - b.X * a.Y;
			return tmp;
		}

		public static Vec<D> Mix(Vec<D> a, Vec<D> b, Value val)
		{
			Value cosTheta = Dot(a, b);

			if (cosTheta > 1.0f - Value.Epsilon)
			{
				Vec<D> tmp = .();
				Vec<D> acpy = a;
				Vec<D> bcpy = b;
				for (var i < D)
					tmp[i] = Scalar.Mix(acpy[i], bcpy[i], val);

				return tmp;
			}
			else
			{
				Value angle = Math.Acos(cosTheta);
				return (Math.Sin((1.0f - val) * angle) * a + Math.Sin(val * angle) * b) / Math.Sin(angle);
			}
		}

		public static Vec<D> Reflect(Vec<D> i, Vec<D> normal)
		{
			return i - normal * Dot(normal, i) * 2.0f;
		}

		public static Vec<D> Refract(Vec<D> v, Vec<D> normal, Value eta)
		{
			Value dotValue = Dot(normal, v);
			Value k = 1.0f - (eta * eta) * (1.0f - dotValue * dotValue);
			return (k >= 0.0f) ? (eta * v - (eta * dotValue + Math.Sqrt(k)) * normal) : .(0.0f);
		}



		// Non-static methods
		// ~~~~~~~~~~~~~~~~~~

		public Value Dot(Vec<D> other)
		{
			return Dot(this, other);
		}

		public Value Length()
		{
			return Length(this);
		}

		public Vec<D> Normalize()
		{
			return Normalize(this);
		}

		public Vec3 Cross(Vec3 other)
		{
			return Cross(.(this.X, this.Y, this.Z), other);
		}

		public Vec<D> Mix(Vec<D> a, Value val)
		{
			return Mix(this, a, val);
		}

		public Vec<D> Reflect(Vec<D> normal)
		{
			return Reflect(this, normal);
		}

		public Vec<D> Refract(Vec<D> normal, Value eta)
		{
			return Refract(this, normal, eta);
		}


		// Unary arithmetic operators
		// ~~~~~~~~~~~~~~~~~~~~~~~~~~

		public static Vec<D> operator+(Vec<D> a)
		{
			return a;
		}

		public static Vec<D> operator-(ref Vec<D> a)
		{
			Vec<D> tmp = a;
			for (var i < D)
			{
				tmp.data[i] = -tmp.data[i];
			}
			return tmp;
		}

		public void operator+=(Vec<D> other) mut
		{
			this = Add(this, other);
		}

		public void operator+=(Value val) mut
		{
			this = Add(this, val);
		}

		public void operator-=(Vec<D> other) mut
		{
			this = Sub(this, other);
		}

		public void operator-=(Value f) mut
		{
			this = Sub(this, f);
		}

		public void operator*=(Vec<D> other) mut
		{
			this = Mul(this, other);
		}

		public void operator*=(Value val) mut
		{
			this = Mul(this, val);
		}

		public void operator/=(Vec<D> other) mut
		{
			this = Div(this, other);
		}

		public void operator/=(Value val) mut
		{
			this = Div(this, val);
		}

		public void operator%=(Vec<D> other) mut
		{
			this = Mod(this, other);
		}

		public void operator%=(Value val) mut
		{
			this = Mod(this, val);
		}



		// Binary arithmetic operators
		// ~~~~~~~~~~~~~~~~~~~~~~~~~~~

		public static Vec<D> operator+(Vec<D> a, Vec<D> b)
		{
			return Add(a, b);
		}

		public static Vec<D> operator+(Vec<D> v, Value val)
		{
			return Add(v, val);
		}

		public static Vec<D> operator-(Vec<D> a, Vec<D> b)
		{
			return Sub(a, b);
		}

		public static Vec<D> operator-(Vec<D> v, Value val)
		{
			return Sub(v, val);
		}

		public static Vec<D> operator*(Vec<D> a, Vec<D> b)
		{
			return Mul(a, b);
		}

		public static Vec<D> operator*(Vec<D> v, Value val)
		{
			return Mul(v, val);
		}

		public static Vec<D> operator/(Vec<D> a, Vec<D> b)
		{
			return Div(a, b);
		}

		public static Vec<D> operator/(Vec<D> v, Value val)
		{
			return Div(v, val);
		}

		public static Vec<D> operator%(Vec<D> a, Vec<D> b)
		{
			return Mod(a, b);
		}

		public static Vec<D> operator%(Vec<D> v, Value val)
		{
			return Mod(v, val);
		}



		// Increment and decrement operators
		// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		public void operator++() mut
		{
			for (var i < D)
			{
				++data[i];
			}
		}

		public void operator--() mut
		{
			for (var i < D)
			{
				--data[i];
			}
		}

		public static Vec<D> operator++(Vec<D> v)
		{
			return ++Vec<const D>(v);
		}

		public static Vec<D> operator--(Vec<D> v)
		{
			return --Vec<const D>(v);
		}



		// Logic operators
		// ~~~~~~~~~~~~~~~

		public static bool operator==(Vec<D> a, Vec<D> b)
		{
			bool result;
			for (var i < D)
				result = a.data[i] == b.data[i];
			return result;
		}

		public static bool operator!=(Vec<D> a, Vec<D> b)
		{
			return !(a == b);
		}

		public static bool operator>(Vec<D> a, Vec<D> b)
		{
			return Length(a) > Length(b);
		}

		public static bool operator>=(Vec<D> a, Vec<D> b)
		{
			return a > b || a == b;
		}

		public static bool operator<(Vec<D> a, Vec<D> b)
		{
			return Length(a) < Length(b);
		}

		public static bool operator<=(Vec<D> a, Vec<D> b)
		{
			return a < b || a == b;
		}
	}
}
