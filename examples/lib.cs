using System;
using System.Collections.Generic;
using System.Linq;

namespace Lib {
  public static class Stuff {
    public static IEnumerable<T> WhereNot<T>( this IEnumerable<T> @this, Func<T, bool> fn )
      => @this.Where( t => !fn( t ) );

    public static IEnumerable<int> Fibonacci( int x0, int x1 ) {
      while (true) {
        var next = x0 + x1;
        x0 = x1;
        x1 = next;
        yield return next;
      }
    }

    public static bool IsEven( int x ) => x%2 == 0;
  }
}
