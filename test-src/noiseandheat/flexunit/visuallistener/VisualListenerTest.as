package noiseandheat.flexunit.visuallistener
{
    import noiseandheat.flexunit.visuallistener.components.Nugget;

    import org.flexunit.asserts.assertEquals;
    import org.flexunit.runner.Description;
    /**
     * Copyright (C) 2011 David Wagner
     */
    public class VisualListenerTest
    {
        [Test]
        public function testInitialNuggetXY():void
        {
            var vl:VisualListener = new VisualListener(Nugget.WIDTH, 100);

            vl.testFinished(new Description("Fake Test 1", []));

            assertEquals("Checking there is 1 nugget", 1, vl.nuggets.length);
            assertEquals("Checking nugget x is correct", 0, vl.nuggets[0].x);
            assertEquals("Checking nugget y is correct", VisualListener.NUGGET_Y_START, vl.nuggets[0].y);
        }

        [Test]
        public function testNuggetsXYWrappedExactWidth():void
        {
            var vl:VisualListener = new VisualListener(Nugget.WIDTH, 100);

            vl.testFinished(new Description("Fake Test 1", []));
            assertEquals("Checking there is 1 nugget", 1, vl.nuggets.length);
            assertEquals("Checking nugget 1 x is correct", 0, vl.nuggets[0].x);
            assertEquals("Checking nugget 1 y is correct", VisualListener.NUGGET_Y_START, vl.nuggets[0].y);

            vl.testFinished(new Description("Fake Test 2", []));
            assertEquals("Checking there are 2 nuggets", 2, vl.nuggets.length);
            assertEquals("Checking nugget 2 x is correct", 0, vl.nuggets[1].x);
            assertEquals("Checking nugget 2 y is correct", vl.nuggets[0].y + Nugget.HEIGHT, vl.nuggets[1].y);
        }

        [Test]
        public function testNuggetsXYNotWrapped():void
        {
            var vl:VisualListener = new VisualListener(Nugget.WIDTH * 2, 100);

            vl.testFinished(new Description("Fake Test 1", []));
            assertEquals("Checking there is 1 nugget", 1, vl.nuggets.length);
            assertEquals("Checking nugget 1 x is correct", 0, vl.nuggets[0].x);
            assertEquals("Checking nugget 1 y is correct", VisualListener.NUGGET_Y_START, vl.nuggets[0].y);

            vl.testFinished(new Description("Fake Test 2", []));
            assertEquals("Checking there are 2 nuggets", 2, vl.nuggets.length);
            assertEquals("Checking nugget 2 x is correct", Nugget.WIDTH, vl.nuggets[1].x);
            assertEquals("Checking nugget 2 y is correct", VisualListener.NUGGET_Y_START, vl.nuggets[1].y);
        }
    }
}
