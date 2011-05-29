/**
 * Licensed under the MIT license:
 *
 *     http://www.opensource.org/licenses/mit-license.php
 *
 * (c) Copyright 2011 David Wagner.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package
{
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import noiseandheat.NoiseAndHeatSuite;
    import noiseandheat.flexunit.visuallistener.VisualListener;
    import org.flexunit.runner.FlexUnitCore;
    import org.fluint.uiImpersonation.VisualTestEnvironmentBuilder;

    [SWF(backgroundColor="#000000", frameRate="120", width="800", height="600")]
    public class TestRunner extends Sprite
    {
        private var core:FlexUnitCore;
        private var listener:VisualListener;

        public function TestRunner()
        {
            // Launch your unit tests by right clicking within this class and select: Run As > FDT SWF Application

            // Instantiate the core.
            core = new FlexUnitCore();
            // This registers the stage with the VisualTestEnvironmentBuilder, which allows you
            // to use the UIImpersonator classes to add to the display list and remove from within your
            // tests. With Flex, this is done for you, but in AS projects it needs to be handled manually.
            VisualTestEnvironmentBuilder.getInstance(this);

            // Add any listeners. In this case, the TraceListener has been added to display results.
            listener = new VisualListener();
            addChild(listener);
            core.addListener(listener);

            // There should be only 1 call to run().
            // You can pass a comma separated list (or an array) of tests or suites.
            // You can also pass a Request Object, which allows you to sort, filter and subselect.
            // var request:Request = Request.methods( someClass, ["method1", "method2", "method3"] ).sortWith( someSorter ).filterWith( someFilter );
            // core.run( request );
            core.run(NoiseAndHeatSuite);

            addEventListener(Event.ADDED_TO_STAGE, addedToStage);
        }

        protected function addedToStage(event:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, addedToStage);

            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
        }
    }
}
