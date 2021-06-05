using System;
using System.Diagnostics;

namespace BeefMath
{
	class Tests
	{
		public static void VecAlignment<D>(ref Vec<D> v, String str = "") where D : const int
		{
			float* ptr = (float*)v.Ptr();
			Console.Write(str);
			for (var i < D - 1)
			{
				Console.Write("{}, ", ptr[i]);
			}

			Console.Write("{}\n", ptr[D - 1]);
		}

		public static void VecMemoryAlignment<D>(ref Vec<D> v, String str = "") where D : const int
		{
			float* ptr = (float*)v.Ptr();
			Console.Write(str);
			for (var i < D - 1)
			{
				Console.Write("{} ", ptr[i]);
			}
			Console.Write("{}\n", ptr[D - 1]);
		}

		public static void MatrixAlignment<R, C>(Mat<R, C> m, String str = "") where R : const int where C : const int
		{
			Mat<R, C> tmp = m;
			float* ptr = (float*)tmp.Ptr();
			Console.Write(str);
			for (var r < C)
			{
				for (var c < R - 1)
				{
					Console.Write("{}, ", ptr[c + r * R]);
				}
				Console.Write("{}\n", ptr[R - 1 + r * R]);
			}
		}

		public static void MatrixMemoryAlignment<R, C>(Mat<R, C> m, String str = "") where R : const int where C : const int
		{
			Mat<R, C> tmp = m;
			float* ptr = (float*)tmp.Ptr();
			Console.Write(str);
			for (var i < R * C - 1)
			{
				Console.Write("{} ", ptr[i]);
			}
			Console.Write("{}\n", ptr[R * C - 1]);
		}

		public static void Vec3Index(ref Vec3 v, String str = "")
		{
			Console.WriteLine("{}: {}, {}, {}", str, v[0], v[1], v[2]);
		}

		public static void Vec4Index(ref Vec4 v, String str = "")
		{
			Console.WriteLine("{}: {}, {}, {}, {}", str, v[0], v[1], v[2], v[3]);
		}

		public static void FloatValue(float f, String str = "")
		{
			Console.WriteLine("{}: {}", str, f);
		}

		public static void TestVec4()
		{
			Vec4 a = .(1, 2, 3, 4);
			Vec4 b = .(1, 2, 3, 4);

			Debug.Assert(Vec4(1, 2, 3, 4) == Vec4(1, 2, 3, 4));
			Debug.Assert(Vec4(1, 2, 3, 4) != Vec4(1, 1, 1, 1));
			Debug.Assert(Vec4(1, 1, 1, 1) < Vec4(1, 2, 3, 4));
			Debug.Assert(Vec4(1, 1, 1, 1) <= Vec4(1, 2, 3, 4));
			Debug.Assert(Vec4(1, 2, 3, 4) <= Vec4(1, 2, 3, 4));
			Debug.Assert(Vec4(1, 2, 3, 4) > Vec4(1, 1, 1, 1));
			Debug.Assert(Vec4(1, 2, 3, 4) >= Vec4(1, 1, 1, 1));
			Debug.Assert(Vec4(1, 2, 3, 4) >= Vec4(1, 2, 3, 4));

			// Arithmetic operators
			Debug.Assert((a + b) == .(2, 4, 6, 8));
			Debug.Assert((a + 12f) == .(13, 14, 15, 16));
			Debug.Assert((Vec4(a) += b) == .(2, 4, 6, 8));
			Debug.Assert((Vec4(a) += 12f) == .(13, 14, 15, 16));

			Debug.Assert((a - b) == .(0, 0, 0, 0));
			Debug.Assert((a - 12f) == .(-11, -10, -9, -8));
			Debug.Assert((Vec4(a) -= b) == .(0, 0, 0, 0));
			Debug.Assert((Vec4(a) -= 12f) == .(-11, -10, -9, -8));

			Debug.Assert((a * b) == .(1, 4, 9, 16));
			Debug.Assert((a * 12f) == .(12, 24, 36, 48));
			Debug.Assert((Vec4(a) *= b) == .(1, 4, 9, 16));
			Debug.Assert((Vec4(a) *= 12f) == .(12, 24, 36, 48));

			Debug.Assert((a / 2f) == .(0.5f, 1, 1.5f, 2));
			Debug.Assert((Vec4(a) /= 2f) == .(0.5f, 1, 1.5f, 2));

			Debug.Assert((-a) == .(-1, -2, -3, -4));
			Debug.Assert((+a) == .(1, 2, 3, 4));

			// Increment and decrement
			Debug.Assert((++a) == .(2, 3, 4, 5));
			Debug.Assert((--a) == .(1, 2, 3, 4));

			// Vector Math
			Debug.Assert(a.Dot(b) == 30);
			Debug.Assert(a.Length() == Math.Sqrt(30));
			Debug.Assert(a.Normalize() == .(0.182574183f, 0.365148365f, 0.547722518f, 0.730296731f));
			Debug.Assert(Vec4(1, 2, 3).Cross(.(3, 2, 1)) == .(-4, 8, -4));
			Debug.Assert(a.Mix(.(4, 3, 2, 1), 0.72f) == .(3.16000009f, 2.72000003f, 2.27999997f, 1.83999991f));
			Debug.Assert(a.Reflect(.(5, 3, 1, 2)) == .(-219, -130, -41, -84));
			Debug.Assert(a.Refract(.(5, 3, 1, 2), 0.45f) == .(-98.7509766f, -58.6205826f, -18.4901943f, -37.8803902f));
		}

