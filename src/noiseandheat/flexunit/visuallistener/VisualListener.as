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
package noiseandheat.flexunit.visuallistener
{
    import noiseandheat.flexunit.visuallistener.components.Nugget;
    import org.flexunit.runner.IDescription;
    import org.flexunit.runner.Result;
    import org.flexunit.runner.notification.Failure;
    import org.flexunit.runner.notification.IRunListener;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.system.System;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.utils.Dictionary;

    /**
     * Visual flexunit results listener. To use, add to the stage,
     * add it as a listener to the FlexUnitCore, and then run.
     *
     * Best enjoyed with a fine glass of single malt whisky.
     */
    public class VisualListener
        extends Sprite
        implements IRunListener
    {
        protected var descriptionToNuggetIndex:Dictionary;
        protected var nuggets:Vector.<Nugget>;
        protected var nextNuggetY:int;
        protected var nextNuggetX:int;

        protected var tiptext:TextField;

        public function VisualListener()
        {
            descriptionToNuggetIndex = new Dictionary();
            nuggets = new Vector.<Nugget>();

            tiptext = createTipText();
            addChild(tiptext);
        }

        protected function createTipText():TextField
        {
            var t:TextField = new TextField();
            t.visible = false;
            t.multiline = false;
            t.mouseEnabled = false;
            t.wordWrap = false;
            t.background = true;
            t.backgroundColor = 0xffffff;

            var tf:TextFormat = t.defaultTextFormat;
            tf.font = "Arial";
            tf.size = 14;

            t.defaultTextFormat = tf;

            return t;
        }

        protected function fetchNugget(description:IDescription):Nugget
        {
            if(descriptionToNuggetIndex[description] == undefined)
            {
                return createNugget(description);
            }
            else
            {
                return nuggets[descriptionToNuggetIndex[description]];
            }
        }

        protected function createNugget(description:IDescription):Nugget
        {
            var nugget:Nugget = new Nugget(description);

            nugget.x = nextNuggetX;
            nugget.y = nextNuggetY;

            nugget.addEventListener(MouseEvent.MOUSE_OVER, overNugget);
            nugget.addEventListener(MouseEvent.MOUSE_OUT, outNugget);
            nugget.addEventListener(MouseEvent.CLICK, clickNugget);

            addChild(nugget);

            nextNuggetX += nugget.width;

            var p:Point = new Point(nextNuggetX, nextNuggetY);
            p = localToGlobal(p);
            if(p.x > stage.stageWidth)
            {
                nextNuggetY += nugget.height;
                nextNuggetX = 0;
            }

            if(description)  descriptionToNuggetIndex[description] = nuggets.length;
            nuggets.push(nugget);

            return nugget;
        }

        protected function overNugget(event:MouseEvent):void
        {
            var nugget:Nugget = event.target as Nugget;
            if(nugget != null)
            {
                tiptext.text = nugget.toString();
                tiptext.width = tiptext.textWidth + 5;
                tiptext.height = tiptext.textHeight + 5;

                tiptext.x = nugget.x;
                tiptext.y = nugget.y - tiptext.height;

                var r:Rectangle = tiptext.getBounds(stage);

                if(r.y < 0)
                {
                  tiptext.y = nugget.y + nugget.height + 16;
                }

                if(r.right > stage.stageWidth)
                {
                    var diff:int = r.right - stage.stageWidth;
                    if(r.x - diff < 0)
                    {
                        diff = r.x;
                    }

                    tiptext.x -= diff;
                }

                setChildIndex(tiptext, numChildren - 1);

                dimNuggets();
                undimNugget(nugget);

                tiptext.visible = true;
            }
            else
            {
                trace("We don't seem to be targetting a nugget despite getting an event. Most peculiar.");
            }
        }

        protected function undimNugget(nugget:Nugget):void
        {
            nugget.alpha = 1.0;
        }

        protected function dimNugget(nugget:Nugget):void
        {
            nugget.alpha = 0.25;
        }

        protected function dimNuggets():void
        {
            for(var i:int = 0; i < nuggets.length; i++)
            {
                dimNugget(nuggets[i]);
            }
        }

        protected function undimNuggets():void
        {
            for(var i:int = 0; i < nuggets.length; i++)
            {
                undimNugget(nuggets[i]);
            }
        }

        protected function outNugget(event:MouseEvent):void
        {
            var nugget:Nugget = event.target as Nugget;
            if(nugget != null)
            {
                undimNuggets();
                tiptext.visible = false;
            }
            else
            {
                trace("We don't seem to be targetting a nugget despite getting an event. Most peculiar.");
            }
        }

        protected function clickNugget(event:MouseEvent):void
        {
            var nugget:Nugget = event.target as Nugget;
            if(nugget != null)
            {
                System.setClipboard(nugget.toFullString());
                tiptext.visible = false;
            }
            else
            {
                trace("We don't seem to be targetting a nugget despite getting an event. Most peculiar.");
            }
        }

        public function testIgnored(description:IDescription):void
        {
            var n:Nugget = fetchNugget(description);
            if(description.isSuite)
            {
                n.state = Nugget.STATE_SUITE;
            }
            else
            {
                n.state = Nugget.STATE_IGNORED;
            }

            trace("testIgnored: " + n);
        }

        public function testFinished(description:IDescription):void
        {
            var n:Nugget = fetchNugget(description);
            if(description.isSuite)
            {
                n.state = Nugget.STATE_SUITE;
            }
            else
            {
                n.state = Nugget.STATE_FINISHED;
            }

            trace("testFinished: " + n);
        }

        public function testStarted(description:IDescription):void
        {
            var n:Nugget = fetchNugget(description);
             if(description.isSuite)
            {
                n.state = Nugget.STATE_SUITE;
            }
            else
            {
               n.state = Nugget.STATE_STARTED;
            }

            trace("testStarted: " + n);
        }

        public function testRunStarted(description:IDescription):void
        {
            var n:Nugget = fetchNugget(description);
            if(description.isSuite)
            {
                n.state = Nugget.STATE_SUITE;
            }
            else
            {
                n.state = Nugget.STATE_RUN_STARTED;
            }

            trace("testRunStarted: " + n);
        }

        public function testRunFinished(result:Result):void
        {
            var n:Nugget = createNugget(null);
            if(result.successful)
            {
                n.state = Nugget.STATE_RUN_FINISHED_SUCCESS;
                n.message = "Test run successful";
            }
            else
            {
                n.state = Nugget.STATE_RUN_FINISHED_FAILURE;
                n.message = "Test run failed";
            }

            trace("testRunFinished: " + n);
        }

        public function testAssumptionFailure(failure:Failure):void
        {
            var n:Nugget = fetchNugget(failure.description);
            if(failure.description.isSuite)
            {
                n.state = Nugget.STATE_SUITE;
            }
            else
            {
                n.state = Nugget.STATE_ASSUMPTION_FAILURE;
            }
            n.message = failure.message;
            n.stackTrace = failure.stackTrace;
            trace("testAssumptionFailure: " + n);
        }

        public function testFailure(failure:Failure):void
        {
            var n:Nugget = fetchNugget(failure.description);
            if(failure.description.isSuite)
            {
                n.state = Nugget.STATE_SUITE;
            }
            else
            {
                n.state = Nugget.STATE_FAILURE;
            }
            n.message = failure.message;
            n.stackTrace = failure.stackTrace;
            trace("testFailure: " + n);
        }
    }
}
