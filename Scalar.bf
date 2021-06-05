using System;

namespace BeefMath
{
	struct Scalar
	{
		typealias Value = float;

		public static float Mix(Value x, Value y, Value a)
		{
			return x * (1 - a) + y * a;
		}
	}
}