		public static void TestQuat()
		{
			// Quat tests
			// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			BeefMath.Quat p = .(1, 2, 3, 4);
			BeefMath.Quat q = .(1, 2, 3, 4);

			// Logic operators
			Debug.Assert(Quat(1, 2, 3, 4) == Quat(1, 2, 3, 4));
			Debug.Assert(Quat(1, 2, 3, 4) != Quat(1, 1, 1, 1));
			Debug.Assert(Quat(1, 1, 1, 1) < Quat(1, 2, 3, 4));
			Debug.Assert(Quat(1, 1, 1, 1) <= Quat(1, 2, 3, 4));
			Debug.Assert(Quat(1, 2, 3, 4) <= Quat(1, 2, 3, 4));
			Debug.Assert(Quat(1, 2, 3, 4) > Quat(1, 1, 1, 1));
			Debug.Assert(Quat(1, 2, 3, 4) >= Quat(1, 1, 1, 1));
			Debug.Assert(Quat(1, 2, 3, 4) >= Quat(1, 2, 3, 4));

			// Arithmetic operators
			Debug.Assert((p + q) == .(2, 4, 6, 8));
			Debug.Assert((p + 12f) == .(13, 14, 15, 16));
			Debug.Assert((Quat(p) += q) == .(2, 4, 6, 8));
			Debug.Assert((Quat(p) += 12f) == .(13, 14, 15, 16));

			Debug.Assert((p - q) == .(0, 0, 0, 0));
			Debug.Assert((p - 12f) == .(-11, -10, -9, -8));
			Debug.Assert((Quat(p) -= q) == .(0, 0, 0, 0));
			Debug.Assert((Quat(p) -= 12f) == .(-11, -10, -9, -8));

			Debug.Assert((p * q) == .(8, 16, 24, 2));
			Debug.Assert((p * 12f) == .(12, 24, 36, 48));
			Debug.Assert((Quat(p) *= q) == .(8, 16, 24, 2));
			Debug.Assert((Quat(p) *= 12f) == .(12, 24, 36, 48));

			Debug.Assert((p / 2f) == .(0.5f, 1, 1.5f, 2));
			Debug.Assert((Quat(p) /= 2f) == .(0.5f, 1, 1.5f, 2));

			Debug.Assert((-p) == .(-1, -2, -3, -4));
			Debug.Assert((+p) == .(1, 2, 3, 4));

			// Increment and decrement
			Debug.Assert((++p) == .(2, 3, 4, 5));
			Debug.Assert((--p) == .(1, 2, 3, 4));

			// Quaternion math
			Debug.Assert(p.Dot(q) == 30);
			Debug.Assert(p.Length() == Math.Sqrt(30));// 30 is sum of squares of 1, 2, 3, and 4
			Debug.Assert(p.Normalize() == .(0.182574183f, 0.365148365f, 0.547722518f, 0.730296731f));
			Debug.Assert(p.Mix(.(4, 3, 2, 1), 0.15f) == .(1.45f, 2.15f, 2.85000014f, 3.55000019f));
			Debug.Assert(p.Lerp(.(4, 3, 2, 1), 0.36f) == .(2.08f, 2.36000013f, 2.63999987f, 2.92f));
			Debug.Assert(p.Slerp(.(4, 3, 2, 1), 0.87f) == .(3.61000013f, 2.87000012f, 2.13000011f, 1.38999999f));
			Debug.Assert(p.Conjugate() == .(-p.X, -p.Y, -p.Z, p.W));
			Debug.Assert(p.Inverse() == .(-0.0333333351f, -0.0666666701f, -0.100000001f, 0.13333334f));
		}

