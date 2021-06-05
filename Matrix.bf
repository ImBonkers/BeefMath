using System;
using System.Collections;

namespace BeefMath
{
	typealias Mat1 = Mat<const 1, const 1>;
	typealias Mat2 = Mat<const 2, const 2>;
	typealias Mat3 = Mat<const 3, const 3>;
	typealias Mat4 = Mat<const 4, const 4>;

	typealias Mat11 = Mat<const 1, const 1>;
	typealias Mat12 = Mat<const 1, const 2>;
	typealias Mat13 = Mat<const 1, const 3>;
	typealias Mat14 = Mat<const 1, const 4>;

	typealias Mat21 = Mat<const 2, const 1>;
	typealias Mat22 = Mat<const 2, const 2>;
	typealias Mat23 = Mat<const 2, const 3>;
	typealias Mat24 = Mat<const 2, const 4>;

	typealias Mat31 = Mat<const 3, const 1>;
	typealias Mat32 = Mat<const 3, const 2>;
	typealias Mat33 = Mat<const 3, const 3>;
	typealias Mat34 = Mat<const 3, const 4>;

	typealias Mat41 = Mat<const 4, const 1>;
	typealias Mat42 = Mat<const 4, const 2>;
	typealias Mat43 = Mat<const 4, const 3>;
	typealias Mat44 = Mat<const 4, const 4>;

	[Packed, CRepr]
	public struct Mat<RowSize, ColumnSize> : IEnumerable<Vec<RowSize>> where RowSize : const int where ColumnSize : const int
	{
		typealias Value = float;
		typealias Matrix = Mat<RowSize, ColumnSize>;
		typealias Row = Vec<RowSize>;
		typealias Col = Vec<ColumnSize>;

		public Vec<RowSize>[ColumnSize] data;

		public Row Row0 { get mut => GetRow(0); set mut { SetRow(0, value); } };
		public Row Row1 { get mut => GetRow(1); set mut { SetRow(1, value); } };
		public Row Row2 { get mut => GetRow(2); set mut { SetRow(2, value); } };
		public Row Row3 { get mut => GetRow(3); set mut { SetRow(3, value); } };

		public Col Col0 { get mut => GetColumn(0); set mut { SetColumn(0, value); } };
		public Col Col1 { get mut => GetColumn(1); set mut { SetColumn(1, value); } };
		public Col Col2 { get mut => GetColumn(2); set mut { SetColumn(2, value); } };
		public Col Col3 { get mut => GetColumn(3); set mut { SetColumn(3, value); } };

		public int RowCount { get => RowSize; };
		public int ColCount { get => ColumnSize; };

		public this()
		{
			data = .();
			int min;
			if (RowSize > ColumnSize)
				min = ColumnSize;
			else
				min = RowSize;
			for (var i < min)
			{
				data[i][i] = 1.0f;
			}
		}

		public this(Value f)
		{
			data = .();
			for (var i < RowSize)
			{
				data[i][i] = f;
			}
		}

		public this(params Row[] rows)
		{
			data = .();
			int min = Math.Min(rows.Count, ColumnSize);
			for (var i < min)
			{
				data[i] = rows[i];
			}
		}

		public this(Matrix other)
		{
			data = .();
			data = other.data;
		}

		public void* Ptr() mut
		{
			return &data;
		}



		// Enumeration
		// ~~~~~~~~~~~

		public Enumerator GetEnumerator()
		{
			return Enumerator(this);
		}

		public struct Enumerator : IEnumerator<Vec<RowSize>>
		{
			private Matrix m;

			private int current;

			public this(Mat<RowSize, ColumnSize> m)
			{
				this.m = m;
				current = 0;
			}

			private bool MoveNext() mut
			{
				if (current < m.RowCount)
				{
					return true;
				}
				return false;
			}

			public Result<Vec<RowSize>> GetNext() mut
			{
				return MoveNext() ? m.GetRow(current++) : .Err;
			}
		}



		// Indexer overload
		// ~~~~~~~~~~~~~~~~

		public ref Row this[int ind]
		{
			get mut => ref GetRow(ind);
			set mut => SetRow(ind, value);
		}

