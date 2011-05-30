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
    import noiseandheat.flexunit.visuallistener.VisualListener;
    import noiseandheatexample.NoiseAndHeatExampleSuite;
    import org.flexunit.internals.TraceListener;
    import org.flexunit.runner.FlexUnitCore;
    import org.fluint.uiImpersonation.VisualTestEnvironmentBuilder;

    [SWF(backgroundColor="#000000", frameRate="120", width="400", height="300")]
    public class TestRunnerExample extends Sprite
    {
        private var core:FlexUnitCore;
        private var listener:VisualListener;

        public function TestRunnerExample()
        {
            core = new FlexUnitCore();
            VisualTestEnvironmentBuilder.getInstance(this);

            listener = new VisualListener(400, 300);
            addChild(listener);
            core.addListener(listener);
            core.addListener(new TraceListener());

            core.run(NoiseAndHeatExampleSuite);

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
