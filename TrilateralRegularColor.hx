package;
import trilateralChange.AppGL;

// Color pallettes
import pallette.QuickARGB;
import pallette.Gold;
import pallette.PalletteNine;
// SVG path parser
import justPath.*;
import justPath.transform.ScaleContext;
import justPath.transform.ScaleTranslateContext;
import justPath.transform.TranslationContext;
import justPath.transform.ScaleTranslateContext;
// Sketching
import trilateral3.drawing.StyleEndLine;
import trilateral3.drawing.Sketch;
import trilateral3.drawing.StyleSketch;
import trilateral3.drawing.Fill;
import trilateral3.drawing.Pen;
// To trace on screen
import kitGL.glWeb.DivertTrace;

import trilateral3.shape.Regular;
import trilateral3.structure.RegularShape;
import trilateral3.shape.StyleRegular;
import trilateral3.shape.IndexRange;
import trilateral3.color.ColorInt;
import trilateral3.structure.ARGB;

function main(){
    new TrilateralRegularColor( 1000, 1000 );
    var divertTrace = new DivertTrace();
    trace("TrilateralRegularColor example");
}
class TrilateralRegularColor extends AppGL {
    var regular: Regular;
    var arr: Array<IndexRange> = [];
    var nines: Array<Int>;
    public function new( width: Int, height: Int ){
        super( width, height );
    }
    override
    public function draw( pen: Pen ){
        regular = new Regular( pen );
        var c: Int = 1;//9*4;
        count = c;
        nines = PalleteNine.ARGB();
        var x = 0;
        var y = 0;
        var dx = 300;
        var dy = 200;
        arr[0] = regular.addRegular( { x: x + dx,   y: y + dy,   radius: 50, color: nines[ c ] },      SQUARE      );
        arr[1] = regular.addRegular( { x: x + dx,   y: y + 2*dy, radius: 50, color: nines[ c + 2] },   PENTAGON    );
        arr[2] = regular.addRegular( { x: x + dx,   y: y + 3*dy, radius: 50, color: nines[ c + 4] },   CIRCLE      );
        arr[3] = regular.addRegular( { x: x + dx,   y: y + 4*dy, radius: 50, color: nines[ c + 6] },   TRIANGLE    );
        arr[4] = regular.addRegular( { x: x + dx*2, y: y + dy,   radius: 50, color: nines[ c + 1 ] },  BAR         );
        arr[5] = regular.addRegular( { x: x + dx*2, y: y + 2*dy, radius: 50, color: nines[ c + 3] },   HEXAGON     );
        arr[6] = regular.addRegular( { x: x + dx*2, y: y + 3*dy, radius: 50, color: nines[ c + 5] },   ROUNDSQUARE );
        arr[7] = regular.addRegular( { x: x + dx*2, y: y + 4*dy, radius: 50, color: nines[ c + 7] },   STAR        );
    }
    var tick = 0;
    var range = 80.; // controls transition speed
    var dStep = 0.;
    var delayStart = 100;
    var count: Int;
    override
    public function renderDraw( pen: Pen ){
        if( tick > delayStart ) {
            var currCount = count;
            for( i in 0...8 ){
                var startEnd = arr[i];
                pen.pos = startEnd.start;
                var col3 = pen.colorType.getTriInt();
                var col = blendRGB( col3.a, cast nines[ count ], dStep );
                pen.colorTriangles( col, Std.int( startEnd.end - startEnd.start + 1 ) );
                count++;
            }
            if( tick % range == 0 ){ // after 50 increase count 
                count++;
                dStep = 0;//1./range;
                if( nines[ count ] == null ) count = 1;//9*4;
            } else {
                dStep += 1./range;
                count = currCount;
            }
        }
        tick++;
    }
    public inline
    function blendRGB( c0: Int, c1: Int, t: Float ): Int {
        // seperate colors
        var col: ColorInt = c0;
        var r0 = col.red;
        var g0 = col.green;
        var b0 = col.blue;
        var colNine: ColorInt = c1;
        var r1 = colNine.red;
        var g1 = colNine.green;
        var b1 = colNine.blue;
        // blend each channel colors
        var v = smootherStep( t );
        var r2 = blend( r0, r1, v );
        var g2 = blend( g0, g1, v );
        var b2 = blend( b0, b1, v );
        // put together
        var argb: ARGB = { a: 1., r: r2, g: g2, b: b2 };
        var colInt: ColorInt = argb;
        var c: Int = colInt;
        return c;
    }
    inline
    function blend( a: Float, b: Float, t: Float ): Float {
        return a + t * ( b - a );
    }
    // Ken Perlin smoothStep 
    inline 
    function smootherStep( t: Float ): Float {
      return t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
    }
}