		private Result<int> GetRowIndexError(int ind)
		{
			if (ind < 0 && ind > RowSize)
				return .Err;
			return .Ok(ind);
		}

		private Result<int> GetColIndexError(int ind)
		{
			if (ind < 0 && ind > ColumnSize)
				return .Err;
			return .Ok(ind);
		}

		public ref Row GetRow(int ind) mut
		{
			switch (GetRowIndexError(ind))
			{
			case .Ok(let index): return ref data[index];
			case .Err: Console.WriteLine("Attempting to index to out of bounds location");
			}

			return ref Row();
		}

		public void SetRow(int ind, Row value) mut
		{
			switch (GetRowIndexError(ind))
			{
			case .Ok(let index): data[index] = value;
			case .Err: Console.WriteLine("Attempting to index to out of bounds location");
			}
		}

		public ref Col GetColumn(int ind) mut
		{
			Col col = .();
			switch (GetColIndexError(ind))
			{
			case .Ok(let index):
				for (var i < ColumnSize)
				{
					col[i] = data[i][index];
				}
			case .Err: Console.WriteLine("Attempting to index to out of bounds location");
			}
			return ref col;
		}

		public void SetColumn(int ind, Col v) mut
		{
			switch (GetColIndexError(ind))
			{
			case .Ok(let index):
				{
					Col tmp = v;
					for (var i < ColumnSize)
					{
						data[i][index] = tmp[i];
					}
				}
			case .Err: Console.WriteLine("Attempting to index to out of bounds location");
			}
		}

		public void SetValue(int row, int col, Value value) mut
		{
			switch (GetRowIndexError(row))
			{
			case .Ok(let rIndex):
				switch (GetColIndexError(col))
				{
				case .Ok(let cIndex): data[row][col] = value;
				case .Err: Console.WriteLine("Attempting to index to out of bounds location");
				}
			case .Err: Console.WriteLine("Attempting to index to out of bounds location");
			}
		}



		// Static arithmetic operators
		// ~~~~~~~~~~~~~~~~~~~~~~~~~~~

		public static Matrix Add(Matrix m, Matrix b)
		{
			Matrix result = m;
			for (var r < ColumnSize)
			{
				result[r] += b.data[r];
			}
			return result;
		}

		public static Matrix Add(Matrix m, Value val)
		{
			Matrix result = m;
			for (var r < ColumnSize)
			{
				result[r] += val;
			}
			return result;
		}

		public static Matrix Sub(Matrix m, Matrix b)
		{
			Matrix result = m;
			for (var r < ColumnSize)
			{
				result[r] -= b.data[r];
			}
			return result;
		}

		public static Matrix Sub(Matrix m, Value val)
		{
			Matrix result = m;
			for (var r < ColumnSize)
			{
				result[r] -= val;
			}
			return result;
		}

		public static Matrix Mul(Matrix m, Matrix b)
		{
			Matrix result = m;
			for (var r < ColumnSize)
			{
				result[r] *= b.data[r];
			}
			return result;
		}

		public static Matrix Mul(Matrix m, Value val)
		{
			Matrix result = m;
			for (var r < ColumnSize)
			{
				result[r] *= val;
			}
			return result;
		}

		public static Matrix Div(Matrix m, Matrix b)
		{
			Matrix result = m;
			for (var r < ColumnSize)
			{
				result[r] /= b.data[r];
			}
			return result;
		}

		public static Matrix Div(Matrix m, Value val)
		{
			Matrix result = m;
			for (var r < ColumnSize)
			{
				result[r] /= val;
			}
			return result;
		}

		public static Matrix Mod(Matrix m, Matrix b)
		{
			Matrix result = m;
			for (var r < ColumnSize)
			{
				result[r] %= b.data[r];
			}
			return result;
		}

		public static Matrix Mod(Matrix m, Value val)
		{
			Matrix result = m;
			for (var r < ColumnSize)
			{
				result[r] %= val;
			}
			return result;
		}

