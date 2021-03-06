package hex.ioc.parser.xml.assembler.mock;

import hex.control.Request;
import hex.control.command.BasicCommand;
import hex.di.IInjectorContainer;
import hex.ioc.assembler.ApplicationContext;

/**
 * ...
 * @author Francis Bourre
 */
class MockStateCommand extends BasicCommand implements IInjectorContainer
{
	static public var callCount : Int = 0;
	static public var lastInjecteContext : ApplicationContext;
	
	@Inject
	public var context : ApplicationContext;
	
	public function execute( ?request : Request ) : Void 
	{
		MockStateCommand.callCount++;
		MockStateCommand.lastInjecteContext = this.context;
	}
}