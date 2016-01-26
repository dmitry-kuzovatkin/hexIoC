package hex.ioc.parser.xml.mock;

import hex.module.dependency.IRuntimeDependencies;
import hex.module.dependency.RuntimeDependencies;
import hex.module.Module;

/**
 * ...
 * @author Francis Bourre
 */
class MockMappedModule extends Module implements IMockMappedModule
{
	public function new() 
	{
		super();
	}
	
	public function doSomething() : Void 
	{
		
	}
	
	override function _getRuntimeDependencies() : IRuntimeDependencies
	{
		return new RuntimeDependencies();
	}
}