		public static Mat<NewRowSize, ColumnSize> MatMult<NewRowSize>(Mat<RowSize, ColumnSize> a, Mat<NewRowSize, RowSize> b) where NewRowSize : const int
		{
			Mat<NewRowSize, ColumnSize> newM = .();
			Mat<RowSize, ColumnSize> tmpa = a;
			Mat<NewRowSize, RowSize> tmpb = b;
			for (var r < ColumnSize)
			{
				for (var c < NewRowSize)
				{
					Value value = tmpa.GetRow(r).Dot(tmpb.GetColumn(c));
					newM.SetValue(r, c, value);
				}
			}
			return newM;
		}

		public static Mat<ColumnSize, RowSize> Transpose(Mat<RowSize, ColumnSize> m)
		{
			return Mat.Transpose<const RowSize, const ColumnSize>(m);
		}



		// non-static methods
		// ~~~~~~~~~~~~~~~~~~

		public Mat<ColumnSize, RowSize> Transpose()
		{
			return Mat.Transpose<const RowSize, const ColumnSize>(this);
		}

		public float Det()
		{
			return Mat.Det<const RowSize, const ColumnSize>(this);
		}


		// Unary arithmetic operators
		// ~~~~~~~~~~~~~~~~~~~~~~~~~~

		public static Matrix operator+(Matrix a)
		{
			return a;
		}

		public static Matrix operator-(ref Matrix a)
		{
			Matrix tmp = a;
			for (var i < ColumnSize)
			{
				tmp.data[i] = -tmp.data[i];
			}
			return tmp;
		}

		public void operator+=(Matrix other) mut
		{
			this = Add(this, other);
		}

		public void operator+=(Value val) mut
		{
			this = Add(this, val);
		}

		public void operator-=(Matrix other) mut
		{
			this = Sub(this, other);
		}

		public void operator-=(Value val) mut
		{
			this = Sub(this, val);
		}

		public void operator*=(Value val) mut
		{
			this = Mul(this, val);
		}

		public void operator/=(Matrix other) mut
		{
			this = Div(this, other);
		}

		public void operator/=(Value val) mut
		{
			this = Div(this, val);
		}

		public void operator%=(Matrix other) mut
		{
			this = Mod(this, other);
		}

		public void operator%=(Value val) mut
		{
			this = Mod(this, val);
		}



		// Binary arithemtic operators
		// ~~~~~~~~~~~~~~~~~~~~~~~~~~~

		public static Matrix operator+(Matrix a, Matrix b)
		{
			return Add(a, b);
		}

		public static Matrix operator+(Matrix m, Value val)
		{
			return Add(m, val);
		}

		public static Matrix operator-(Matrix a, Matrix b)
		{
			return Sub(a, b);
		}

		public static Matrix operator-(Matrix m, Value val)
		{
			return Sub(m, val);
		}

		public static Mat<NewRowSize, ColumnSize> operator*<NewRowSize>(Mat<RowSize, ColumnSize> a, Mat<NewRowSize, RowSize> b) where NewRowSize : const int
		{
			return MatMult<const NewRowSize>(a, b);
		}

		public static Matrix operator*(Matrix m, Value val)
		{
			return Mul(m, val);
		}

		public static Matrix operator/(Matrix a, Matrix b)
		{
			return Div(a, b);
		}

		public static Matrix operator/(Matrix m, Value val)
		{
			return Div(m, val);
		}

		public static Matrix operator%(Matrix a, Matrix b)
		{
			return Mod(a, b);
		}

		public static Matrix operator%(Matrix v, Value val)
		{
			return Mod(v, val);
		}



		// Increment and decrement operators
		// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		public void operator++() mut
		{
			for (var i < ColumnSize)
			{
				++data[i];
			}
		}

		public void operator--() mut
		{
			for (var i < ColumnSize)
			{
				--data[i];
			}
		}

		public static Matrix operator++(Matrix m)
		{
			return ++Matrix(m);
		}

		public static Matrix operator--(Matrix m)
		{
			return --Matrix(m);
		}



		// Logic operators
		// ~~~~~~~~~~~~~~~

		public static bool operator==(Matrix p, Matrix q)
		{
			bool result;
			for (var r < ColumnSize)
				result = p.data[r] == q.data[r];
			return result;
		}

		public static bool operator!=(Matrix p, Matrix q)
		{
			return !(p == q);
		}
	}
}