		public static void TestMatrices()
		{
			// Matrix test

			Mat4 m1 =
				.(Vec4(1, 2, 3, 4),
				Vec4(2, 3, 4, 5),
				Vec4(3, 4, 5, 6),
				Vec4(4, 5, 6, 7));
			Mat4 m2 =
				.(Vec4(4, 3, 2, 1),
				Vec4(5, 4, 3, 2),
				Vec4(6, 5, 4, 3),
				Vec4(7, 6, 5, 4));

			MatrixAlignment(m1, "m1");
			MatrixAlignment(m2, "m2");

			// Logic operators
			Debug.Assert(Mat4(1) == Mat4(1));
			Debug.Assert(Mat4(1) != Mat4(123));

			// Arithmetic operators
			Debug.Assert((m1 + m2) == .(Vec4(5), Vec4(7), Vec4(9), Vec4(11)));
			Debug.Assert((m1 + 12f) == .(Vec4(13, 14, 15, 16), Vec4(14, 15, 16, 17), Vec4(15, 16, 17, 18), Vec4(16, 17, 18, 19)));
			Debug.Assert((Mat4(m1) += m2) == .(Vec4(5), Vec4(7), Vec4(9), Vec4(11)));
			Debug.Assert((Mat4(m1) += 12f) == .(Vec4(13, 14, 15, 16), Vec4(14, 15, 16, 17), Vec4(15, 16, 17, 18), Vec4(16, 17, 18, 19)));

			Debug.Assert((m1 - m2) == .(Vec4(-3, -1, 1, 3), Vec4(-3, -1, 1, 3), Vec4(-3, -1, 1, 3), Vec4(-3, -1, 1, 3)));
			Debug.Assert((m1 - 12f) == .(Vec4(-11, -10, -9, -8), Vec4(-10, -9, -8, -7), Vec4(-9, -8, -7, -6), Vec4(-8, -7, -6, -5)));
			Debug.Assert((Mat4(m1) -= m2) == .(Vec4(-3, -1, 1, 3), Vec4(-3, -1, 1, 3), Vec4(-3, -1, 1, 3), Vec4(-3, -1, 1, 3)));
			Debug.Assert((Mat4(m1) -= 12f) == .(Vec4(-11, -10, -9, -8), Vec4(-10, -9, -8, -7), Vec4(-9, -8, -7, -6), Vec4(-8, -7, -6, -5)));

			Debug.Assert((m1 * m2) == .(Vec4(60, 50, 40, 30), Vec4(82, 68, 54, 40), Vec4(104, 86, 68, 50), Vec4(126, 104, 82, 60)));
			Debug.Assert((m1 * 12f) == .(Vec4(12, 24, 36, 48), Vec4(24, 36, 48, 60), Vec4(36, 488, 60, 72), Vec4(48, 60, 72, 84)));
			Debug.Assert((Mat4(m1) *= m2) == .(Vec4(60, 50, 40, 30), Vec4(82, 68, 54, 40), Vec4(104, 86, 68, 50), Vec4(126, 104, 82, 60)));
			Debug.Assert((Mat4(m1) *= 12f) == .(Vec4(12, 24, 36, 48), Vec4(24, 36, 48, 60), Vec4(36, 488, 60, 72), Vec4(48, 60, 72, 84)));

			Debug.Assert((m1 / 2f) == .(Vec4(0.5f, 1, 1.5f, 2), Vec4(1, 1.5f, 2, 2.5f), Vec4(1.5f, 2, 2.5f, 3), Vec4(2, 2.5f, 3, 3.5f)));
			Debug.Assert((Mat4(m1) /= 2f) == .(Vec4(0.5f, 1, 1.5f, 2), Vec4(1, 1.5f, 2, 2.5f), Vec4(1.5f, 2, 2.5f, 3), Vec4(2, 2.5f, 3, 3.5f)));

			Debug.Assert((-m1) == .(Vec4(-1, -2, -3, -4), Vec4(-2, -3, -4, -5), Vec4(-3, -4, -5, -6), Vec4(-4, -5, -6, -7)));
			Debug.Assert((+m1) == m1);

			// Increment and decrement
			Debug.Assert((++m1) == .(Vec4(2, 3, 4, 5), Vec4(3, 4, 5, 6), Vec4(4, 5, 6, 7), Vec4(5, 6, 7, 8)));
			Debug.Assert((--m1) == .(Vec4(1, 2, 3, 4), Vec4(2, 3, 4, 5), Vec4(3, 4, 5, 6), Vec4(4, 5, 6, 7)));

			// Matrix functions
			Debug.Assert(Mat2(Vec2(3, 2), Vec2(2, 1)).Det() == -1);
			Debug.Assert(Mat3(Vec3(3, 2, 3), Vec3(2, 1, 1), Vec3(4, 3, 2)).Det() == 3);
			Debug.Assert(Mat4(Vec4(3, 7, 6, 5), Vec4(9, 5, 34, 9), Vec4(0, 6, 7, 0), Vec4(5, 34, 2, 3)).Det() == 7006);
			Debug.Assert(Mat32(Vec3(1, 2, 3), Vec3(4, 5, 6)).Transpose() == Mat23(Vec2(1, 4), Vec2(2, 5), Vec2(3, 6)));
		}
	}
}
