package hex.ioc.control;

import hex.ioc.vo.BuildHelperVO;
import hex.ioc.vo.ConstructorVO;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class BuildArrayCommandTest
{
	@Test( "Test executet" )
    public function testExecute() : Void
    {
		var cmd = new BuildArrayCommand();
		var helper = new BuildHelperVO();
		helper.constructorVO 			= new ConstructorVO( "test", "Array", [3, "hello world"] );
		cmd.execute( helper );
		Assert.isInstanceOf( helper.constructorVO.result, Array, "constructorVO.result should be an instance of Array class" );
		Assert.deepEquals( [3, "hello world"], helper.constructorVO.result, "constructorVO.result should agregate the same elements" );
	}
	
	@Test( "Test execute with no argument array" )
    public function testExecuteWithNoArgumentArray() : Void
    {
		var cmd = new BuildArrayCommand();
		var helper = new BuildHelperVO();
		helper.constructorVO 			= new ConstructorVO( "test", "Array", null );
		cmd.execute( helper );
		Assert.isInstanceOf( helper.constructorVO.result, Array, "constructorVO.result should be an instance of Array class" );
	}
	
	@Test( "Test execute with empty argument array" )
    public function testExecuteWithEmptyArgumentArray() : Void
    {
		var cmd = new BuildArrayCommand();
		var helper = new BuildHelperVO();
		helper.constructorVO 			= new ConstructorVO( "test", "Array", [] );
		cmd.execute( helper );
		Assert.isInstanceOf( helper.constructorVO.result, Array, "constructorVO.result should be an instance of Array class" );
	}
	
	@Test( "Test execute with null argument" )
    public function testExecuteWithNullArgument() : Void
    {
		var cmd = new BuildArrayCommand();
		var helper = new BuildHelperVO();
		helper.constructorVO 			= new ConstructorVO( "test", "Array", [null] );
		cmd.execute( helper );
		Assert.isInstanceOf( helper.constructorVO.result, Array, "constructorVO.result should be an instance of Array class" );
		Assert.deepEquals( [null], helper.constructorVO.result, "constructorVO.result should agregate the same elements" );
	}
	
}