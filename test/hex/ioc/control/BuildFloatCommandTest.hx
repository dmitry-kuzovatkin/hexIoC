package hex.ioc.control;

import hex.error.IllegalArgumentException;
import hex.ioc.vo.BuildHelperVO;
import hex.ioc.vo.ConstructorVO;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class BuildFloatCommandTest
{
	@Test( "Test execute with positive value" )
    public function testExecuteWithPositiveValue() : Void
    {
		var cmd = new BuildFloatCommand();
		var helper = new BuildHelperVO();
		helper.constructorVO 		= new ConstructorVO( "test", "Float", ["4.7"] );
		cmd.execute( helper );
		Assert.equals( 4.7, helper.constructorVO.result, "constructorVO.result should equal '4.7'" );
	}
	
	@Test( "Test execute with negative value" )
    public function testExecuteWithNegativeValue() : Void
    {
		var cmd = new BuildFloatCommand();
		var helper = new BuildHelperVO();
		helper.constructorVO 		= new ConstructorVO( "test", "Float", ["-3.8"] );
		cmd.execute( helper );
		Assert.equals( -3.8, helper.constructorVO.result, "constructorVO.result should equal '-3.8'" );
	}
	
	@Test( "Test execute with invalid argument" )
    public function testExecuteWithInvalidArgument() : Void
    {
		var cmd = new BuildFloatCommand();
		var helper = new BuildHelperVO();
		helper.constructorVO 			= new ConstructorVO( "test", "Float", ["a"] );
		Assert.methodCallThrows( IllegalArgumentException, cmd, cmd.execute, [ helper ], "command execution should throw IllegalArgumentException" );
	}
	
	@Test( "Test execute with no argument array" )
    public function testExecuteWithNoArgumentArray() : Void
    {
		var cmd = new BuildFloatCommand();
		var helper = new BuildHelperVO();
		helper.constructorVO 			= new ConstructorVO( "test", "Float", null );
		Assert.methodCallThrows( IllegalArgumentException, cmd, cmd.execute, [ helper ], "command execution should throw IllegalArgumentException" );
	}
	
	@Test( "Test execute with empty argument array" )
    public function testExecuteWithEmptyArgumentArray() : Void
    {
		var cmd = new BuildFloatCommand();
		var helper = new BuildHelperVO();
		helper.constructorVO 			= new ConstructorVO( "test", "Float", [] );
		Assert.methodCallThrows( IllegalArgumentException, cmd, cmd.execute, [ helper ], "command execution should throw IllegalArgumentException" );
	}
	
	@Test( "Test execute with null argument" )
    public function testExecuteWithNullArgument() : Void
    {
		var cmd = new BuildFloatCommand();
		var helper = new BuildHelperVO();
		helper.constructorVO 			= new ConstructorVO( "test", "Float", [null] );
		Assert.methodCallThrows( IllegalArgumentException, cmd, cmd.execute, [ helper ], "command execution should throw IllegalArgumentException" );
	}
}