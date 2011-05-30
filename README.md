FlexUnit Visualiser
===================

Simple graphical test run visualiser for FlexUnit. Green dots good, red dots bad. Mouse over them for more information. If you have lots of tests, you will have to implement your own scrolling just now.

Sample test runner:

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
	            core = new FlexUnitCore();
	            VisualTestEnvironmentBuilder.getInstance(this);

	            listener = new VisualListener();
	            addChild(listener);
	            core.addListener(listener);
	            
	            // Add a trace listener too if you want some trace output
                core.addListener(new TraceListener());

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
