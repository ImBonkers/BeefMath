using System;

namespace BeefMath
{
	public static class Mat
	{
		public static float Det(Mat<const 2, const 2> m)
		{
			Mat<const 2, const 2> tmp = m;
			return tmp[0][0] * tmp[1][1] - tmp[1][0] * tmp[0][1];
		}

		public static float Det(Mat<const 3, const 3> m)
		{
			Mat<const 3, const 3> tmp = m;
			return
				tmp[0][0] * (tmp[1][1] * tmp[2][2] - tmp[2][1] * tmp[1][2])
				- tmp[1][0] * (tmp[0][1] * tmp[2][2] - tmp[2][1] * tmp[0][2])
				+ tmp[2][0] * (tmp[0][1] * tmp[1][2] - tmp[1][1] * tmp[0][2]);
		}

		public static float Det(Mat<const 4, const 4> m)
		{
			Mat<const 4, const 4> tmp = m;
			float SubFactor00 = tmp[2][2] * tmp[3][3] - tmp[3][2] * tmp[2][3];
			float SubFactor01 = tmp[2][1] * tmp[3][3] - tmp[3][1] * tmp[2][3];
			float SubFactor02 = tmp[2][1] * tmp[3][2] - tmp[3][1] * tmp[2][2];
			float SubFactor03 = tmp[2][0] * tmp[3][3] - tmp[3][0] * tmp[2][3];
			float SubFactor04 = tmp[2][0] * tmp[3][2] - tmp[3][0] * tmp[2][2];
			float SubFactor05 = tmp[2][0] * tmp[3][1] - tmp[3][0] * tmp[2][1];

			Vec<const 4> DetCof = .(
				+(tmp[1][1] * SubFactor00 - tmp[1][2] * SubFactor01 + tmp[1][3] * SubFactor02),
				-(tmp[1][0] * SubFactor00 - tmp[1][2] * SubFactor03 + tmp[1][3] * SubFactor04),
				+(tmp[1][0] * SubFactor01 - tmp[1][1] * SubFactor03 + tmp[1][3] * SubFactor05),
				-(tmp[1][0] * SubFactor02 - tmp[1][1] * SubFactor04 + tmp[1][2] * SubFactor05));

			return
				tmp[0][0] * DetCof[0] + tmp[0][1] * DetCof[1] +
				tmp[0][2] * DetCof[2] + tmp[0][3] * DetCof[3];
		}

		public static float Det<R, C>(Mat<R, C> m) where R : const int where C : const int
		{
			if (R != C)
				return 0.0f;
			if (R < 2)
				return 0.0f;

			Mat<R, C> newM = m;
			float[] data = scope float[R * C];
			for (var val < R * C)
			{
				data[val] = ((float*)newM.Ptr())[val];
			}

			return DeterminantHelper(R, C, data);
		}

		private static float DeterminantHelper(int row, int col, float[] data)
		{
			float result = 0.0f;
			switch (row)
			{
			case 2: result = data[0] * data[3] - data[1] * data[2];
			case 3:
				{
					result = data[0] * (data[4] * data[8] - data[7] * data[5])
						- data[3] * (data[1] * data[8] - data[7] * data[2])
						+ data[6] * (data[1] * data[5] - data[4] * data[2]);
				}
			case 4:
				{
					float SubFactor00 = data[10] * data[15] - data[14] * data[11];
					float SubFactor01 = data[9] * data[15] - data[13] * data[11];
					float SubFactor02 = data[9] * data[14] - data[13] * data[10];
					float SubFactor03 = data[8] * data[15] - data[12] * data[11];
					float SubFactor04 = data[8] * data[14] - data[12] * data[10];
					float SubFactor05 = data[8] * data[13] - data[12] * data[9];

					Vec4 DetCof = .(
						+(data[5] * SubFactor00 - data[6] * SubFactor01 + data[7] * SubFactor02),
						-(data[4] * SubFactor00 - data[6] * SubFactor03 + data[7] * SubFactor04),
						+(data[4] * SubFactor01 - data[5] * SubFactor03 + data[7] * SubFactor05),
						-(data[4] * SubFactor02 - data[5] * SubFactor04 + data[6] * SubFactor05));

					result =
						data[0] * DetCof[0] + data[1] * DetCof[1] +
						data[2] * DetCof[2] + data[3] * DetCof[3];
				}
			case default:
				{
					int sign = 1;
					for (var r < row)
					{
						float[] newData = scope float[(row - 1) * (col - 1)];
						int index = 0;
						for (var val = row; val < row * col; val++)
						{
							if (val % row != r)
							{
								newData[index++] = data[val];
							}
						}
						if (data[r] != 0)
						{
							result += sign * data[r] * DeterminantHelper(row - 1, col - 1, newData);
						}
						sign = -sign;
					}
				}
			}
			return result;
		}

		public static Mat<C, R> Transpose<R, C>(Mat<R, C> m) where R : const int where C : const int
		{
			Mat<R, C> M = m;
			Mat<C, R> newM = .();
			for (var r < C)
			{
				newM.SetColumn(r, M.GetRow(r));
			}
			return newM;
		}

		public static Mat4 Frustum(float left, float right, float bottom, float top, float near, float far)
		{
			Mat4 result = .(0.0f);
			result[0][0] = (2.0f * near) / (right - left);
			result[1][1] = (2.0f * near) / (top - bottom);
			result[2][0] = (right + left) / (right - left);
			result[2][1] = (top + bottom) / (top - bottom);
			result[2][2] = -(far + near) / (far - near);
			result[2][3] = -1.0f;
			result[3][2] = -(2.0f * far * near) / (far - near);
			return result;
		}

		public static Mat4 PerspectiveComplex(float fov, float ratio, float near, float far)
		{
			float top, bottom, left, right;
			top = near * Math.Tan(fov * (Math.PI_f / 180.0f) / 2.0f);
			bottom = -top;
			right = top * ratio;
			left = -right;

			return Frustum(left, right, top, bottom, near, far);
		}

		public static Mat4 Perspective(float fov, float ratio, float near, float far)
		{
			float tanHalfFov = Math.Tan(fov / 2.0f);

			Mat4 result = .(0.0f);
			result[0][0] = 1.0f / (ratio * tanHalfFov);
			result[1][1] = 1.0f / tanHalfFov;
			result[2][2] = -(far + near) / (far - near);
			result[2][3] = -1.0f;
			result[3][2] = -(2.0f * far * near) / (far - near);
			return result;
		}

		public static Mat4 Ortho(float left, float right, float bottom, float top, float near, float far)
		{
			Mat4 result = .(1.0f);
			result[0][0] = 2.0f / (right - left);
			result[1][1] = 2.0f / (top - bottom);
			result[2][2] = -2.0f / (far - near);
			result[3][0] = -(right + left) / (right - left);
			result[3][1] = -(top + bottom) / (top - bottom);
			result[3][2] = -(far + near) / (far - near);
			return result;
		}
	}
}
