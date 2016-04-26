package hex.ioc.control;

import hex.ioc.vo.BuildHelperVO;
import hex.ioc.vo.ConstructorVO;

/**
 * ...
 * @author Francis Bourre
 */
class BuildObjectCommand implements IBuildCommand
{
	public function new()
	{

	}

	public function execute( buildHelperVO : BuildHelperVO ) : Void
	{
		buildHelperVO.constructorVO.result = { };
		
		#if macro
		if ( !buildHelperVO.constructorVO.isProperty )
		{
			buildHelperVO.expressions.push( macro @:mergeBlock { lastResult = {}; } );
		}
		#end
	}
}